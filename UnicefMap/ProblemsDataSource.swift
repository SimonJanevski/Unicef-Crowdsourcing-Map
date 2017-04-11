//
//  ProblemsDataSource.swift
//  UnicefMap
//
//  Created by Simon Janevski on 11/27/16.
//  Copyright © 2016 Simon Janevski. All rights reserved.
//

import UIKit

class ProblemsDataSource: NSObject {

	class func getBarrierTypes() -> [ProblemType] {
		var resultArray = [ProblemType]()
		let names = ProblemsDataSource.getProblemsNames()
		
		for (index, name) in names.enumerated() {
			resultArray.append(ProblemType(name: "\(name)Name".localized(), image: UIImage(named: name), longDescription: "\(name)Description".localized(), id: index))
		}
		
		return resultArray
	}
	
	class func getProblemsNames() -> [String] {
		
		return ["accessOutside", "accessInside", "publicTransport", "crosswalk", "crosswalk2", "publicToalets", "parking", "hearing", "playground", "equalTreatmant"]
	}
	
	class func setProblemAsLiked(forProblem: Problem) {
		ProblemsDataSource.saveItem(forID: forProblem.id, key: "liked")
	}
	
	class func setProblemAsReported(forProblem: Problem) {
		ProblemsDataSource.saveItem(forID: forProblem.id, key: "reported")
	}
	
	class func isProblemLiked(forProblem: Problem) -> Bool{
		return ProblemsDataSource.isItemSaved(forID: forProblem.id, key: "liked")
	}
	
	class func isProblemReported(forProblem: Problem)  -> Bool {
		return ProblemsDataSource.isItemSaved(forID: forProblem.id, key: "reported")
	}
	
	private class func saveItem(forID id: String, key: String) {
		let userDefaults = UserDefaults.standard
		if let list = userDefaults.array(forKey: key) {
			var newList = list
			newList.append(id)
			userDefaults.set(newList, forKey: key)
		}
			
		else {
			userDefaults.set([id], forKey: key)
		}
	}
	
	private class func isItemSaved(forID id: String, key: String) -> Bool {
		let userDefaults = UserDefaults.standard
		if let list = userDefaults.array(forKey: key) as? [String] {
			if list.contains(id) {
				return true
			}
				
			else {
				return false
			}
		}
			
		else {
			return false
		}
	}
}
