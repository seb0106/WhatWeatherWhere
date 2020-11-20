//*
// * Copyright (C) Schweizerische Bundesbahnen SBB, 2020.
//*

import Foundation
import CoreData
import UIKit

class TableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    
     var fetchedResultsController : NSFetchedResultsController<Pin>!
    var fetchedWeatherController: NSFetchedResultsController<WeatherData>!
    var annotations = [Pin]()
    var selectedIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableView.automaticDimension
        setupFetchedResultsControllerPin()
        setupFetchedResultsControllerWeatherData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupFetchedResultsControllerPin()
        tableView.reloadData()
    }
    
    func setupFetchedResultsControllerPin(){
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
    func setupFetchedResultsControllerWeatherData(){
        let fetchRequest: NSFetchRequest<WeatherData> = WeatherData.fetchRequest()
        fetchRequest.sortDescriptors = []
        fetchedWeatherController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: appDelegate.dataController.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedWeatherController.delegate = self
        do{
            try fetchedWeatherController.performFetch()
        }
        catch{
            print("There was a problem with fetching: \(error.localizedDescription)")
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            let vc = segue.destination as! WeatherDetailViewController
            if let data = fetchedResultsController.fetchedObjects{
                print("1st")
                vc.weather = data[selectedIndex].weather
                
            }
        }
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}

extension TableViewController{
       
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.fetchedObjects?.count ?? DataModelPins.pins.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        setupFetchedResultsControllerWeatherData()
        let dateFormatter = DateFormatter()
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! CustomTableCell
        if let data = fetchedResultsController.fetchedObjects{
            dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
            cell.locationLabel?.text = data[indexPath.item].weather?.name
            cell.dateLabel?.text = dateFormatter.string(from: data[indexPath.item].date ?? Date())
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.item
        print("2nd")
        performSegue(withIdentifier: "showDetail", sender: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
}
