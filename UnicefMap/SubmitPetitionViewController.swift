//
//  SubmitPetitionViewController.swift
//  UnicefMap
//
//  Created by Simon Janevski on 11/26/16.
//  Copyright © 2016 Simon Janevski. All rights reserved.
//

import UIKit

class SubmitPetitionViewController: LongTextViewController {
	@IBOutlet weak var ombudsmanButton: UIButton!
	@IBOutlet weak var kzdButton: UIButton!
	@IBOutlet weak var textLabelBottonConstraint: NSLayoutConstraint!
	@IBOutlet weak var kzdButtonHeightConstraint: NSLayoutConstraint!
	
	var showsTermsAndConditions: Bool = false
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		self.kzdButton.addRoundedCorners(withRadius: 8)
		self.kzdButton.backgroundColor = Color.blue
		self.kzdButton.titleLabel?.textAlignment = .center
		self.kzdButton.setTitle("KZD".localized(), for: .normal)
		
		if self.showsTermsAndConditions {
			self.ombudsmanButton.removeFromSuperview()
			self.kzdButton.setTitle("LegalInfo".localized(), for: .normal)
			self.textLabelBottonConstraint.constant = 20
			self.kzdButtonHeightConstraint.constant = 60
		}
		
		else {
			self.ombudsmanButton.setTitle("PublicAttorney".localized(), for: .normal)
			self.ombudsmanButton.addRoundedCorners(withRadius: 8)
			self.ombudsmanButton.backgroundColor = Color.blue
			self.ombudsmanButton.titleLabel?.textAlignment = .center
		}
	}
    
	@IBAction func didPressOmbudsmanButton(_ sender: Any) {
		UIApplication.shared.openURL(URL(string: "http://ombudsman.mk/MK/podnesi_prestavka.aspx")!)
	}
	
	@IBAction func didPressKZDButton(_ sender: Any) {
		if self.showsTermsAndConditions {
			UIApplication.shared.openURL(URL(string: "https://www.unicef.org/about/legal.html")!)
		}
		else {
			UIApplication.shared.openURL(URL(string: "http://www.kzd.mk/?q=node/33")!)
		}
	}
}
