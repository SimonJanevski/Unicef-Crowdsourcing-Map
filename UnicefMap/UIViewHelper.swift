//
//  UIViewHelper.swift
//  UnicefMap
//
//  Created by Simon Janevski on 10/23/16.
//  Copyright © 2016 Simon Janevski. All rights reserved.
//

import UIKit

extension UIView {
	
	func addRoundedCorners(withRadius: Float) {
		self.layer.cornerRadius = CGFloat(withRadius)
		self.clipsToBounds = true
	}
	
	func addBorderWithWidth(_ width: CGFloat, color: UIColor) {
		self.layer.borderWidth = width
		self.layer.borderColor = color.cgColor
	}
	
	func addBlueRoundedCornerBorder() {
		self.addRoundedCorners(withRadius: 8)
		self.addBorderWithWidth(1, color: Color.blue)
	}
}

struct Color {
	static let blue = UIColor(red: 76.0 / 255.0, green: 144.0 / 255.0, blue: 201.0 / 255.0, alpha: 1.0)
	static let gray = UIColor(red: 230.0 / 255.0, green: 230.0 / 255.0, blue: 230.0 / 255.0, alpha: 1.0)
	static let green = UIColor(red: 140.0 / 255.0, green: 190.0 / 255.0, blue: 78.0 / 255.0, alpha: 1.0)
	static let red = UIColor(red: 232.0 / 255.0, green: 33.0 / 255.0, blue: 45.0 / 255.0, alpha: 1.0)
	static let lightGray = UIColor(red: 241.0 / 255.0, green: 241.0 / 255.0, blue: 241.0 / 255.0, alpha: 1.0)
}

extension UIImage {
	func resizeWith(percentage: CGFloat) -> UIImage? {
		let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: size.width * percentage, height: size.height * percentage)))
		imageView.contentMode = .scaleAspectFit
		imageView.image = self
		UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
		guard let context = UIGraphicsGetCurrentContext() else { return nil }
		imageView.layer.render(in: context)
		guard let result = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
		UIGraphicsEndImageContext()
		return result
	}
}
