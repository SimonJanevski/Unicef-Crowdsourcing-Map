//
//  AbstractViewController.swift
//  UnicefMap
//
//  Created by Simon Janevski on 11/28/16.
//  Copyright © 2016 Simon Janevski. All rights reserved.
//

import UIKit
import Localize_Swift

class AbstractViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
		NotificationCenter.default.addObserver(self, selector: #selector(localeChanged), name: NSNotification.Name(LCLLanguageChangeNotification), object: nil)
	}
	
	func localeChanged() { }
}
