//
//  SEMapMainController.swift
//  SEMapFunctionHandler
//
//  Created by wenchang on 2021/1/4.
//

import UIKit
import AMapFoundationKit
import AMapSearchKit
import Reachability

let NavigationBarH = 44 + UIApplication.shared.statusBarFrame.height

public typealias LocationBlock = (_ clipImage: UIImage, _ locationName: String) -> ()
@objc public class SEMapMainController: UIViewController {
    
    var reachability: Reachability?
    
    var isFirstLocated = false
    var isMapViewRegionChangedFromTableView = false
    var locationBlock: LocationBlock?
    
    var searchPage = 1
    
    var searchAPI: AMapSearchAPI = AMapSearchAPI()
    
    var city: String?
    var locationText: String = ""
    lazy var searchRequest = AMapPOIKeywordsSearchRequest()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        AMapServices.shared()?.apiKey = "28ae2ab4cbd849f03fb35497cd3e35d6"
        
        view.backgroundColor = .white
        view.addSubview(mapView)
        view.addSubview(centerMarkerImgV)
        view.addSubview(locationBtn)
        view.addSubview(listView)
        searchAPI.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged), name: NSNotification.Name(rawValue: "kReachabilityChangedNotification"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(showKeyboard(noti:)), name: UIResponder.keyboardWillShowNotification, object: nil)

        reachability = Reachability.forInternetConnection()
        reachability?.startNotifier()
        
        createNavgationBar(customTitle: "地图", leftItemName: "", leftItemImageName: "left_back", rightItemName: "完成")
    }
    
    deinit {
        reachability?.stopNotifier()
        NotificationCenter.default.removeObserver(self)
    }
    
    public func makeSureLocation(callBack: @escaping LocationBlock) {
        self.locationBlock = callBack
    }
    
    /// 搜索中心点坐标周围的POI-AMapGeoPoint
    func searchReGeocodeWithAMapGeoPoint(point: AMapGeoPoint) {
        let regeo = AMapReGeocodeSearchRequest.init()
        regeo.location = point
        regeo.requireExtension = true
        searchAPI.aMapReGoecodeSearch(regeo)
    }
    
    func searchPoiByAMapGeoPoint(point: AMapGeoPoint) {
        let request = AMapPOIAroundSearchRequest.init()
        request.location = point
        request.radius = 1000
        request.sortrule = 1
        request.page = searchPage
        searchAPI.aMapPOIAroundSearch(request)
    }
    
    @objc func showKeyboard(noti: Notification) {
        self.title = "搜索"
        let userInfo = noti.userInfo! as Dictionary
        let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey]
        UIView.animate(withDuration: duration as! TimeInterval) {
            self.listView.frame = CGRect.init(x: 0, y: self.mapView.frame.minY, width: self.mapView.bounds.width, height: UIScreen.main.bounds.height - NavigationBarH)
            self.listView.changeTableViewHeight()
        }
    }
    
    //MARK: navigationBarItem event
    @objc override func leftItemEvent() {
        
        if self.title == "搜索" {
            showMapView()
            return
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    override func rightItemEvent() {
        let mapCenter = mapView.center
        let mapClipSize = CGSize(width: UIScreen.main.bounds.width, height: 80)
        UIGraphicsBeginImageContextWithOptions(mapClipSize, false, 0.0)
        let clipRect = CGRect(x: -mapCenter.x + mapClipSize.width * 0.5, y: -mapCenter.y + mapClipSize.height, width: mapView.bounds.width, height: mapView.bounds.height)
        mapView.drawHierarchy(in: clipRect, afterScreenUpdates: true)
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else { return }
        self.locationBlock?(image, locationText)
    }
    
    func showMapView() {
        self.listView.searchTextField.resignFirstResponder()
        UIView.animate(withDuration: 0.25) {
            let listViewY = self.mapView.frame.maxY
            self.listView.frame = CGRect.init(x: 0, y: listViewY, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - listViewY)
            self.listView.changeTableViewHeight()
        }
        self.setEditing(false, animated: false)
        self.title = "地图"
    }
    
    @objc func reachabilityChanged() {
        let status = reachability?.currentReachabilityStatus()
        switch status {
        case .ReachableViaWWAN, .ReachableViaWiFi:
            if isFirstLocated {
                let latitude = CGFloat(mapView.centerCoordinate.latitude)
                let longitude = CGFloat(mapView.centerCoordinate.longitude)
                guard let point = AMapGeoPoint.location(withLatitude: latitude, longitude: longitude) else { return }
                searchReGeocodeWithAMapGeoPoint(point: point)
                searchPoiByAMapGeoPoint(point: point)
            }
        default:
            do{}
        }
    }
    
    @objc func actionLocation() {
        mapView.setCenter(mapView.userLocation.coordinate, animated: true)
    }
    
    @objc lazy var centerMarkerImgV: UIImageView = {
        let marker = UIImage(imageName: "centerMarker", currentClass:SEMapMainController.classForCoder())
        guard marker != nil else { return UIImageView() }
        let centerMarkerImgV = UIImageView.init(image: marker)
        centerMarkerImgV.frame = CGRect.init(x: (view.frame.width - (marker?.size.width)!) * 0.5, y: (view.frame.height - (marker?.size.height)!) * 0.5, width: (marker?.size.width)!, height: (marker?.size.height)!)
        centerMarkerImgV.center = CGPoint(x: view.frame.width * 0.5, y: (mapView.bounds.height - centerMarkerImgV.frame.height) * 0.5 + NavigationBarH)
        return centerMarkerImgV
    }()
    
    lazy var mapView: MAMapView = {
        let mapView = MAMapView.init(frame: CGRect.init(x: 0, y: NavigationBarH, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 380))
        mapView.showsCompass = false
        mapView.showsScale = false
        mapView.zoomLevel = 16
        mapView.isShowsUserLocation = true
        mapView.userTrackingMode = .follow
        mapView.delegate = self
        
        return mapView
    }()
    
    lazy var imageNotLocate: UIImage? = {
        let imageNotLocate = UIImage(imageName: "gpsnormal", currentClass:SEMapMainController.classForCoder())
        return imageNotLocate
    }()
    
    lazy var locationBtn: UIButton = {
        let locationBtn = UIButton.init(frame: CGRect.init(x: mapView.bounds.width - 50, y: mapView.bounds.height - 50 + NavigationBarH, width: 40, height: 40))
        locationBtn.autoresizingMask = .flexibleTopMargin
        locationBtn.layer.cornerRadius = 3
        locationBtn.addTarget(self, action: #selector(actionLocation), for: .touchUpInside)
        locationBtn.setImage(imageNotLocate, for: .normal)
        return locationBtn
    }()
    
    lazy var listView: SEMapPoiListView = {
        let listViewY = mapView.frame.maxY
        let listView = SEMapPoiListView.init(frame: CGRect.init(x: 0, y: listViewY, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - listViewY))
        listView.delegate = self
        return listView
    }()
}

extension SEMapMainController: MAMapViewDelegate {
    
    public func mapView(_ mapView: MAMapView!, didUpdate userLocation: MAUserLocation!, updatingLocation: Bool) {
        guard updatingLocation && !isFirstLocated else { return }
        guard userLocation.location != nil else { return }

        mapView.centerCoordinate = userLocation.location.coordinate
        locationText = userLocation.title
        isFirstLocated = true
    }
    
    public func mapView(_ mapView: MAMapView!, regionDidChangeAnimated animated: Bool) {
        guard isFirstLocated && !isMapViewRegionChangedFromTableView else { return }

        let latitude = CGFloat(mapView.centerCoordinate.latitude)
        let longitude = CGFloat(mapView.centerCoordinate.longitude)
        guard let point = AMapGeoPoint.location(withLatitude: latitude, longitude: longitude) else { return }
        
        searchReGeocodeWithAMapGeoPoint(point: point)
        searchPoiByAMapGeoPoint(point: point)
        searchPage = 1;
        isMapViewRegionChangedFromTableView = false
    }
    
    public func mapView(_ mapView: MAMapView!, viewFor annotation: MAAnnotation!) -> MAAnnotationView! {
        guard annotation is MAPointAnnotation else { return nil}
        let reuseIndetifier = "anntationReuseIndetifier"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIndetifier) as MAAnnotationView?
        if annotationView == nil {
            annotationView = MAAnnotationView.init(annotation: annotation, reuseIdentifier: reuseIndetifier)
            annotationView?.image = UIImage(imageName: "msg_location", currentClass:SEMapMainController.classForCoder())
            annotationView?.centerOffset = CGPoint.init(x:0, y:-18)
        }
        return annotationView
    }
    
    public func mapView(_ mapView: MAMapView!, didAddAnnotationViews views: [Any]!) {
       
        let view: MAAnnotationView = views.first as! MAAnnotationView
        guard view.annotation is MAUserLocation else { return }
        
        let pre = MAUserLocationRepresentation()
        pre.showsAccuracyRing = false
        mapView.update(pre)
        view.calloutOffset = .zero
    }
}

extension SEMapMainController: SEMapPoiListViewDelegate {
    
    func setMapCenterWithPOI(point: AMapPOI, isLocateImageShouldChange: Bool) {
        if isLocateImageShouldChange {
            locationBtn.setImage(imageNotLocate, for: .normal)
        }
        
        locationText = point.name
        
        var coordinate2D = CLLocationCoordinate2D()
        coordinate2D.latitude = CLLocationDegrees(point.location.latitude)
        coordinate2D.longitude = CLLocationDegrees(point.location.longitude)
        mapView.setCenter(coordinate2D, animated: true)
        
        if listView.frame.minY > self.mapView.frame.minY { return }
        showMapView()
    }
    
    func mapPoiListViewSearch(content keyword: String) {
        //POI关键字搜索
        listView.tableView.mj_footer?.state = .idle
        
        searchRequest.keywords = keyword
        searchRequest.requireExtension = true
        searchRequest.city = city

        searchRequest.cityLimit = true
        searchRequest.requireSubPOIs = true
        
        searchAPI.aMapPOIKeywordsSearch(searchRequest)
    }
    
    func loadMorePoi() {
        searchPage += 1
        let latitude = CGFloat(mapView.centerCoordinate.latitude)
        let longitude = CGFloat(mapView.centerCoordinate.longitude)
        guard let point = AMapGeoPoint.location(withLatitude: latitude, longitude: longitude) else { return }
        searchPoiByAMapGeoPoint(point: point)
    }
}

extension SEMapMainController: AMapSearchDelegate {
    public func onPOISearchDone(_ request: AMapPOISearchBaseRequest!, response: AMapPOISearchResponse!) {
        listView.tableView.isHidden = false
        if response.pois.count == 0 {
            listView.tableView.mj_footer?.state = .noMoreData
            return
        }
        listView.tableView.mj_footer?.state = .idle
        if searchPage == 1 {
            listView.dataSource.removeAll()
        }
        response.pois.forEach { mapPoi in
            listView.dataSource.append(mapPoi)
        }
        listView.tableView.reloadData()
    }
    public func onInputTipsSearchDone(_ request: AMapInputTipsSearchRequest!, response: AMapInputTipsSearchResponse!) {
        
    }
    public func onReGeocodeSearchDone(_ request: AMapReGeocodeSearchRequest!, response: AMapReGeocodeSearchResponse!) {
        guard response.regeocode != nil else { return }
        let address = response.regeocode.formattedAddress as NSString
        let component = response.regeocode.addressComponent
        city = component?.city
        guard let province = component?.province else { return }
        address.replacingOccurrences(of: province, with: "")
    }
}
