//
//  TabBarViewController.swift
//  UnicefMap
//
//  Created by Simon Janevski on 11/28/16.
//  Copyright © 2016 Simon Janevski. All rights reserved.
//

import UIKit
import Localize_Swift

class TabBarViewController: UITabBarController {
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.setViewControllersTitles()
		
		NotificationCenter.default.addObserver(self, selector: #selector(localeChanged), name: NSNotification.Name(LCLLanguageChangeNotification), object: nil)
	}
	
	func localeChanged() {
		self.setViewControllersTitles()
	}
	
	func setViewControllersTitles() {
		for (index, viewController) in (self.viewControllers?.enumerated())! {
			
			var name = ""
			switch index {
			case 0:
				name = "ScreenTitle.Map"
			case 1:
				name = "ScreenTitle.Report"
			case 2:
				name = "ScreenTitle.BarrierTypes"
			case 3:
				name = "ScreenTitle.More"
			default:
				break
			}
			
			viewController.title = name.localized()
			if let navVC = viewController as? UINavigationController {
				navVC.viewControllers[0].title = name.localized()
			}
		}
	}
}
