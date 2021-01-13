//
//  UIColorExtension.swift
//  WCFMainModule
//
//  Created by wenchang on 2020/12/29.
//

import Foundation
import UIKit

extension UIColor {
    @objc convenience init(r : CGFloat, g : CGFloat, b : CGFloat){
        self.init(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: 1.0);
    }
    //简化RGB颜色写法
    @objc class func RGBA(_ r : UInt, g : UInt, b : UInt, a : CGFloat) -> UIColor {
        let redFloat = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue = CGFloat(b) / 255.0
        return UIColor(red: redFloat, green: green, blue: blue, alpha: a)
    }
    //随机色
    class func randomColor() -> UIColor {
        return UIColor(r: CGFloat(arc4random_uniform(256)), g: CGFloat(arc4random_uniform(256)), b: CGFloat(arc4random_uniform(256)));
    }
    //16进制颜色self.init
    @objc convenience init (_ hex: String, alpha : CGFloat = 1.0) {
        var hex = hex
        if hex.hasPrefix("#") {
            hex = hex.replacingOccurrences(of: "#", with: "")
        }
        
        let redHex = String(hex[hex.startIndex...hex.index(hex.startIndex, offsetBy: 1)])
        let greenHex = String(hex[hex.index(hex.startIndex, offsetBy: 2)...hex.index(hex.startIndex, offsetBy: 3)])
        let blueHex = String(hex[hex.index(hex.startIndex, offsetBy: 4)...hex.index(hex.startIndex, offsetBy: 5)])
        
        var redInt:   CUnsignedInt = 0
        var greenInt: CUnsignedInt = 0
        var blueInt:  CUnsignedInt = 0
        
        Scanner(string: redHex).scanHexInt32(&redInt)
        Scanner(string: greenHex).scanHexInt32(&greenInt)
        Scanner(string: blueHex).scanHexInt32(&blueInt)

        self.init(red: CGFloat(redInt) / 255.0, green: CGFloat(greenInt) / 255.0, blue: CGFloat(blueInt) / 255.0, alpha: CGFloat(alpha))
    }
}

/// 全局字号配置
let Font16 = UIFont.systemFont(ofSize: 16)
let Font15 = UIFont.systemFont(ofSize: 15)
let Font13 = UIFont.systemFont(ofSize: 13)
