//
//  UIViewControllerExtension.swift
//  WCFMainModule
//
//  Created by xKing on 2021/1/3.
//

import Foundation
import UIKit

extension UIViewController {
    
    func createNavgationBar() {
        // MARK: 预览
        self.title = "编辑"
        let previewBtn = UIButton(frame: CGRect.init(x: 0, y: 0, width: 70, height: 25))
        previewBtn.setTitle("预览", for: .normal)
        previewBtn.setTitleColor(.white, for: .normal)
        previewBtn.layer.cornerRadius = 17
        previewBtn.backgroundColor = UIColor("#AF3F27")
        previewBtn.addTarget(self, action: #selector(previewEvent), for: .touchUpInside)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: previewBtn)
        
        // MARK: 关闭
        let closeBtn = UIButton(frame: CGRect.init(x: 0, y: 0, width: 50, height: 25))
        closeBtn.contentHorizontalAlignment = .left
        closeBtn.setImage(UIImage(imageName: "close_Btn", currentClass: self.classForCoder), for: .normal)
        closeBtn.addTarget(self, action: #selector(closeEvent), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: closeBtn)
    }
    
    @objc private func previewEvent() {
        print("去预览")
    }
    
    @objc private func closeEvent() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func createNavgationBar(customTitle: String?, leftItemName: String?, _ leftItemImageName: String?) {
        // MARK: 预览
        self.title = customTitle
        let leftItemBtn = UIButton(frame: CGRect.init(x: 0, y: 0, width: 50, height: 25))
        leftItemBtn.contentHorizontalAlignment = .left
        if (leftItemName != nil) {
            leftItemBtn.setTitle(leftItemName, for: .normal)
        }
        let imageName = leftItemImageName != nil ? leftItemImageName! : "left_back"
        let image = UIImage(imageName: imageName, currentClass: self.classForCoder)
        leftItemBtn.setImage(image, for: .normal)
        leftItemBtn.addTarget(self, action: #selector(leftItemEvent), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftItemBtn)
    }
    
    func createNavgationBar(customTitle: String?, leftItemName: String?, leftItemImageName: String?, rightItemName: String?, rightItemImageName: String? = "", _ addRightItemStyle: Bool = true) {
        
        self.createNavgationBar(customTitle: customTitle, leftItemName: leftItemName, leftItemImageName)
        
        let rightBtn = UIButton(frame: CGRect.init(x: 0, y: 0, width: 70, height: 25))
        
        if (rightItemImageName != nil) {
            rightBtn.setImage(UIImage(imageName: rightItemImageName!, currentClass: self.classForCoder), for: .normal)
        }
        if addRightItemStyle {
            rightBtn.layer.cornerRadius = 17
            rightBtn.backgroundColor = UIColor("#AF3F27")
        }
        
        rightBtn.setTitle(rightItemName, for: .normal)
        rightBtn.setTitleColor(.white, for: .normal)
        rightBtn.addTarget(self, action: #selector(rightItemEvent), for: .touchUpInside)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBtn)
    }
    
    @objc func rightItemEvent() {}
    
    @objc func leftItemEvent() {
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
}
