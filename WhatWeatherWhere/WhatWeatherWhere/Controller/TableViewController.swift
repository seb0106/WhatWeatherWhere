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
    let searchController = UISearchController(searchResultsController: nil)
    var filteredPins: [Pin] = []
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.searchController = self.searchController
        tableView.rowHeight = UITableView.automaticDimension
        setupFetchedResultsControllerPin()
        setupFetchedResultsControllerWeatherData()
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search Dates"
        annotations = fetchedResultsController.fetchedObjects ?? DataModelPins.pins
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
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
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
  

}

extension TableViewController: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
            if let searchText = searchController.searchBar.text, !searchText.isEmpty {
                if let data = fetchedResultsController.fetchedObjects{
                    data.filter{ (pin) in
                       return (pin.weather?.name?.contains(searchText) ?? true)
                    }
                }
            }
            self.tableView.reloadData()
      }
       
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.fetchedObjects?.count ?? DataModelPins.pins.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        setupFetchedResultsControllerWeatherData()
        let dateFormatter = DateFormatter()
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! CustomTableCell
        /*if let data = fetchedResultsController.fetchedObjects{
            dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
            cell.locationLabel?.text = data[indexPath.item].weather?.name
            cell.dateLabel?.text = dateFormatter.string(from: data[indexPath.item].date ?? Date())
        }*/
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        cell.locationLabel?.text = annotations[indexPath.item].weather?.name
        cell.dateLabel?.text = dateFormatter.string(from: annotations[indexPath.item].date ?? Date())
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.item
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "id") as! WeatherDetailViewController
        if let data = fetchedResultsController.fetchedObjects{
            vc.weather = data[selectedIndex].weather
            tableView.deselectRow(at: indexPath, animated: true)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
         //   appDelegate.dataController.viewContext.delete(annotations[indexPath.item] as! NSManagedObject)
            print("Delete", annotations[indexPath.row])
            annotations.remove(at: indexPath.row)
         //   try? appDelegate.dataController.viewContext.save()
            self.tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
}
