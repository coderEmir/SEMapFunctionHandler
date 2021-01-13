//
//  SEMapFunctionHandlerAPI.swift
//  SEMapFunctionHandler
//
//  Created by wenchang on 2021/1/13.
//

import UIKit
@objc public class SEMapFunctionHandlerAPI: NSObject {
    
    @objc static public func presentMapController(fromController controller: UIViewController, locationInfo: @escaping (_ clipImage: UIImage, _ locationName: String) -> ()) {
        let controller = SEMapMainController()
        controller.makeSureLocation(callBack: locationInfo)
        let navVc = UINavigationController.init(rootViewController: controller)
        navVc.modalPresentationStyle = .overFullScreen
        controller.present(navVc, animated: true, completion: nil)
    }
}

