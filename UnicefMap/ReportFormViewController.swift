//
//  ReportFormViewController.swift
//  UnicefMap
//
//  Created by Simon Janevski on 10/23/16.
//  Copyright © 2016 Simon Janevski. All rights reserved.
//

import UIKit
import PKHUD
import Photos

class ReportFormViewController: AbstractViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate {

	@IBOutlet weak var photoLabel: UILabel!
	@IBOutlet weak var photoImageView: UIImageView!
	@IBOutlet weak var typeOfProblemLabel: UILabel!
	@IBOutlet weak var typeOfProblemSegmentedView: UISegmentedControl!
	@IBOutlet weak var problemTypePickerView: UIPickerView!
	@IBOutlet weak var desriptionLabel: UILabel!
	@IBOutlet weak var descriptionTextView: UITextView!
	@IBOutlet weak var termsOfUsageButton: UnicefButton!
	@IBOutlet weak var termsOfUsageSwitch: UISwitch!
	@IBOutlet weak var submitButton: UnicefButton!
	@IBOutlet weak var scrollView: UIScrollView!
	
	@IBOutlet weak var takePhotoButton: UIButton!
	@IBOutlet weak var galleryButton: UIButton!
	@IBOutlet weak var clearImageButton: UIButton!
	
	@IBOutlet weak var noLocationView: UIView!
	@IBOutlet weak var noLocationInfoView: UIView!
	@IBOutlet weak var noLocationTitleLabel: UILabel!
	@IBOutlet weak var noLocationSubtitleLabel: UILabel!
	@IBOutlet weak var goToSettingsButton: UIButton!
	
	let imagePicker = UIImagePickerController()
	var imageURL : URL?
	
	let manager = CLLocationManager()
	var location : CLLocation?
	var isWaitingForLocation = false
	
	var preselectedProblem : ProblemType?
	var allBarrierTypes : [ProblemType]!
	
	var problem = Problem()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.problemTypePickerView.delegate = self
		self.problemTypePickerView.dataSource = self
		self.descriptionTextView.delegate = self
		
		self.photoImageView.isHidden = true
		self.clearImageButton.isHidden = true
				
		self.initAppearance()
		
		imagePicker.delegate = self
		self.manager.delegate = self
		
		if CLLocationManager.locationServicesEnabled() {
			manager.requestLocation()
		}
		
		self.allBarrierTypes = ProblemsDataSource.getBarrierTypes()
		
		self.noLocationInfoView.addRoundedCorners(withRadius: 15)

		NotificationCenter.default.addObserver(self, selector: #selector(self.checkForLocationServices), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		self.checkForLocationServices()
		
		if self.preselectedProblem != nil {
			self.problemTypePickerView.selectRow(self.allBarrierTypes.index(where: {$0.id == self.preselectedProblem?.id})!, inComponent: 0, animated: false)
			self.preselectedProblem = nil
		}
	}
	
	func checkForLocationServices() {
		if CLLocationManager.authorizationStatus() == .denied {

			if self.noLocationView.isHidden == false {
				return
			}
			self.noLocationView.alpha = 0
			self.noLocationView.isHidden = false
			
			UIView.animate(withDuration: 0.3, animations: {
				self.noLocationView.alpha = 1
			}) { (finished) in
				self.noLocationView.isHidden = false
			}
		}

		else {
			UIView.animate(withDuration: 0.3, animations: {
				self.noLocationView.alpha = 0
			}) { (finished) in
				self.noLocationView.isHidden = true
			}
		}
	}
	
	func loadGUI() {
		self.photoLabel.text = "ReportForm.Photo".localized()
		self.typeOfProblemLabel.text = "ReportForm.TypeOfProblem".localized()
		self.typeOfProblemSegmentedView.setTitle("ReportForm.Positive".localized(), forSegmentAt: 0)
		self.typeOfProblemSegmentedView.setTitle("ReportForm.Negative".localized(), forSegmentAt: 1)
		self.desriptionLabel.text = "ReportForm.Description".localized()
		self.termsOfUsageButton.setTitle("ReportForm.Terms".localized(), for: .normal)
		self.submitButton.setTitle("ReportForm.Report".localized().uppercased(), for: .normal)
		
		self.noLocationTitleLabel.text = "ReportForm.LocationDisabled".localized()
		self.noLocationSubtitleLabel.text = "ReportForm.LocationDisabledDescription".localized()
		self.goToSettingsButton.setTitle("ReportForm.LocationDisabledAction".localized(), for: .normal)
	}
	
	func initAppearance() {
		
		self.loadGUI()
		
		self.photoImageView.addBlueRoundedCornerBorder()
		self.takePhotoButton.addBlueRoundedCornerBorder()
		self.galleryButton.addBlueRoundedCornerBorder()
		self.descriptionTextView.addRoundedCorners(withRadius: 8)
		self.descriptionTextView.backgroundColor = Color.gray
		self.termsOfUsageSwitch.thumbTintColor = Color.blue
		self.submitButton.addRoundedCorners(withRadius: 8)
		self.submitButton.backgroundColor = Color.blue
		self.typeOfProblemSegmentedView.tintColor = Color.blue
		self.typeOfProblemSegmentedView.selectedSegmentIndex = UISegmentedControlNoSegment
		
		self.photoLabel.textColor = Color.blue
		self.typeOfProblemLabel.textColor = Color.blue
		self.desriptionLabel.textColor = Color.blue
		self.termsOfUsageButton.setTitleColor(Color.blue, for: .normal)
		
		let userDefaults = UserDefaults.standard
		self.termsOfUsageSwitch.isOn = userDefaults.bool(forKey: "terms")
		self.submitButton.isEnabled = userDefaults.bool(forKey: "terms")
	}
	
	func resetForm() {

		self.photoImageView.isHidden = true
		self.clearImageButton.isHidden = true
		self.photoImageView.image = nil
		self.takePhotoButton.isHidden = false
		self.galleryButton.isHidden = false
		
		self.problemTypePickerView.selectRow(0, inComponent: 0, animated: false)
		self.typeOfProblemSegmentedView.selectedSegmentIndex = 0
		self.segmentedControlDidChageValue(self.typeOfProblemSegmentedView)
		self.descriptionTextView.text = ""
		self.problem = Problem()
		
		self.typeOfProblemSegmentedView.tintColor = Color.blue
		self.typeOfProblemSegmentedView.selectedSegmentIndex = UISegmentedControlNoSegment
		
		let desiredOffset = CGPoint(x: 0, y: -self.scrollView.contentInset.top)
		self.scrollView.setContentOffset(desiredOffset, animated: false)
	}
	
	@IBAction func didPressClearImageButton(_ sender: Any) {
		self.photoImageView.isHidden = true
		self.clearImageButton.isHidden = true
		self.photoImageView.image = nil
		self.problem.image = nil
		self.takePhotoButton.isHidden = false
		self.galleryButton.isHidden = false
	}
	
	override func localeChanged() {
		self.loadGUI()
		for problemType in self.allBarrierTypes {
			problemType.localize()
		}
		
		self.problemTypePickerView.reloadComponent(0)
	}
	
	func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
		return textView.text.characters.count + (text.characters.count - range.length) <= 300
	}
	
	func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
		return 40
	}
    
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return self.allBarrierTypes.count
	}
	
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}
	
	func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
		let view = PickerItemView.instanceFromNib()
		view.frame.size = CGSize.init(width: self.problemTypePickerView.frame.width, height: 40)
		
		view.titleLabel.text = self.allBarrierTypes[row].name
		view.imageView.image = self.allBarrierTypes[row].image
		
		return view
	}
	
	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
	
	}
	
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		if let location = locations.first {
			self.location = location
			if isWaitingForLocation {
				isWaitingForLocation = false
				self.didPressSubmit(self.submitButton)
			}
		}
	}
	
	func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//		HUD.hide()
//		HUD.flash(.labeledError(title: "Location".localized(), subtitle: "Location".localized()), delay: 4)
	}
	
	@IBAction func didPressSubmit(_ sender: AnyObject) {
		
		if self.problem.image == nil {
			HUD.flash(.labeledError(title: "ReportForm.Error".localized(), subtitle: "ReportForm.ErrorDescription".localized()), delay: 4)
			return
		}
		
		if self.typeOfProblemSegmentedView.selectedSegmentIndex == UISegmentedControlNoSegment {
			HUD.flash(.labeledError(title: "ReportForm.Error".localized(), subtitle: "ReportForm.TypeOfProblemError".localized()), delay: 4)
			return
		}
		
		HUD.show(.progress)
		
		if problem.location == nil && self.location == nil {
			isWaitingForLocation = true
			return
		}
		
		if problem.location == nil {
			problem.location = self.location?.coordinate
		}
		
		problem.longDescription = self.descriptionTextView.text
		problem.typeOfProblemID = self.allBarrierTypes[self.problemTypePickerView.selectedRow(inComponent: 0)].id
		problem.positiveOrNegativeProblem = self.typeOfProblemSegmentedView.selectedSegmentIndex == 0 ? "positive" : "negative"
		problem.numberOfLikes = 0
		problem.date = Date()
		DataSource.saveProblem(problem, success: {(success, key) in
			HUD.hide()
			self.resetForm()
			self.performSegue(withIdentifier: "success", sender: key)
		}, failure: {(error) in
			HUD.flash(.labeledError(title: "ReportForm.ErrorSubmiting".localized(), subtitle: "ReportForm.TryAgain".localized()), delay: 1)
		})
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "success" {
			let successVC = segue.destination as! SuccessViewController
			successVC.key = sender as! String
		}
		
		else if segue.identifier == "showTerms" {
			let longTextVC = segue.destination as! SubmitPetitionViewController

			longTextVC.title = "Settings.TermsOfUse".localized().capitalized
			longTextVC.text = "terms of usage".localized()
			longTextVC.showsTermsAndConditions = true
		}
	}
	
	@IBAction func didChangeTermsOfUsageSwitch(_ sender: UISwitch) {
		let userDefaults = UserDefaults.standard
		userDefaults.set(sender.isOn, forKey: "terms")
	
		self.submitButton.isEnabled = sender.isOn
	}
	
	@IBAction func segmentedControlDidChageValue(_ sender: UISegmentedControl) {
		sender.tintColor = sender.selectedSegmentIndex == 0 ? Color.green : UIColor.red
	}
	
	@IBAction func didPressTakePhotoButton(_ sender: Any) {
		imagePicker.allowsEditing = false
		imagePicker.sourceType = .camera
		
		present(imagePicker, animated: true, completion: nil)
	}
	
	@IBAction func didPressGalletyButton(_ sender: Any) {
		
		imagePicker.allowsEditing = false
		imagePicker.sourceType = .photoLibrary
		
		present(imagePicker, animated: true, completion: nil)
	}

	// MARK: - UIImagePickerControllerDelegate Methods
	
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
		
		var shouldShowAlert = false
		
		if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
			self.photoImageView.image = pickedImage
			self.photoImageView.isHidden = false
			self.clearImageButton.isHidden = false
			self.photoImageView.contentMode = .scaleAspectFit
			self.problem.image = pickedImage.resizeWith(percentage: 0.2)!
			self.takePhotoButton.isHidden = true
			self.galleryButton.isHidden = true
			
			if let imageUrl = info[UIImagePickerControllerReferenceURL] as? NSURL { // image from library
				if let asset = PHAsset.fetchAssets(withALAssetURLs: [imageUrl as URL], options: nil).lastObject {
					if let location = asset.location {
						self.problem.location = location.coordinate
					}
					else {
						// nema lokacija, pojavi alert deka e nevalidna slika
						self.problem.location = nil
						self.problem.image = nil
						self.takePhotoButton.isHidden = false
						self.galleryButton.isHidden = false
						self.photoImageView.isHidden = true
						self.clearImageButton.isHidden = true
						
						shouldShowAlert = true
					}
				}
			}
				
			else { // image from camera
				self.problem.location = nil
				self.savingThis(image: pickedImage, completion: { (asset) in })
			}
		}
		dismiss(animated: true, completion: {
	
			if shouldShowAlert {
				let alert = UIAlertController(title: "ReportForm.InvalidPhoto".localized(), message: "ReportForm.InvalidPhotoDesription".localized(), preferredStyle: .alert)
				let okButton = UIAlertAction.init(title: "OK", style: .default, handler: {(action) in })
				alert.addAction(okButton)
				self.present(alert, animated: false, completion: nil)
			}
		})
	}
	
	
	func savingThis(image : UIImage, completion : @escaping (PHAsset?) -> ())
	{
		var localIdentifier : String?
		let imageManager = PHPhotoLibrary.shared()
		
		imageManager.performChanges({ () -> Void in
			
			let request = PHAssetChangeRequest.creationRequestForAsset(from: image)
			
			request.location = self.location
			
			if let properAsset = request.placeholderForCreatedAsset {
				localIdentifier = properAsset.localIdentifier
			}
			else {
				completion(nil)
			}
			
		}, completionHandler: { (success, error) -> Void in
			
			if let properLocalIdentifier = localIdentifier {
				
				let result = PHAsset.fetchAssets(withLocalIdentifiers: [properLocalIdentifier], options: nil)
				
				if result.count > 0   {
					completion(result[0])
				}
				else {
					completion(nil)
				}
			}
			else {
				completion(nil)
			}
		})
	}
	
	@IBAction func goToSettingsButtonPressed(_ sender: Any) {
		UIApplication.shared.openURL(URL(string: UIApplicationOpenSettingsURLString)!)
	}
	
	@IBAction func didPressTermsOfUsageButton(_ sender: Any) {
//		let navVC = self.tabBarController?.viewControllers?[3] as! UINavigationController
//		navVC.popToRootViewController(animated: false)
//		let settingsVC = navVC.viewControllers.first as! SettingsTableViewController
//		settingsVC.shouldShowTerms = true
//		self.tabBarController?.selectedIndex = 3
	}
}
