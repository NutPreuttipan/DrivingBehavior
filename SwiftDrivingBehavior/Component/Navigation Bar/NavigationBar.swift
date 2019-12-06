//
//  NavigationBar.swift
//  SwiftDrivingBehavior
//
//  Created by Preuttipan Janpen on 19/8/2562 BE.
//  Copyright © 2562 preuttipan. All rights reserved.
//

import UIKit

class NavigationBar: UIView {
    
    @IBOutlet weak var labelHeader: UILabel!
    @IBOutlet weak var buttonLeft: UIButton!
    @IBOutlet weak var buttonRight: UIButton!
    @IBOutlet weak var viewBG: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialView()
    }
    
    private func initialView() {
        Bundle.main.loadNibNamed("NavigationBar", owner: self, options: nil)
        addSubview(viewBG)
        viewBG.backgroundColor = UIColor.brown
        viewBG.frame = self.bounds
        viewBG.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    var title:String {
        get { return labelHeader.text ?? "" }
        set { labelHeader.text = newValue }
    }
    
    var leftButtonTitle:String {
        get { return buttonLeft.title(for: .normal) ?? "" }
        set { buttonLeft.setTitle(" " + newValue, for: .normal) }
    }
    
    var leftButtonImage:UIImage {
        get { return buttonLeft.image(for: .normal)! }
        set { buttonLeft.setImage(newValue, for: .normal) }
    }
    
    var rightButtonTitle:String {
        get { return buttonRight.title(for: .normal) ?? "" }
        set { buttonRight.setTitle(newValue, for: .normal) }
    }
}
