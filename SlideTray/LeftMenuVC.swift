//
//  LeftMenuVC.swift
//  SlideTray
//
//  Created by Faizan Naseem on 16/10/2018.
//  Copyright © 2018 Faizan Naseem. All rights reserved.
//

import UIKit

class LeftMenuVC: UIViewController {
    
    var delegate: SideMenuDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    @IBAction func settingsTapped(_ sender: Any) {
        delegate?.animateLeftPanel(shouldExpanded: false)
        delegate?.toggleOtherScreen()
    }
    
}
