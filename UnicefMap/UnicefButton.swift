//
//  UnicefButton.swift
//  UnicefMap
//
//  Created by Simon Janevski on 11/19/16.
//  Copyright © 2016 Simon Janevski. All rights reserved.
//

import UIKit

class UnicefButton: UIButton {
	
	override func awakeFromNib() {
		super.awakeFromNib()
		
		self.titleLabel?.numberOfLines = 1;
		self.titleLabel?.adjustsFontSizeToFitWidth = true;
		self.titleLabel?.lineBreakMode = .byClipping
		self.titleLabel?.minimumScaleFactor = 0.5
	}
	
	override var isEnabled: Bool {
		didSet {
			self.backgroundColor = self.backgroundColor?.withAlphaComponent(isEnabled ? 1 : 0.5)
		}
	}
}
