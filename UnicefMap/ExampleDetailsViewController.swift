//
//  ExampleDetailsViewController.swift
//  UnicefMap
//
//  Created by Simon Janevski on 10/22/16.
//  Copyright © 2016 Simon Janevski. All rights reserved.
//

import UIKit

class ExampleDetailsViewController: AbstractViewController {

	@IBOutlet weak var problemImageView: UIImageView!
	@IBOutlet weak var submitButton: UIButton!
	@IBOutlet weak var problemTitleLabel: UILabel!
	@IBOutlet weak var problemDescriptionLabel: UILabel!
	@IBOutlet weak var problemDescriptionTextView: UITextView!
	
	var problemType : ProblemType!
	
    override func viewDidLoad() {
        super.viewDidLoad()

		self.initAppearance()
		
		self.problemDescriptionLabel.isHidden = true
		
		self.problemTitleLabel.textColor = Color.blue
		self.problemDescriptionLabel.textColor = UIColor.darkText
		
		self.submitButton.addRoundedCorners(withRadius: 8)
		self.submitButton.backgroundColor = Color.blue
		self.submitButton.setTitle("BarrierTypes.Report".localized().uppercased(), for: .normal)
	}
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		self.problemDescriptionTextView.setContentOffset(.zero, animated: false)
	}
	
	func initAppearance() {
		self.problemTitleLabel.text = self.problemType.name
		self.problemImageView.image = self.problemType.image
		self.problemDescriptionLabel.text = self.problemType.longDescription
		self.problemDescriptionTextView.text = self.problemType.longDescription
	}
	
	@IBAction func didSelectSubmit(_ sender: AnyObject) {
		let navVC = self.tabBarController?.viewControllers?[1] as! UINavigationController
		navVC.popToRootViewController(animated: false)
		let reportVC = navVC.viewControllers.first as! ReportFormViewController
		reportVC.preselectedProblem = self.problemType
		self.tabBarController?.selectedIndex = 1
//		let _ = self.navigationController?.popToRootViewController(animated: false)
	}
	
	override func localeChanged() {
		self.problemType.localize()
		self.initAppearance()
		self.submitButton.setTitle("BarrierTypes.Report".localized().uppercased(), for: .normal)
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		self.problemDescriptionTextView.flashScrollIndicators()
	}
}
