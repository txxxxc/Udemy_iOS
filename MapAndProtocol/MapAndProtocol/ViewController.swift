//
//  ViewController.swift
//  MapAndProtocol
//
//  Created by tomoya tanaka on 2020/09/11.
//  Copyright © 2020 Tomoya Tanaka. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate, UIGestureRecognizerDelegate, SearchLocationDelegate {
    
    var addressString: String = ""
    @IBOutlet var longPress: UILongPressGestureRecognizer!
    @IBOutlet weak var mapView: MKMapView!
    var locationManager: CLLocationManager!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var settingButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        settingButton.backgroundColor = .white
        settingButton.layer.cornerRadius = 20.0
        
    }

    @IBAction func longPressTap(_ sender: UILongPressGestureRecognizer) {
        
        if sender.state == .began {
        
            
        } else if sender.state == .ended {
            let tapPoint = sender.location(in: view)
            let center = mapView.convert(tapPoint, toCoordinateFrom: mapView)
            let lat = center.latitude
            let log = center.longitude
            convert(lat: lat, log: log)
        }
        
    }
    
    func convert(lat: CLLocationDegrees, log: CLLocationDegrees) {
        
        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: lat, longitude: log)
        
        geocoder.reverseGeocodeLocation(location) {
            (placeMark, error) in
            if let placeMark = placeMark {
                if let pm = placeMark.first {
                    if pm.administrativeArea != nil || pm.locality != nil {
                        self.addressString = pm.name! + pm.administrativeArea! + pm.locality!
                    } else {
                        self.addressString = pm.name!
                    }
                    self.addressLabel.text = self.addressString
                }
            }
            
        }
        
    }
    
    
    @IBAction func gotoSearchVC(_ sender: Any) {
        performSegue(withIdentifier: "next", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "next" {
            let nextVC = segue.destination as!
                NextViewController
            nextVC.delegate = self
        }
    }
    
    func searchLocation(idoValue: String, keidoValue: String) {
        if idoValue.isEmpty != true && keidoValue.isEmpty != true {
            
            let idoString = idoValue
            let keidoString = keidoValue
            // 緯度、軽度からコーディネート
            let coordinate = CLLocationCoordinate2DMake(Double(idoString)!, Double(keidoString)!)
            
            // 表示する範囲を指定
            let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            
            // 領域を指定
            let region = MKCoordinateRegion(center: coordinate, span: span)
            
            // 領域をmapViewに設定
            mapView.setRegion(region, animated: true)
            
            // 緯度経度から住所へ変換
            convert(lat: Double(idoString)!, log: Double(keidoString)!)
            
            // ラベルに表示
            addressLabel.text = addressString
            
        } else {
            addressLabel.text = "表示できません"
        }
    }
    
    
}

