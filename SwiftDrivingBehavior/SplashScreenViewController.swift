//
//  SplashScreenViewController.swift
//  SwiftDrivingBehavior
//
//  Created by Preuttipan Janpen on 9/9/2562 BE.
//  Copyright © 2562 preuttipan. All rights reserved.
//

import UIKit

class SplashScreenViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UserDefaults.standard.value(forKey: "deviceName") == nil {
            let firstVC = self.storyboard!.instantiateViewController(withIdentifier: "firstVC") as! FirstViewController
            self.navigationController?.pushViewController(firstVC, animated: true)
        } else {
            let mainVC = self.storyboard!.instantiateViewController(withIdentifier: "mainVC") as! ViewController
           self.navigationController?.pushViewController(mainVC, animated: true)
        }
    }
}
