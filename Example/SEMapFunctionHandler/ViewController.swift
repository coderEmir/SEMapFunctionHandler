//
//  ViewController.swift
//  SEMapFunctionHandler
//
//  Created by seeEmil on 01/12/2021.
//  Copyright (c) 2021 seeEmil. All rights reserved.
//

import UIKit
import SEMapFunctionHandler
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let button = UIButton.init(type: .contactAdd)
        button.frame = CGRect.init(x: 200, y: 200, width: 100, height: 100)
        button.addTarget(self, action: #selector(showView), for: .touchUpInside)
        view.addSubview(button)
    }

    @objc func showView () {
        // your own apiKey
        SEMapFunctionHandlerAPI.presentMapController(fromController: self, apiKey:"") { (image, locationName) in
            
        }
    }

}

