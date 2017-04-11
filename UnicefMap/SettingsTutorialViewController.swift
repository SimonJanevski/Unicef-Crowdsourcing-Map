//
//  SettingsTutorialViewController.swift
//  UnicefMap
//
//  Created by Simon Janevski on 12/13/16.
//  Copyright © 2016 Simon Janevski. All rights reserved.
//

import UIKit

class SettingsTutorialViewController: LongTextViewController {

	@IBOutlet weak var browsingLabel: UILabel!
	@IBOutlet weak var browsingTextLabel: UILabel!
	@IBOutlet weak var reportLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
		
		self.browsingLabel.text = "tutorial.Browsing".localized()
		self.browsingLabel.textColor = Color.blue
		self.browsingTextLabel.text = "tutorial".localized()
		self.reportLabel.text = "tutorial.Report".localized()
		self.reportLabel.textColor = Color.blue
		self.textLabel.text = "tutorial.Steps".localized()
		
		
		
		// Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
