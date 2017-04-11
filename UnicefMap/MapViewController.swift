//
//  MapViewController.swift
//  UnicefMap
//
//  Created by Simon Janevski on 7/20/16.
//  Copyright © 2016 Simon Janevski. All rights reserved.
//

import UIKit
import GoogleMaps
import FontAwesome_swift

class MapViewController: AbstractViewController, CLLocationManagerDelegate, GMSMapViewDelegate {

	let manager = CLLocationManager()
	var camera : GMSCameraPosition!
	var mapView : GMSMapView!
	var items : [Problem]!
	
	var isMapMoved = false
	
	var lastCreatedMarker: String? {
		didSet {
			self.zoomMapToLastCreatedMarker()
		}
	}

    override func viewDidLoad() {
        super.viewDidLoad()
		manager.delegate = self
		
		if CLLocationManager.locationServicesEnabled() {
			manager.requestLocation()
		}

		camera = GMSCameraPosition.camera(withLatitude: 41.692, longitude: 21.746, zoom: 7.611)
		mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
		mapView.delegate = self
		mapView.isMyLocationEnabled = true
		mapView.settings.myLocationButton = true
		self.view = mapView
		mapView.addObserver(self, forKeyPath: "myLocation", options: NSKeyValueObservingOptions.new, context: nil)

		self.updateMarkers(shouldAnimate: true)
	
		DataSource.getAllProblems { (items) in
			self.items = items
			self.updateMarkers()
		}
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		self.navigationController?.setNavigationBarHidden(true, animated: true)
	}
	
	override func localeChanged() {
		for problem in self.items {
			problem.typeOfProblem.localize()
		}
		self.updateMarkers()
	}
	
	func zoomMapToLastCreatedMarker() {
		for problem in self.items {
			if (problem.id == self.lastCreatedMarker) && (problem.location != nil) {
				mapView.animate(with: GMSCameraUpdate.setCamera(GMSCameraPosition.camera(withTarget: problem.location, zoom: 17)))
				self.lastCreatedMarker = nil
			}
		}
	}
	
	func updateMarkers(shouldAnimate: Bool = false) {
		var selectedMarker = self.mapView.selectedMarker
		self.mapView.clear()
		
		for problem in self.items {
			if let position = problem.location {
				let marker = GMSMarker()
				marker.position = position
				if selectedMarker?.position.latitude == position.latitude && selectedMarker?.position.longitude == position.longitude {
					selectedMarker = marker
				}
				marker.appearAnimation = shouldAnimate ? kGMSMarkerAnimationPop : kGMSMarkerAnimationNone
				marker.title = problem.typeOfProblem.name
				marker.snippet = "Map.Pin.More".localized()
				marker.map = mapView
				marker.icon = problem.typeOfProblem.markerImage(postiveOrNegative: problem.positiveOrNegativeProblem)
				marker.userData = problem
			}
		}
		self.mapView.selectedMarker = selectedMarker
	}
	
	func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
		self.isMapMoved = true
	}

	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		if let location = locations.first {
			print("Found user's location: \(location)")
			if self.isMapMoved == false {
//				mapView.animate(with: GMSCameraUpdate.setCamera(GMSCameraPosition.camera(withTarget: location.coordinate, zoom: 14.5)))
			}
		}
	}
	
	override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
		if self.isMapMoved == false {
			let myLocation: CLLocation = change![NSKeyValueChangeKey.newKey] as! CLLocation
			self.mapView.camera = GMSCameraPosition.camera(withTarget: myLocation.coordinate, zoom: 14.5)
		}
	}
	
	func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
		print("Failed to find user's location: \(error.localizedDescription)")
	}
	
	func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
		if status == .authorizedAlways || status == .authorizedWhenInUse {
			manager.requestLocation()
		}
	}
	
	func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
		performSegue(withIdentifier: "showDetails", sender: marker)
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		let destinationVC = segue.destination as! ProblemDetailsViewController
		destinationVC.problem = (sender as! GMSMarker).userData as? Problem
		
		let backItem = UIBarButtonItem()
		backItem.title = ""
		navigationItem.backBarButtonItem = backItem
	}
	
	func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
		let infoWindow = Bundle.main.loadNibNamed("CustomInfoWindow", owner: self, options: nil)?.first! as! CustomInfoWindow
		let problem = marker.userData as! Problem
		infoWindow.titleLabel.text = problem.typeOfProblem.name
		infoWindow.subtitleLabel.text = "Map.Pin.More".localized()
		infoWindow.backgroundView.addRoundedCorners(withRadius: 5)
		infoWindow.layer.shadowColor = UIColor.black.cgColor
		infoWindow.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
		infoWindow.layer.shadowOpacity = 0.7
		
		infoWindow.layer.shouldRasterize = true
		infoWindow.layer.rasterizationScale = UIScreen.main.scale
		
		return infoWindow
	}
}
