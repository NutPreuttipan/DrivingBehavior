//
//  FirebaseDBReaderViewController.swift
//  SwiftDrivingBehavior
//
//  Created by Preuttipan Janpen on 30/10/2562 BE.
//  Copyright © 2562 preuttipan. All rights reserved.
//

import UIKit

import Firebase
import FirebaseDatabase

class FirebaseDBReaderViewController: UIViewController {

    @IBOutlet weak var textFieldInput: UITextField!
    @IBOutlet weak var labelOutput: UILabel!
    
    //MARK: Firebase Database
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference().child("Nut")

        readFromFirebaseDB()
    }
    
    @IBAction func didTapButton(_ sender: Any) {
        writeToFirebaseDB(input: textFieldInput.text!)
    }
}

extension FirebaseDBReaderViewController {
    
    func writeToFirebaseDB(input:String) {
        let key = ref.childByAutoId().key!
        
        let rawData:[String:Any] = [
            "id": key,
            "source": input
        ]
        
        ref.child(key).setValue(rawData)
    }
    
    func readFromFirebaseDB() {
        ref.queryLimited(toLast: 1).observe(.childAdded) { (response) in
            if let value = response.value as? NSDictionary {
                let id = value["id"] as? String ?? ""
                let source = value["source"] as? String ?? ""
                
                self.labelOutput.text = source
                print("ID: \(id)\nSource: \(source)")
            }
        }
    }
}
