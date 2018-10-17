//
//  SettingsVC.swift
//  SlideTray
//
//  Created by Faizan Naseem on 16/10/2018.
//  Copyright © 2018 Faizan Naseem. All rights reserved.
//

import UIKit

class SettingsVC: UIViewController {
    
    var delegate: SideMenuDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func menuTapped(_ sender : Any) {
        delegate?.toggleLeftPanel()
    }

}
