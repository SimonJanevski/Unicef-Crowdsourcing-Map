//
//  ProblemDetailsViewController.swift
//  UnicefMap
//
//  Created by Simon Janevski on 11/2/16.
//  Copyright © 2016 Simon Janevski. All rights reserved.
//

import UIKit
import FontAwesome_swift
import SDWebImage

class ProblemDetailsViewController: AbstractViewController, SubmitReportViewControllerDelegate {

	@IBOutlet weak var iAgreeButton: UnicefButton!
	var problem : Problem!
	
	@IBOutlet weak var typeOfProblemView: UIView!
	@IBOutlet weak var descriptionLabel: UILabel!
	@IBOutlet weak var reportButton: UnicefButton!
	@IBOutlet weak var typeOfProblemLabel: UILabel!
	@IBOutlet weak var typeOfProblemDescriptionLabel: UILabel!
	@IBOutlet weak var problemTypeImageContainerView: UIView!
	@IBOutlet weak var problemTypeImageView: UIImageView!
	@IBOutlet weak var problemImageView: UIImageView!
	@IBOutlet weak var noImageLabel: UILabel!
	
	@IBOutlet weak var numberOfLikesLabel: UILabel!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		self.navigationController?.isNavigationBarHidden = false
		
		self.iAgreeButton.backgroundColor = Color.green
		self.iAgreeButton.addRoundedCorners(withRadius: 8)

		self.reportButton.backgroundColor = Color.blue
		self.reportButton.addRoundedCorners(withRadius: 8)
		
		self.typeOfProblemView.addRoundedCorners(withRadius: 8)
		self.typeOfProblemView.backgroundColor = Color.lightGray

		self.typeOfProblemLabel.textColor = Color.blue
		self.typeOfProblemDescriptionLabel.textColor = Color.blue
		
		self.numberOfLikesLabel.textColor = Color.green
		self.numberOfLikesLabel.font = UIFont.fontAwesome(ofSize: 19)
		
		if let longDescription = self.problem.longDescription {
			self.descriptionLabel.text = longDescription
		}
		
		else {
			self.descriptionLabel.text = ""
		}
		
		self.typeOfProblemDescriptionLabel.text = self.problem.typeOfProblem.name!
		
		self.typeOfProblemLabel.text = "ReportForm.TypeOfProblem".localized()
		self.iAgreeButton.setTitle("ReportForm.IAgree".localized().uppercased(), for: .normal)
		self.reportButton.setTitle("ReportForm.ReportFalseProblem".localized().uppercased(), for: .normal)
		self.noImageLabel.text = "ReportForm.NoImage".localized()
		
		self.setTitleText()
		
		self.problemTypeImageView.image = self.problem.typeOfProblem.iconImage(postiveOrNegative: self.problem.positiveOrNegativeProblem)
		self.problemTypeImageContainerView.backgroundColor = UIColor.clear

		self.setNumberOfLikes(self.problem.numberOfLikes)
	
		self.problemImageView.setShowActivityIndicator(true)
		self.problemImageView.setIndicatorStyle(.gray)
		self.problemImageView.addBlueRoundedCornerBorder()
		
		if let url = self.problem.imageURL {
			self.problemImageView.sd_setImage(with: URL(string: url))
			self.noImageLabel.isHidden = true
		}
		
		else {
			
			self.noImageLabel.isHidden = false
		}
		
		self.iAgreeButton.isEnabled = !ProblemsDataSource.isProblemLiked(forProblem: self.problem)
		self.reportButton.isEnabled = !ProblemsDataSource.isProblemReported(forProblem: self.problem)
		
		DataSource.ref.child(problem.id).child("numberOfLikes").observe(.value, with: {(snapshot) in
			if let likes = snapshot.value as? Int {
				self.problem.numberOfLikes = likes
				self.setNumberOfLikes(self.problem.numberOfLikes)
			}
		})
	}
	
	func setNumberOfLikes(_ number: Int!) {
		self.numberOfLikesLabel.text = String.fontAwesomeIcon(name: .check) + " \(number!)"
	}

	@IBAction func reportButtonPressed(_ sender: Any) {
		
	}
	
	@IBAction func iAgreeButtonPressed(_ sender: Any) {
		DataSource.setNumberOfLikesForProblemID(self.problem.id, numberOfLikes: self.problem.numberOfLikes + 1)
		self.iAgreeButton.isEnabled = false
		ProblemsDataSource.setProblemAsLiked(forProblem: self.problem)
	}
	
	override func localeChanged() {
		self.typeOfProblemLabel.text = "ReportForm.TypeOfProblem".localized()
		self.iAgreeButton.setTitle("ReportForm.IAgree".localized().uppercased(), for: .normal)
		self.reportButton.setTitle("ReportForm.ReportFalseProblem".localized().uppercased(), for: .normal)
		self.noImageLabel.text = "ReportForm.NoImage".localized()

		self.problem.typeOfProblem.localize()
		self.typeOfProblemDescriptionLabel.text = self.problem.typeOfProblem.name!
//		self.title = self.problem.typeOfProblem.name!
		
		self.setTitleText()
	}
	
	func setTitleText() {
		let titleLabel = UILabel.init(frame: CGRect(x: 0, y: 0, width: 200, height: 40))
		titleLabel.backgroundColor = .red
		titleLabel.text = self.problem.typeOfProblem.name!
		titleLabel.backgroundColor = UIColor.clear
		titleLabel.textColor = .black
		titleLabel.font = UIFont.systemFont(ofSize: titleLabel.font.pointSize, weight: UIFontWeightSemibold)
		titleLabel.textAlignment = .center
		titleLabel.adjustsFontSizeToFitWidth = true
		titleLabel.minimumScaleFactor = 0.5
		self.navigationItem.titleView = titleLabel
	}
	
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		let destinationVC = segue.destination as! SubmitReportViewController
		destinationVC.problemID = self.problem.id
		destinationVC.delegate = self
		
		let backItem = UIBarButtonItem()
		backItem.title = ""
		navigationItem.backBarButtonItem = backItem
    }

	func succefullyReported() {
		self.reportButton.isEnabled = false
		ProblemsDataSource.setProblemAsReported(forProblem: self.problem)
	}
}
