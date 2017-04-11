//
//  SplashViewController.swift
//  UnicefMap
//
//  Created by Simon Janevski on 11/24/16.
//  Copyright © 2016 Simon Janevski. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController {
	@IBOutlet weak var spinnerPlaceholder: FPActivityLoader!
	
	override func viewDidLoad() {
        super.viewDidLoad()
		self.spinnerPlaceholder.strokeColor = Color.blue
	}
}
