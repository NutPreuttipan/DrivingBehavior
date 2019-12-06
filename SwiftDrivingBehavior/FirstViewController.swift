//
//  FirstViewController.swift
//  SwiftDrivingBehavior
//
//  Created by Preuttipan Janpen on 9/9/2562 BE.
//  Copyright © 2562 preuttipan. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    @IBOutlet weak var textFieldName: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func didTapOK(_ sender: Any) {
        
        if !textFieldName.text!.isEmpty {
            
            let mainVC = self.storyboard?.instantiateViewController(withIdentifier: "mainVC") as! ViewController
            
            UserDefaults.standard.set(textFieldName.text!, forKey: "deviceName")
            
            self.present(mainVC, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "ข้อความแจ้งเตือน", message: "กรอกชื่อด้วยจ้า", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}
