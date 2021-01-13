//
//  SEMapPoiListView.swift
//  SEMapFunctionHandler
//
//  Created by wenchang on 2021/1/4.
//

import UIKit
import AMapSearchKit
import MJRefresh
protocol SEMapPoiListViewDelegate {
    func setMapCenterWithPOI(point: AMapPOI,isLocateImageShouldChange: Bool)
    func mapPoiListViewSearch(content keyword: String)
    func loadMorePoi()
}

class SEMapPoiListView: UIView {

    open var delegate: SEMapPoiListViewDelegate?
    var selectedPoi: AMapPOI?
    lazy var dataSource = [AMapPOI]()
    lazy var selectUid = ""
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        addSubview(searchView)
        addSubview(tableView)
//        addSubview(searchTableView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func changeTableViewHeight() {
        self.tableView.frame = CGRect.init(x: 0, y: 60, width: self.bounds.width, height: self.bounds.height - 60)
    }
    
    @objc func loadMoreData() {
        self.delegate?.loadMorePoi()
    }
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.init(x: 0, y: 60, width: self.bounds.width, height: self.bounds.height - 60), style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 60
        tableView.separatorStyle = .none
        tableView.register(SEMapPoiListViewCell.self, forCellReuseIdentifier: "\(SEMapPoiListViewCell.classForCoder())")
        tableView.mj_footer = MJRefreshAutoNormalFooter.init(refreshingTarget: self, refreshingAction: #selector(loadMoreData))
        tableView.keyboardDismissMode = .onDrag
        return tableView
    }()
    
    lazy var searchView: UIView = {
        let searchView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: self.bounds.width, height: 60))
        searchView.addSubview(searchTextField)
        searchView.isUserInteractionEnabled = true
        searchView.backgroundColor = .white
        
        return searchView
    }()
    
    lazy var searchTextField: UITextField = {
        let searchTextField = UITextField.init(frame: CGRect.init(x: 15, y: 12.5, width: self.bounds.width - 30, height: 35))
        searchTextField.backgroundColor = UIColor(red: 238 / 255, green: 238 / 255, blue: 238 / 255, alpha: 1)
        searchTextField.layer.masksToBounds = true
        searchTextField.layer.cornerRadius = 17.5
        searchTextField.placeholder = "搜索位置"
        searchTextField.returnKeyType = .search
        let searchImgV = UIImageView(image: UIImage(imageName: "search", currentClass:SEMapMainController.classForCoder()))
        searchImgV.frame = CGRect.init(x: 22, y: 9, width: 18, height: 18)
        let leftView = UIView(frame: CGRect.init(x: 0, y: 0, width: 52, height: 35))
        leftView.addSubview(searchImgV)
        
        searchTextField.leftView = leftView
        searchTextField.leftViewMode = .always
        
        searchTextField.delegate = self
        
        searchTextField.addTarget(self, action: #selector(textDidChange(_:)), for: .editingChanged)
        
        return searchTextField
    }()
}

extension SEMapPoiListView: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(SEMapPoiListViewCell.classForCoder())") as! SEMapPoiListViewCell
        cell.mapPoi = dataSource[indexPath.row]
        cell.isAddressUnSelected = selectUid != cell.mapPoi?.uid
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let aMapPOI = dataSource[indexPath.row]
        selectUid = aMapPOI.uid
        self.tableView.reloadData()
        delegate?.setMapCenterWithPOI(point: aMapPOI, isLocateImageShouldChange: true)
    }
}

extension SEMapPoiListView: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.tableView.isHidden = true
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        self.tableView.isHidden = false
        return true
    }
    
    @objc func textDidChange(_ textField:UITextField) {
        delegate?.mapPoiListViewSearch(content: textField.text ?? "")
    }
        
}
