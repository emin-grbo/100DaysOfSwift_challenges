//
//  ViewController.swift
//  Project16
//
//  Created by Emin Roblack on 4/2/19.
//  Copyright © 2019 Emin Roblack. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let london = Capital(title: "London", coordinate: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), info: "Home to the 2012 summer olympics")
        
        let oslo = Capital(title: "Oslo", coordinate: CLLocationCoordinate2D(latitude: 59.95, longitude: 10.75), info: "Founded over 1000 years ago")
        
        let paris = Capital(title: "Paris", coordinate: CLLocationCoordinate2D(latitude: 48.8567, longitude: 2.3508), info: "Often called City of Light")
        
        let rome = Capital(title: "Rome", coordinate: CLLocationCoordinate2D(latitude: 41.9, longitude: 12.5), info: "Has a whole country inside it")

        mapView.addAnnotations([london, oslo, paris, rome])
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(changeMap))
    }
    
    
    @objc func changeMap() {
        let ac = UIAlertController(title: "Change Map Style", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Satelite", style: .default) {
            [weak self] result in
            self?.mapView.mapType = MKMapType.satellite
        })
        ac.addAction(UIAlertAction(title: "Hybrid", style: .default) {
            [weak self] result in
            self?.mapView.mapType = MKMapType.hybrid
        })
        ac.addAction(UIAlertAction(title: "HybrindFlyover", style: .default) {
            [weak self] result in
            self?.mapView.mapType = MKMapType.hybridFlyover
        })
        present(ac, animated: true)
    }
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard annotation is Capital else { return nil }
        
        let identifier = "Capital"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            
            let btn = UIButton(type: .detailDisclosure)
            annotationView?.rightCalloutAccessoryView = btn
        } else {
            annotationView?.annotation = annotation
        }
        annotationView?.pinTintColor = .black
        return annotationView
    }
    
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        guard let capital = view.annotation as? Capital else { return }
        
        let placeName = capital.title
//        let placeInfo = capital.info
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "detailVC") as! detailVC
        vc.city = placeName
        navigationController?.pushViewController(vc, animated: true)
        
        // ALERT OPTION
        //        let ac = UIAlertController(title: placeName, message: placeInfo, preferredStyle: .alert)
        //        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        //        present(ac, animated: true)
    }
}

