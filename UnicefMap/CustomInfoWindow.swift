//
//  CustomInfoWindow.swift
//  UnicefMap
//
//  Created by Simon Janevski on 2/5/17.
//  Copyright © 2017 Simon Janevski. All rights reserved.
//

import UIKit

class CustomInfoWindow: UIView {

	@IBOutlet weak var backgroundView: UIView!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var subtitleLabel: UILabel!
	@IBOutlet weak var downArrowImageView: UIImageView!
	
	override func awakeFromNib() {
		titleLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
		titleLabel.sizeToFit()
	}
}
