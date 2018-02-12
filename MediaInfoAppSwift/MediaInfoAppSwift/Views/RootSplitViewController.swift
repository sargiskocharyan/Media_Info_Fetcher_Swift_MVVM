//
//  RootSplitViewController.swift
//  TestMediaInfoApp
//
//  Created by sargis on 2/10/18.
//  Copyright © 2018 sargis All rights reserved.
//

import UIKit

class RootSplitViewController: UISplitViewController, UISplitViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
    }
    
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        return true
        
    }
}

