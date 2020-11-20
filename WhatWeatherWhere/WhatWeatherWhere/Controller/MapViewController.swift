//*
// * Copyright (C) Schweizerische Bundesbahnen SBB, 2020.
//*

import Foundation
import UIKit
import MapKit
import CoreData

class MapViewController: UIViewController, MKMapViewDelegate, UIGestureRecognizerDelegate, NSFetchedResultsControllerDelegate {
    @IBOutlet weak var mapView: MKMapView!
    
    var annotations = [Pin]()
    var pinArray = [MKPointAnnotation]()
    @IBOutlet weak var deleteButton: UIButton!
    var mapPin: MKPointAnnotation?
    
    var pin: Pin!
    var fetchedResultsController: NSFetchedResultsController<Pin>!
    
    var selectedPin: MKAnnotation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        deleteButton.isHidden = true
        mapView.delegate = self
        // Do any additional setup after loading the view.
        let longPressed = UILongPressGestureRecognizer(target: self, action: #selector(handleTap(gestureRegonizer:)))
        longPressed.delegate = self
        longPressed.numberOfTapsRequired = 0
        longPressed.minimumPressDuration = 0.5
        mapView.addGestureRecognizer(longPressed)
        appDelegate.dataController.load()
        setupFetchedResultsController()
        setupPins()
    }
    
    func setupPins(){
        if let pins = fetchedResultsController.fetchedObjects {
            for pin in pins {
                let annotation = MKPointAnnotation()
                annotation.coordinate.latitude = pin.lat
                annotation.coordinate.longitude = pin.lon
                pinArray.append(annotation)
            }
            mapView.addAnnotations(pinArray)
        }
    }
    
    @objc func handleTap(gestureRegonizer: UILongPressGestureRecognizer){
        if gestureRegonizer.state == .began{
            let location = gestureRegonizer.location(in: mapView)
            let coordination = mapView.convert(location, toCoordinateFrom: mapView)
            let annotation = MKPointAnnotation()
            addPin(lat: coordination.latitude, lon: coordination.longitude)
            annotation.coordinate = coordination
            mapView.addAnnotation(annotation)
        }
    }
    
    func setupFetchedResultsController(){
        let fetchRequest: NSFetchRequest<Pin> = Pin.fetchRequest()
        fetchRequest.sortDescriptors = []
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: appDelegate.dataController.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        do{
            try fetchedResultsController.performFetch()
        }
        catch{
            print("There was a problem with fetching: \(error.localizedDescription)")
        }
        
        if let result = try? appDelegate.dataController.viewContext.fetch(fetchRequest){
            annotations = result
        }
        
    }
    
    @IBAction func deletePin(_ sender: Any) {
        setupFetchedResultsController()
        for pin in annotations {
            if pin.lat == selectedPin?.coordinate.latitude &&
                pin.lon == selectedPin?.coordinate.longitude {
                            mapView.removeAnnotation(selectedPin as! MKAnnotation)
                appDelegate.dataController.viewContext.delete(pin as! NSManagedObject)
                
                try? appDelegate.dataController.viewContext.save()
                        }
                    }
        
        
    }
    
    func addPin(lat: Double, lon: Double){
        let pin = Pin(context: appDelegate.dataController.viewContext)
        let Weather = WeatherData(context: appDelegate.dataController.viewContext)
        CurrentWeatherClient.getCurrentWeather(lat: lat, lon: lon){
            response, error in
            if error != nil{
                print(error)
            } else{
                DataModel.weatherData = (response.self)
                Weather.name = response?.name
                Weather.descriptionOfWeather = response?.weather[0].description
                Weather.groundLevel = response?.main?.groundLevel ?? 0
                Weather.tempMax = response?.main?.tempMax ?? 0
                Weather.tempMin = response?.main?.tempMin ?? 0
                Weather.tempNow = response?.main?.temp ?? 0
                Weather.pin = pin
                pin.weather = Weather
                pin.lat = lat
                pin.date = Date()
                pin.lon = lon
                DataModelPins.pins.append(pin)
                try? self.appDelegate.dataController.viewContext.save()
            }
        }
        setupFetchedResultsController()
    }
}


extension MapViewController{
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        deleteButton.isHidden = false
        selectedPin = view.annotation
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        deleteButton.isHidden = true
    }
}

