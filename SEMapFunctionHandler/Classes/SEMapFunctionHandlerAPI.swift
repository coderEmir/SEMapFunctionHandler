//
//  SEMapFunctionHandlerAPI.swift
//  SEMapFunctionHandler
//
//  Created by wenchang on 2021/1/13.
//

import UIKit
@objc public class SEMapFunctionHandlerAPI: NSObject {
    
    @objc static public func presentMapController(fromController controller: UIViewController, apiKey: String, locationInfo: @escaping (_ clipImage: UIImage, _ locationName: String) -> ()) {
        let mapController = SEMapMainController()
        mapController.apiKey = apiKey
        mapController.makeSureLocation(callBack: locationInfo)
        let navVc = UINavigationController.init(rootViewController: mapController)
        navVc.modalPresentationStyle = .overFullScreen
        controller.present(navVc, animated: true, completion: nil)
    }
}

