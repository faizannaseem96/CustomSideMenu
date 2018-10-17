//
//  ViewController.swift
//  SlideTray
//
//  Created by Faizan Naseem on 16/10/2018.
//  Copyright © 2018 Faizan Naseem. All rights reserved.
//

import UIKit

class HomeVC: UIViewController {
    
    var delegate: SideMenuDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func menuTapped(_ sender : Any) {
        delegate?.toggleLeftPanel()
        //NotificationCenter.default.post(name: NSNotification.Name("ToggleSideMenu"), object: nil)
    }
    


}

