//
//  ProblemType.swift
//  UnicefMap
//
//  Created by Simon Janevski on 11/24/16.
//  Copyright © 2016 Simon Janevski. All rights reserved.
//

import UIKit

class ProblemType: NSObject {
	
	var name : String!
	let image : UIImage!
	var longDescription : String!
	let id : Int!
	
	init(name: String!, image: UIImage!, longDescription: String!, id : Int!) {
		self.name = name
		self.image = image
		self.longDescription = longDescription
		self.id = id
	}
	
	class func problem(fromID: Int!) -> ProblemType {
		let names = ProblemsDataSource.getProblemsNames()
		let name = names[fromID]
		
		return ProblemType(name: "\(name)Name".localized(), image: UIImage(named: name), longDescription: "\(name)Description".localized(), id: fromID)
	}
	
	func localize() {
		let names = ProblemsDataSource.getProblemsNames()
		let name = names[self.id]
		
		self.name = "\(name)Name".localized()
		self.longDescription = "\(name)Description".localized()
	}
	
	func markerImage(postiveOrNegative: String) -> UIImage {
		let names = ProblemsDataSource.getProblemsNames()
		var name = names[self.id]
		name.append("Marker")
		if postiveOrNegative == "negative" {
			name.append("Negative")
		}
		return UIImage(named: name)!
	}
	
	func iconImage(postiveOrNegative: String) -> UIImage {
		let names = ProblemsDataSource.getProblemsNames()
		var name = names[self.id]
		name.append("Icon")
		if postiveOrNegative == "negative" {
			name.append("Negative")
		}
		return UIImage(named: name)!
	}
}
