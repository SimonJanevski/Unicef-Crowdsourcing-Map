//
//  SubmitReportViewController.swift
//  UnicefMap
//
//  Created by Simon Janevski on 11/7/16.
//  Copyright © 2016 Simon Janevski. All rights reserved.
//

import UIKit
import PKHUD

protocol SubmitReportViewControllerDelegate: class {
	func succefullyReported()
}

class SubmitReportViewController: AbstractViewController {

	@IBOutlet weak var submitButton: UIButton!
	@IBOutlet weak var problemDescription: UITextView!
	@IBOutlet weak var titleLabel: UILabel!
	
	weak var delegate : SubmitReportViewControllerDelegate?
	
	var problemID : String!
	
	override func viewDidLoad() {
        super.viewDidLoad()

       self.submitButton.addRoundedCorners(withRadius: 8)
		self.submitButton.backgroundColor = Color.blue
		
		self.problemDescription.addRoundedCorners(withRadius: 8)
		self.problemDescription.backgroundColor = Color.gray
		
		self.titleLabel.textColor = Color.blue
		
		self.titleLabel.text = "ReportForm.WrongProblem".localized()
		self.submitButton.setTitle("ReportForm.ReportFalseProblem".localized().uppercased(), for: .normal)
		self.title = "ReportForm.ReportFalseProblem".localized().capitalized
	}

	@IBAction func didPressSubmitButton(_ sender: Any) {
		
		if problemDescription.text.isEmpty {
			HUD.flash(.labeledError(title: nil, subtitle: "ReportForm.EnterSomeText".localized()), delay: 1.3)
			return
		}
		
		DataSource.submitReportForProblemID(problemID, report: self.problemDescription.text)
		self.delegate?.succefullyReported()
		
		HUD.flash(.labeledSuccess(title: nil, subtitle: "ReportForm.ReportFalseProblem.Success".localized()), delay: 1) { (complete) in
			let _ = self.navigationController?.popViewController(animated: true)
		}
	}
	
	override func localeChanged() {
		self.submitButton.setTitle("ReportForm.ReportFalseProblem".localized().uppercased(), for: .normal)
		self.titleLabel.text = "ReportForm.WrongProblem".localized()
	}
}
