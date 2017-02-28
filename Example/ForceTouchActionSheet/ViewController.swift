//
//  ViewController.swift
//  ForceTouchActionSheet
//
//  Created by ivanbruel on 02/27/2017.
//  Copyright (c) 2017 ivanbruel. All rights reserved.
//

import UIKit
import ForceTouchActionSheet

class ViewController: UIViewController {

    @IBOutlet fileprivate var buttons: [UIButton]!
    var forceTouches: [ForceTouchActionSheet] = []

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let actions = [ForceTouchAction(icon: UIImage(named: "CameraIcon")!, title: "Action 1"),
                       ForceTouchAction(icon: UIImage(named: "CameraIcon")!, title: "Action 2"),
                       ForceTouchAction(icon: UIImage(named: "CameraIcon")!, title: "Action 3")]
        forceTouches = buttons.map { button in
            ForceTouchActionSheet(view: button, actions: actions, completion: { index in
                print("clicked button \(button) \(index)")
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

