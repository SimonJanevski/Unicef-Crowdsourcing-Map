//
//  TutorialViewController.swift
//  UnicefMap
//
//  Created by Simon Janevski on 11/24/16.
//  Copyright © 2016 Simon Janevski. All rights reserved.
//

import UIKit

protocol TutorialViewControllerDelegate : class{
	func didSwipeToIndex(_ index: Int)
}

class TutorialViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
	
	var orderedViewControllers = [UIViewController]()
	weak var pageControllDelegate : TutorialViewControllerDelegate?
	var currentlySelectedIndex : Int = 0
	var timer : Timer!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let firstVC = UIStoryboard(name: "Tutorial", bundle: nil).instantiateViewController(withIdentifier: "first")
		let secondVC = UIStoryboard(name: "Tutorial", bundle: nil).instantiateViewController(withIdentifier: "second")
		let thirdVC = UIStoryboard(name: "Tutorial", bundle: nil).instantiateViewController(withIdentifier: "third")
		
		self.orderedViewControllers.append(firstVC)
		self.orderedViewControllers.append(secondVC)
		self.orderedViewControllers.append(thirdVC)
		
		self.dataSource = self
		self.delegate = self
		self.setViewControllers([self.orderedViewControllers[0]], direction: .forward, animated: true, completion: nil)
		
		self.timer = Timer.scheduledTimer(timeInterval: 4, target: self, selector: #selector(scrollToNextPage), userInfo: nil, repeats: true)
	}
	
	func scrollToNextPage() {
		var nextIndex = self.currentlySelectedIndex + 1
		if nextIndex > 2 { nextIndex = 0 }
		self.setViewControllers([self.orderedViewControllers[nextIndex]], direction: .forward, animated: true, completion: nil)
		self.pageControllDelegate?.didSwipeToIndex(nextIndex)
		self.currentlySelectedIndex = nextIndex
	}
	
	func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
		if let firstViewController = viewControllers?.first,
			let index = orderedViewControllers.index(of: firstViewController) {
			self.pageControllDelegate?.didSwipeToIndex(index)
			self.currentlySelectedIndex = index
			self.timer.invalidate()
			self.timer = Timer.scheduledTimer(timeInterval: 4, target: self, selector: #selector(scrollToNextPage), userInfo: nil, repeats: true)
		}
	}
	
	func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
		guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
			return nil
		}
		
		let nextIndex = viewControllerIndex + 1
		let orderedViewControllersCount = orderedViewControllers.count
		
		guard orderedViewControllersCount != nextIndex else {
			return orderedViewControllers.first
		}
		
		guard orderedViewControllersCount > nextIndex else {
			return nil
		}
		
		return orderedViewControllers[nextIndex]
	}
	
	func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
		guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
			return nil
		}
		
		let previousIndex = viewControllerIndex - 1
		
		guard previousIndex >= 0 else {
			return orderedViewControllers.last
		}
		
		guard orderedViewControllers.count > previousIndex else {
			return nil
		}
		
		return orderedViewControllers[previousIndex]
	}
}
