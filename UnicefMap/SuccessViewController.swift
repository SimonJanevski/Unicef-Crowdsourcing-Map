//
//  SuccessViewController.swift
//  UnicefMap
//
//  Created by Simon Janevski on 11/8/16.
//  Copyright © 2016 Simon Janevski. All rights reserved.
//

import UIKit

class SuccessViewController: AbstractViewController {

	@IBOutlet weak var submitButton: UIButton!
	@IBOutlet weak var successTextLabel: UILabel!
	
	@IBOutlet weak var noInternetView: UIView!
	@IBOutlet weak var noInternetInfoView: UIView!
	@IBOutlet weak var noInternetTitleLabel: UILabel!
	@IBOutlet weak var noInternetSubtitleLabel: UILabel!
	@IBOutlet weak var goToSettingsInternetButton: UIButton!
	
	var key: String!
	
    override func viewDidLoad() {
        super.viewDidLoad()

		self.submitButton.addRoundedCorners(withRadius: 8)
		self.submitButton.backgroundColor = Color.blue
		
		self.submitButton.setTitle("ReportForm.Success.Report".localized().uppercased(), for: .normal)
		self.successTextLabel.text = "ReportForm.Success.Text".localized()
		
		self.noInternetTitleLabel.text = "ReportForm.InternetDisabled".localized()
		self.noInternetSubtitleLabel.text = "ReportForm.InternetDisabledDescription".localized()
		self.goToSettingsInternetButton.setTitle("ReportForm.OK".localized(), for: .normal)

		self.noInternetInfoView.addRoundedCorners(withRadius: 15)
		
		if DataSource.connectedToNetwork() == false {
			
			self.noInternetView.alpha = 0
			self.noInternetView.isHidden = false
	
			UIView.animate(withDuration: 0.3, animations: {
				self.noInternetView.alpha = 1
			}) { (finished) in
				self.noInternetView.isHidden = false
			}
		}
	}
	
	@IBAction func didPressSubmitButton(_ sender: Any) {
		let navVC = self.tabBarController?.viewControllers?[0] as! UINavigationController
		navVC.popToRootViewController(animated: false)
		let mapVC = navVC.viewControllers.first as! MapViewController
		mapVC.lastCreatedMarker = self.key
		self.tabBarController?.selectedIndex = 0
		let _ = self.navigationController?.popToRootViewController(animated: false)
	}
	
	override func localeChanged() {
		self.submitButton.setTitle("ReportForm.Success.Report".localized().uppercased(), for: .normal)
		self.successTextLabel.text = "ReportForm.Success.Text".localized()
		
		self.noInternetTitleLabel.text = "ReportForm.InternetDisabled".localized()
		self.noInternetSubtitleLabel.text = "ReportForm.InternetDisabledDescription".localized()
		self.goToSettingsInternetButton.setTitle("ReportForm.OK".localized(), for: .normal)
	}

	@IBAction func didPressGoToSettingsButton(_ sender: Any) {
		UIView.animate(withDuration: 0.3, animations: {
			self.noInternetView.alpha = 0
		}) { (finished) in
			self.noInternetView.isHidden = true
		}
	}
}
