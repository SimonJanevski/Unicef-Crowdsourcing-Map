//
//  LongTextViewController.swift
//  UnicefMap
//
//  Created by Simon Janevski on 11/26/16.
//  Copyright © 2016 Simon Janevski. All rights reserved.
//

import UIKit

class LongTextViewController: UIViewController {
	
	@IBOutlet weak var textLabel: UILabel!
	var text: String!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.textLabel.text = self.text
	}
}
