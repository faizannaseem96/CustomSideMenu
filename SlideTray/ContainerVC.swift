//
//  ContainerVC.swift
//  SlideTray
//
//  Created by Faizan Naseem on 16/10/2018.
//  Copyright © 2018 Faizan Naseem. All rights reserved.
//

import UIKit
import QuartzCore

enum SlideOutState {
    case collasped
    case expanded
}

enum ShowWhichVC {
    case homeVC
    case settingsVC
}

protocol SideMenuDelegate {
    func toggleLeftPanel()
    func addLeftPanelVC()
    func animateLeftPanel(shouldExpanded: Bool)
    func toggleOtherScreen()
}

var showVC : ShowWhichVC = .homeVC

class ContainerVC: UIViewController {

    var homeVC: HomeVC!
    var settingsVC: SettingsVC!
    
    var leftVC: LeftMenuVC!
    var currentState: SlideOutState = .collasped {
        didSet {
            let shouldShowShadow = currentState != .collasped
            showShadow(status: shouldShowShadow)
        }
    }
    var centerController : UIViewController!
    var centerPanelExpanedOffset : CGFloat = 160
    var tap = UITapGestureRecognizer()
    var presentedController : UIViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initCenter(screen: showVC)
    }
    
    func initCenter(screen: ShowWhichVC) {
        var presentingController : UIViewController
        showVC = screen
        
        if homeVC == nil {
            homeVC = UIStoryboard.HomeVC()
            homeVC.delegate = self
        }
        presentingController = homeVC
        
        if let con = centerController {
            con.view.removeFromSuperview()
            con.removeFromParentViewController()
        }
        centerController = presentingController
        view.addSubview(centerController.view)
        addChildViewController(centerController)
        centerController.didMove(toParentViewController: self)
    }

}

extension ContainerVC : SideMenuDelegate {
    
    func toggleLeftPanel() {
        let notAlreadyExpanded = currentState != .expanded
        if notAlreadyExpanded {
            addLeftPanelVC()
        }
        animateLeftPanel(shouldExpanded: notAlreadyExpanded)
    }
    
    func addLeftPanelVC() {
        if leftVC == nil {
            leftVC = UIStoryboard.leftViewController()
            leftVC.delegate = self
            addChildPanelViewController(leftVC)
        }
    }
    
    @objc func animateLeftPanel(shouldExpanded: Bool) {
        if shouldExpanded {
            currentState  = .expanded
            showWhiteCoverView()
            animateCenterPanelXPosition(targetPosition: centerController.view.frame.width - centerPanelExpanedOffset) { (finished) in }
        } else {
            hideWhiteCoverView()
            animateCenterPanelXPosition(targetPosition: 0) { (finished) in
                self.currentState = .collasped
                self.removeChildPanelViewController(self.leftVC)
                self.leftVC = nil
            }
        }
    }
    
    func toggleOtherScreen() {
        if let con = centerController {
            con.view.removeFromSuperview()
            con.removeFromParentViewController()
        }
        centerController = UIStoryboard.SettingsVC()
        view.addSubview(centerController.view)
        addChildViewController(centerController)
        centerController.didMove(toParentViewController: self)
    }
    
    
    func addChildPanelViewController(_ controller: LeftMenuVC) {
        view.insertSubview(controller.view, at: 0)
        addChildViewController(controller)
        controller.didMove(toParentViewController: self)
    }
    
    func removeChildPanelViewController(_ controller: LeftMenuVC) {
        controller.view.removeFromSuperview()
        controller.removeFromParentViewController()
    }
    
    func showWhiteCoverView() {
        let whiteCoverView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        whiteCoverView.alpha = 0.0
        whiteCoverView.backgroundColor = UIColor.white
        whiteCoverView.tag = 25
        self.centerController.view.addSubview(whiteCoverView)
        
        UIView.animate(withDuration: 0.2) {
            whiteCoverView.alpha = 0.75
        }
        
        tap = UITapGestureRecognizer(target: self, action: #selector(animateLeftPanel(shouldExpanded:)))
        tap.numberOfTapsRequired = 1
        self.centerController.view.addGestureRecognizer(tap)
    }
    
    func hideWhiteCoverView() {
        centerController.view.removeGestureRecognizer(tap)
        for subview in self.centerController.view.subviews {
            if subview.tag == 25 {
                UIView.animate(withDuration: 0.2, animations: {
                    subview.alpha = 0.0
                }) { (finished) in
                    if finished {
                        subview.removeFromSuperview()
                    }
                }
            }
        }
    }
    
    func showShadow(status: Bool) {
        if status {
            centerController.view.layer.shadowOpacity = 0.6
        } else {
            centerController.view.layer.shadowOpacity = 0.0
        }
    }
    
    func animateCenterPanelXPosition(targetPosition: CGFloat, completion: @escaping ((Bool) -> Void)) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.centerController.view.frame.origin.x = targetPosition
        }, completion: completion)
    }
}

extension UIStoryboard {
    
    class func mainStoryboard() -> UIStoryboard {
        return UIStoryboard(name: "Main", bundle: Bundle.main)
    }
    
    class func leftViewController () -> LeftMenuVC? {
        return mainStoryboard().instantiateViewController(withIdentifier: "LeftMenuVC") as? LeftMenuVC
    }
    
    class func HomeVC() -> HomeVC? {
        return mainStoryboard().instantiateViewController(withIdentifier: "HomeVC") as? HomeVC
    }
    
    class func SettingsVC() -> SettingsVC? {
        return mainStoryboard().instantiateViewController(withIdentifier: "SettingsVC") as? SettingsVC
    }
}
