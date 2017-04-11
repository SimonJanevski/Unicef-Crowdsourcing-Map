//
//  SettingsTableViewController.swift
//  UnicefMap
//
//  Created by Simon Janevski on 9/13/16.
//  Copyright © 2016 Simon Janevski. All rights reserved.
//

import UIKit
import Localize_Swift

class SettingsTableViewController: UITableViewController {

	@IBOutlet weak var langaugeLabel: UILabel!
	@IBOutlet weak var selectedLanguageLabel: UILabel!
	@IBOutlet weak var tutorialLabel: UILabel!
	@IBOutlet weak var termsLabel: UILabel!
	@IBOutlet weak var submitPetitionLabel: UILabel!
	@IBOutlet weak var aboutLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
		
		self.title = "ScreenTitle.More".localized()
		self.loadGUI()
		
		NotificationCenter.default.addObserver(self, selector: #selector(localeChanged), name: NSNotification.Name(LCLLanguageChangeNotification), object: nil)
	}
	
	func loadGUI() {
		self.updateCurrentLanguage()
		
		self.langaugeLabel.text = "Settings.Language".localized()
		self.tutorialLabel.text = "Settings.Tutorial".localized()
		self.termsLabel.text = "Settings.TermsOfUse".localized()
		self.submitPetitionLabel.text = "Settings.SubmitPetition".localized()
		self.aboutLabel.text = "Settings.About".localized()
	}
	
	func localeChanged() {
		self.loadGUI()
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

		self.tableView.deselectRow(at: indexPath, animated: true)

		switch (indexPath as NSIndexPath).row {
		case 0:
			let actionSheetController: UIAlertController = UIAlertController(title: "Settings.SelectLanguage".localized(), message: nil, preferredStyle: .actionSheet)
			
			let cancelActionButton: UIAlertAction = UIAlertAction(title: "Cancel".localized(), style: .cancel) { action -> Void in }
			actionSheetController.addAction(cancelActionButton)
			
			let macedonianActionButton: UIAlertAction = UIAlertAction(title: "Macedonian.Picker".localized(), style: .default) { action -> Void in
				Localize.setCurrentLanguage("mk")
			}
			actionSheetController.addAction(macedonianActionButton)
			
			let englishActionButton: UIAlertAction = UIAlertAction(title: "English.Picker".localized(), style: .default){ action -> Void in
				Localize.setCurrentLanguage("en")
			}
			actionSheetController.addAction(englishActionButton)
			
			let albanianActionButton: UIAlertAction = UIAlertAction(title: "Albanian.Picker".localized(), style: .default) { action -> Void in
				Localize.setCurrentLanguage("sq")
			}
			actionSheetController.addAction(albanianActionButton)
			
			self.present(actionSheetController, animated: true, completion: nil)

		case 1:
			self.performSegue(withIdentifier: "showTutorial", sender: ["Settings.Tutorial" : "tutorial"])
		case 2:
			self.performSegue(withIdentifier: "showLongText", sender: ["Settings.TermsOfUse" : "terms of usage"])
		case 3:
			self.performSegue(withIdentifier: "submitReport", sender: ["Settings.SubmitPetition" : "petition"])
		case 4:
			self.performSegue(withIdentifier: "showAbout", sender: ["Settings.About" : "about"])

		default:
			break
		}
	}
	
	func updateCurrentLanguage() {
		switch Localize.currentLanguage() {
		case "en":
			self.selectedLanguageLabel.text = "English".localized()
		case "mk":
			self.selectedLanguageLabel.text = "Macedonian".localized()
		case "sq":
			self.selectedLanguageLabel.text = "Albanian".localized()
		default:
			break
		}
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "showAbout"  || segue.identifier == "showTutorial" {
			let longTextVC = segue.destination as! LongTextViewController
			
			if let dict = sender as? [String : String] {
				let text = dict[dict.keys.first!]
				let title = dict.keys.first!
				
				longTextVC.text = text?.localized()
				longTextVC.title = title.localized().capitalized
			}
		}
		
		else if segue.identifier == "submitReport" || segue.identifier == "showLongText" {
			let longTextVC = segue.destination as! SubmitPetitionViewController
			
			if let dict = sender as? [String : String] {
				let text = dict[dict.keys.first!]
				let title = dict.keys.first!
				
				longTextVC.text = text?.localized()
				longTextVC.title = title.localized().capitalized
				
				if segue.identifier == "showLongText" {
					longTextVC.showsTermsAndConditions = true
				}
			}
		}
	}
}
