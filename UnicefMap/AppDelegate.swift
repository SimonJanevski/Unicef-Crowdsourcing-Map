//
//  AppDelegate.swift
//  UnicefMap
//
//  Created by Simon Janevski on 7/20/16.
//  Copyright © 2016 Simon Janevski. All rights reserved.
//

import UIKit
import Firebase
import GoogleMaps
import Localize_Swift
import IQKeyboardManagerSwift
import ReachabilitySwift
import Localize_Swift


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {

	var window: UIWindow?
	var items = [Problem]()
	let manager = CLLocationManager()
	let reachability = Reachability()!

	 func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool  {
		
		Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(self.finishedLoadingItems), userInfo: nil, repeats: false)
		
		IQKeyboardManager.sharedManager().enable = true
		
		FIRApp.configure()
		FIRDatabase.database().persistenceEnabled = true
		
		UITabBar.appearance().backgroundColor = UIColor.white
		UITabBar.appearance().tintColor = Color.blue
		UISwitch.appearance().tintColor = Color.blue
		UINavigationBar.appearance().tintColor = Color.blue
		
		
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		let controller = storyboard.instantiateViewController(withIdentifier: "SplashViewController")

		self.window?.rootViewController = controller
		
		manager.delegate = self
		if CLLocationManager.authorizationStatus() == .notDetermined {
			manager.requestWhenInUseAuthorization()
		}
		
		DataSource.getAllProblemsOnce { (items) in
			self.items = items
		}
		
		do {
			try reachability.startNotifier()
		} catch {
			print("Unable to start notifier")
		}
		
		reachability.whenReachable = { reachability in
			if let imagesDict = DataSource.getAllImagesToUpload() {
				DataSource.imagesToUpload(dict: imagesDict)
			}
		}
		
		return true
	}

	func finishedLoadingItems() {
		if self.isFirstRun() {
			Localize.setCurrentLanguage("mk")
			let storyboard = UIStoryboard(name: "Tutorial", bundle: nil)
			let controller = storyboard.instantiateViewController(withIdentifier: "TutorialViewController")
			self.window?.rootViewController = controller
		}
			
		else {
			self.showTabBar()
		}
	}
	
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		
	}
	
	func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
		if status == .authorizedAlways || status == .authorizedWhenInUse {
			manager.requestLocation()
		}
	}
	
	func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
		print("Failed to find user's location: \(error.localizedDescription)")
	}
	
	func showTabBar() {
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		let tabbar = storyboard.instantiateInitialViewController() as! UITabBarController
		let mapNavVC = tabbar.viewControllers?[0] as! UINavigationController
		let mapVC = mapNavVC.viewControllers[0] as! MapViewController
		mapVC.items = self.items
		self.window?.rootViewController = tabbar
	}
	
	func isFirstRun() -> Bool {

		let userDefaults = UserDefaults.standard
		if userDefaults.bool(forKey: "firstRun") == false {
			userDefaults.set(true, forKey: "firstRun")
			return true
		}
		return false // CHANGE THIS TO FALSE IN PRODUCTION
	}
	
	func applicationDidBecomeActive(_ application: UIApplication) {
		
	}
}
