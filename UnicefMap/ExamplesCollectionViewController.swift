//
//  ExamplesCollectionViewController.swift
//  UnicefMap
//
//  Created by Simon Janevski on 10/22/16.
//  Copyright © 2016 Simon Janevski. All rights reserved.
//

import UIKit
import Localize_Swift

private let reuseIdentifier = "Cell"

class ExamplesCollectionViewController: UICollectionViewController {
	var allBarrierTypes : [ProblemType]!
	var currentlySelectedProblem : ProblemType?
	
	var screenSize: CGRect!
	var screenWidth: CGFloat!
	var screenHeight: CGFloat!
	
    override func viewDidLoad() {
        super.viewDidLoad()

		self.allBarrierTypes = ProblemsDataSource.getBarrierTypes()

		screenSize = UIScreen.main.bounds
		screenWidth = screenSize.width
		screenHeight = screenSize.height
		
		self.setTitleText()
		
		self.collectionView?.backgroundColor = Color.blue
		
		let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
		layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
		layout.itemSize = CGSize(width: (screenWidth / 2) - 0.5, height: (screenWidth / 2) - 0.5)
		layout.minimumInteritemSpacing = 0
		layout.minimumLineSpacing = 1
		collectionView!.collectionViewLayout = layout
		
		NotificationCenter.default.addObserver(self, selector: #selector(localeChanged), name: NSNotification.Name(LCLLanguageChangeNotification), object: nil)
    }
	
	func localeChanged() {
		self.setTitleText()
		self.allBarrierTypes = ProblemsDataSource.getBarrierTypes()
		self.collectionView?.reloadData()
	}
	
	func setTitleText() {
		let titleLabel = UILabel.init(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 40))
		titleLabel.text = "ScreenTitle.BarrierTypes.Title".localized()
		titleLabel.backgroundColor = UIColor.clear
		titleLabel.textColor = .black
		titleLabel.font = UIFont.systemFont(ofSize: titleLabel.font.pointSize, weight: UIFontWeightSemibold)
		titleLabel.textAlignment = .center
		titleLabel.adjustsFontSizeToFitWidth = true
		titleLabel.minimumScaleFactor = 0.5
		self.navigationItem.titleView = titleLabel
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

	
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
		if let problemDetails = segue.destination as? ExampleDetailsViewController {
			problemDetails.problemType = self.currentlySelectedProblem
			self.currentlySelectedProblem = nil
		}
		
    }


    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
		return self.allBarrierTypes.count

	}

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ExampleCollectionViewCell
		
		cell.setTitle(self.allBarrierTypes[indexPath.row].name, image: self.allBarrierTypes[indexPath.row].image)
		
        return cell
    }


    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */


    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
		self.currentlySelectedProblem = self.allBarrierTypes[indexPath.row]
		return true
    }


}
