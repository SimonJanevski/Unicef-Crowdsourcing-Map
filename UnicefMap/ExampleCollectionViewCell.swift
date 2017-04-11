//
//  ExampleCollectionViewCell.swift
//  UnicefMap
//
//  Created by Simon Janevski on 10/22/16.
//  Copyright © 2016 Simon Janevski. All rights reserved.
//

import UIKit

class ExampleCollectionViewCell: UICollectionViewCell {
	@IBOutlet weak var thumbnailImageView: UIImageView!
	@IBOutlet weak var titleLabel: UILabel!
	
	override func awakeFromNib() {
		super.awakeFromNib()
		self.titleLabel.textColor = Color.blue
		self.backgroundColor = UIColor.white
	}
	
	func setTitle(_ title: String?, image: UIImage?) {
		if let title = title {
			self.titleLabel.text = title
		}
		
		if let image = image {
			self.thumbnailImageView.image = image
		}
	}
}
