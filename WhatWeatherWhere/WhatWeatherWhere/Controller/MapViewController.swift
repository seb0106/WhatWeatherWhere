//*
// * Copyright (C) Schweizerische Bundesbahnen SBB, 2020.
//*

import Foundation
import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate, UIGestureRecognizerDelegate {
    @IBOutlet weak var mapView: MKMapView!
    
    var mapPin: MKPointAnnotation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        // Do any additional setup after loading the view.
        let longPressed = UILongPressGestureRecognizer(target: self, action: #selector(handleTap(gestureRegonizer:)))
        longPressed.delegate = self
        longPressed.numberOfTapsRequired = 0
        longPressed.minimumPressDuration = 0.5
        mapView.addGestureRecognizer(longPressed)
    }
    
    
    @objc func handleTap(gestureRegonizer: UILongPressGestureRecognizer){
        if gestureRegonizer.state == .began{
            let location = gestureRegonizer.location(in: mapView)
            let coordination = mapView.convert(location, toCoordinateFrom: mapView)
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordination
            mapView.addAnnotation(annotation)
        }
    }


}

