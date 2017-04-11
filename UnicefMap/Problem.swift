//
//  Problem.swift
//  UnicefMap
//
//  Created by Simon Janevski on 7/20/16.
//  Copyright © 2016 Simon Janevski. All rights reserved.
//

import UIKit
import CoreLocation

class Problem: NSObject {
	
	var imageURL : String?
	var image: UIImage?
	var positiveOrNegativeProblem: String!
	var typeOfProblemID: Int!
	var typeOfProblem: ProblemType!
	var location: CLLocationCoordinate2D!
	var longDescription: String?
	var comments: [AnyObject]?
	var id : String!
	var numberOfLikes : Int! = 0
	var date : Date!

	func toDict() -> [String: AnyObject]
	{
		let formater = DateFormatter()
		formater.dateStyle = .medium
		
		let dict: [String: Any] = [
			"positiveOrNegativeProblem" : positiveOrNegativeProblem!,
			"typeOfProblemId" : typeOfProblemID!,
			"longitude" : location!.longitude,
			"lat" : location!.latitude,
			"description" : longDescription!,
			"numberOfLikes" : numberOfLikes,
			"date" : formater.string(from: self.date)
		]
		
		return dict as [String : AnyObject]
	}
	
	class func fromDict(_ dict: NSDictionary, key: String) -> Problem
	{
		let prob = Problem.init()
		
		prob.imageURL = dict["imageUrl"] as! String?
		prob.positiveOrNegativeProblem = dict["positiveOrNegativeProblem"] as! String?
		prob.typeOfProblemID = dict["typeOfProblemId"] as! Int?
		prob.typeOfProblem = ProblemType.problem(fromID: prob.typeOfProblemID)
		prob.longDescription = dict["description"] as! String?
		prob.id = key
		
		if let lat = dict["lat"] as? Double, let long = dict["longitude"] as? Double {
			prob.location = CLLocationCoordinate2D(latitude: lat, longitude:long)
		}
		
		prob.comments = dict["reports"] as? Array
		prob.numberOfLikes = dict["numberOfLikes"] as? Int
		
		if let dateString = dict["date"] as? String {
			let formater = DateFormatter()
			formater.dateStyle = .medium
			prob.date = formater.date(from: dateString)
		}

		return prob;
	}
	
	override func isEqual(_ object: Any?) -> Bool {
		if let prob = object as? Problem {
			if prob.id == self.id {
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
