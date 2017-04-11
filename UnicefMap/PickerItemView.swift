//
//  PickerItemView.swift
//  UnicefMap
//
//  Created by Simon Janevski on 10/23/16.
//  Copyright © 2016 Simon Janevski. All rights reserved.
//

import UIKit

class PickerItemView: UIView {
	
	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var titleLabel: UILabel!
	
	override func awakeFromNib() {
		super.awakeFromNib()
	
		self.titleLabel.textColor = Color.blue
	}

	class func instanceFromNib() -> PickerItemView {
		return UINib(nibName: "PickerItemView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! PickerItemView
	}
}
