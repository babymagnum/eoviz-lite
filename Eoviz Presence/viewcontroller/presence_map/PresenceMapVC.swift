//
//  PresenceMapVC.swift
//  Eoviz Presence
//
//  Created by Arief Zainuri on 13/04/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import UIKit
import GoogleMaps
import DIKit
import RxSwift

class PresenceMapVC: BaseViewController, CLLocationManagerDelegate {

    @IBOutlet weak var labelShift: CustomLabel!
    @IBOutlet weak var viewPresenceParent: UIView!
    @IBOutlet weak var buttonTitle: CustomButton!
    @IBOutlet weak var buttonTime: CustomButton!
    @IBOutlet weak var buttonOnTheZone: CustomButton!
    @IBOutlet weak var viewPresence: CustomGradientView!
    @IBOutlet weak var labelJamMasuk: CustomLabel!
    @IBOutlet weak var labelJamKeluar: CustomLabel!
    @IBOutlet weak var viewPresenseHeight: CustomMargin!
    @IBOutlet weak var viewOutsideTheZoneHeight: CustomMargin!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var viewOutsideTheZone: CustomView!
    
    @Inject private var presensiVM: PresensiVM
    private var disposeBag = DisposeBag()
    private var locationManager = CLLocationManager()
    private var marker: GMSMarker?
    private var circles = [Circle]()
    private var pickedCheckpointId = 0
    
    var presenceData: PresensiData!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        observeData()
        
        drawCircle()
        
        initLocationManager()
    }
    
    private func observeData() {
        presensiVM.time.subscribe(onNext: { value in
            self.buttonTime.setTitle(value, for: .normal)
        }).disposed(by: disposeBag)
        
        presensiVM.presence.subscribe(onNext: { value in
            self.labelJamMasuk.text = value.presence_shift_start ?? ""
            self.labelJamKeluar.text = value.presence_shift_end ?? ""
            self.labelShift.text = value.shift_name ?? ""
            self.buttonTitle.setTitle(value.is_presence_in ?? false ? "presence_in".localize() : "presence_out".localize(), for: .normal)
        }).disposed(by: disposeBag)
    }
    
    private func initLocationManager() {
        locationManager.delegate = self
        //this line of code below to prompt the user for location permission
        locationManager.requestWhenInUseAuthorization()
        //this line of code below to set the range of the accuracy
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        //this line of code below to start updating the current location
        locationManager.startUpdatingLocation()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    func updateLocationCoordinates(coordinates: CLLocationCoordinate2D) {
        if let _marker = marker {
            CATransaction.begin()
            CATransaction.setAnimationDuration(1.0)
            _marker.position =  coordinates
            CATransaction.commit()
        } else {
            marker = GMSMarker()
            marker?.position = coordinates
            marker?.icon = UIImage(named: "rectangle23")
            marker?.map = mapView
            marker?.appearAnimation = .pop
        }
    }
    
    private func circleInsideRadius(circle: GMSCircle) {
        circle.fillColor = UIColor.peacockBlue.withAlphaComponent(0.4)
        circle.strokeColor = UIColor.peacockBlue.withAlphaComponent(0.4)
        circle.strokeWidth = 1
    }
    
    private func circleOutsideRadius(circle: GMSCircle) {
        circle.fillColor = UIColor.rustRed.withAlphaComponent(0.4)
        circle.strokeColor = UIColor.rustRed.withAlphaComponent(0.4)
        circle.strokeWidth = 1
    }
    
    func addRadiusCircle(circle: Circle, isInside: Bool, isUpdate: Bool){
        
        if isInside {
            self.pickedCheckpointId = circle.checkpoint_id
            circleInsideRadius(circle: circle.circle)
        } else {
            circleOutsideRadius(circle: circle.circle)
        }
        
        if !isUpdate {
            circle.circle.map = mapView
        }
    }
    
    private func checkDistance(_ currentLocation: CLLocation) {
        for circle in circles {
            print(circle.checkpoint_id)
            let buildingLat = circle.circle.position.latitude
            let buildingLon = circle.circle.position.longitude
            let radius = circle.circle.radius + 5
            
            let distance = currentLocation.distance(from: CLLocation(latitude: buildingLat, longitude: buildingLon))
            
            if distance <= radius {
                self.showPressence()
                self.addRadiusCircle(circle: circle, isInside: true, isUpdate: true)
                break
            } else {
                self.hidePressence()
                self.addRadiusCircle(circle: circle, isInside: false, isUpdate: true)
            }
        }
    }
    
    private func showPressence() {
        UIView.animate(withDuration: 0.2) {
            self.buttonOnTheZone.isHidden = false
            self.viewPresenseHeight.constant = self.screenWidth * 0.11
            self.viewPresence.alpha = 1
            self.viewOutsideTheZoneHeight.constant = 0
            self.viewOutsideTheZone.alpha = 0
            self.viewPresenceParent.layoutIfNeeded()
        }
    }
    
    private func hidePressence() {
        UIView.animate(withDuration: 0.2) {
            self.buttonOnTheZone.isHidden = true
            self.viewOutsideTheZone.alpha = 1
            self.viewPresence.alpha = 0
            self.viewPresenseHeight.constant = 0
            self.viewOutsideTheZoneHeight.constant = self.screenWidth * 0.2
            self.viewPresenceParent.layoutIfNeeded()
        }
    }
    
    private func drawCircle() {
        for checkpoint in presenceData.presence_zone {
            let buildingLat = Double(checkpoint.preszone_latitude ?? "0") ?? 0
            let buildingLon = Double(checkpoint.preszone_longitude ?? "0") ?? 0
            let circlePosition = CLLocationCoordinate2D(latitude: buildingLat, longitude: buildingLon)
            let stringRadius = checkpoint.preszone_radius?.components(separatedBy: ".")
            guard let nnRadius = stringRadius else {
                return
            }
            let radius = Double(nnRadius[0])!

            let circle = Circle(checkpoint_id: checkpoint.preszone_id ?? 0, circle: GMSCircle(position: circlePosition, radius: radius))
            self.circles.append(circle)

            self.addRadiusCircle(circle: circle, isInside: false, isUpdate: false)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last{
            let currentLocation = CLLocation(latitude: location.coordinate.latitude as CLLocationDegrees, longitude: location.coordinate.longitude as CLLocationDegrees)
            updateLocationCoordinates(coordinates: location.coordinate)
            mapView.animate(to: GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: Float(self.presenceData.zoom_maps ?? 17)))
            checkDistance(currentLocation)
        }
    }
    
    @IBAction func buttonBackClick(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}