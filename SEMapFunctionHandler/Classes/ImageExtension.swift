//
//  WCFImage.swift
//  WCFMainModule
//
//  Created by wenchang on 2020/12/29.
//

import UIKit

extension UIImage {

    convenience init?(imageName: String, currentClass: AnyClass) {
        let codeBundlePath = (Bundle(for: currentClass).path(forResource: "SEMapFunctionHandler.bundle", ofType: nil) ?? "") as NSString
        let filePath = codeBundlePath.appendingPathComponent((imageName + "@2x.png"))
        self.init(contentsOfFile: filePath)
    }
}
