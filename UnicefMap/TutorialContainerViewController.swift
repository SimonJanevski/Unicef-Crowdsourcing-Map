//
//  TutorialContainerViewController.swift
//  UnicefMap
//
//  Created by Simon Janevski on 11/24/16.
//  Copyright © 2016 Simon Janevski. All rights reserved.
//

import UIKit

class TutorialContainerViewController: UIViewController, TutorialViewControllerDelegate {

	@IBOutlet weak var pageControl: UIPageControl!
	@IBOutlet weak var startButton: UIButton!
	@IBOutlet weak var containerView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
		
		self.startButton.addRoundedCorners(withRadius: 8)
		self.startButton.backgroundColor = Color.blue

		self.pageControl.currentPageIndicatorTintColor = Color.blue
		self.pageControl.pageIndicatorTintColor = UIColor.white
	}
	
	@IBAction func didPressStartButton(_ sender: Any) {
		let appDelegate = UIApplication.shared.delegate as! AppDelegate
		appDelegate.showTabBar()
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if let tutorialPageViewController = segue.destination as? TutorialViewController {
			tutorialPageViewController.pageControllDelegate = self
		}
	}
	
	func didSwipeToIndex(_ index: Int) {
		pageControl.currentPage = index
	}
}
