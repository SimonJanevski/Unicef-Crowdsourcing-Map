//
//  DataSource.swift
//  UnicefMap
//
//  Created by Simon Janevski on 7/25/16.
//  Copyright © 2016 Simon Janevski. All rights reserved.
//

import UIKit
import Firebase
import SystemConfiguration

class DataSource: NSObject {
	
	static let ref = FIRDatabase.database().reference().child("problems")
	static let storage = FIRStorage.storage().reference().child("images")

	class func saveProblem(_ problem:Problem, success: @escaping (Bool, String) -> (), failure: @escaping (Error) -> ()) {
		
		
		let metaData = FIRStorageMetadata()
		metaData.contentType = "image/png"
		
		let key = self.ref.childByAutoId().key
		if (DataSource.connectedToNetwork()) {
		
			self.ref.child(key).setValue(problem.toDict()) {(error, ref) -> Void in
				
				if let image = problem.image {
		
					let uploadTask = self.storage.child(key).put(UIImagePNGRepresentation(image)!, metadata: metaData)
					
					uploadTask.observe(.progress) { snapshot in
						// A progress event occurred
					}
					
					uploadTask.observe(.success) { snapshot in
						self.storage.child(key).downloadURL(completion: { (url, error) in
							self.ref.child(key).updateChildValues(["imageUrl": "\(url!)"])
						})
						
						success(true, key)
					}
					
					uploadTask.observe(.failure) { snapshot in
						self.ref.child(key).removeValue()
						guard let storageError = snapshot.error else { return }
						failure(storageError)
					}
					
				}
					
				else {
					success(true, key)
				}
				
			}
		}
			
		else { // no internet
			self.ref.child(key).setValue(problem.toDict())
			if let image = problem.image {
				DataSource.saveImageDocumentDirectory(image: image, key: key)
			}
			success(true, key)
		}
	}

	class func setNumberOfLikesForProblemID(_ id: String, numberOfLikes: Int!) {
		DataSource.updateProblem(id, value: ["numberOfLikes" : numberOfLikes])
	}
	
	class func submitReportForProblemID(_ id: String, report: String!) {
		self.ref.child(id).child("reports").childByAutoId().setValue(["report" : report])
	}
	
	class func updateProblem(_ id: String, value: [String : Any]) {
		self.ref.child(id).updateChildValues(value)
	}
	
	class func removeProblem(_ problem:Problem) {
//		self.ref.child(problem.id).removeValue()
	}
	
	class func getAllProblemsOnce(success: @escaping ([Problem]) -> ()) {
		var resultArray = [Problem]()
		
		ref.observeSingleEvent(of: .value, with: {(snapshot) -> Void in
			resultArray.removeAll()
			
			for rest in snapshot.children.allObjects as! [FIRDataSnapshot] {
				let dict = rest.value as! NSDictionary
				resultArray.append(Problem.fromDict(dict, key: rest.key))
			}
			
			success(resultArray)
		})
	}
	
	class func getAllProblems(success: @escaping ([Problem]) -> ()) {
		var resultArray = [Problem]()
		
		ref.observe(.value, with: {(snapshot) -> Void in
		resultArray.removeAll()
			for rest in snapshot.children.allObjects as! [FIRDataSnapshot] {
				let dict = rest.value as! NSDictionary
				resultArray.append(Problem.fromDict(dict, key: rest.key))
			}
			
			success(resultArray)
		})
	}
	
	class func imagesToUpload(dict: [String : URL]) {
		for item in dict {
			let uploadTask = self.storage.child(item.key).putFile(item.value)
			uploadTask.observe(.success) { snapshot in
				self.storage.child(item.key).downloadURL(completion: { (url, error) in
					self.ref.child(item.key).updateChildValues(["imageUrl": "\(url!)"])
					DataSource.deleteFileFromDocumentsDirectory(fileLocation: item.value)
				})
			}
		}
	}
	
	class func saveImageDocumentDirectory(image: UIImage, key: String) {
		let fileManager = FileManager.default
		let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("\(key).png")
		print(paths)
		let imageData = UIImagePNGRepresentation(image)
		fileManager.createFile(atPath: paths as String, contents: imageData, attributes: nil)
	}
	
	class func deleteFileFromDocumentsDirectory(fileLocation: URL!) {
		let fileManager = FileManager.default
		do {
			try fileManager.removeItem(at: fileLocation)
		}
		
		catch let error as NSError {
			print(error.localizedDescription)
		}
	}
	
	class func getAllImagesToUpload() -> [String : URL]? {
		let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
		var resultDict = [String : URL]()
		do {
			let directoryContents = try FileManager.default.contentsOfDirectory(at: documentsUrl, includingPropertiesForKeys: nil, options: [])
			
			let files = directoryContents.filter{ $0.pathExtension == "png" }
			let names = files.map{ $0.deletingPathExtension().lastPathComponent }
			
			for (index, name) in names.enumerated() {
				resultDict[name] = files[index]
			}
			
			if resultDict.count == 0 { return nil }
			
			return resultDict
			
		} catch let error as NSError {
			print(error.localizedDescription)
			
			return nil
		}
	}
		
	class func connectedToNetwork() -> Bool {
		
		var zeroAddress = sockaddr_in()
		zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
		zeroAddress.sin_family = sa_family_t(AF_INET)
		
		guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
			$0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
				SCNetworkReachabilityCreateWithAddress(nil, $0)
			}
		}) else {
			return false
		}
		
		var flags: SCNetworkReachabilityFlags = []
		if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
			return false
		}
		
		let isReachable = flags.contains(.reachable)
		let needsConnection = flags.contains(.connectionRequired)
		
		return (isReachable && !needsConnection)
	}
}
