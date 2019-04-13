//
//  ViewController.swift
//  AutoCompletByMapKit
//
//  Created by PiyushVyas on 12/04/19.
//  Copyright © 2019 PiyushVyas. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {

    //More Info : https://github.com/gm6379/MapKitAutocomplete
    
    @IBOutlet weak var tblSearchResult: UITableView!
    
    var searchCompleter = MKLocalSearchCompleter()
    var searchResults = [MKLocalSearchCompletion]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tblSearchResult.separatorColor = UIColor.clear
        searchCompleter.delegate = self
    }


    @IBAction func txtSearchActivity(_ sender: UITextField) {
        //print("Value : \(sender.text ?? "NoValue")")
        //self.tblSearchResult.reloadData()
        
        searchCompleter.filterType = .locationsOnly
        searchCompleter.queryFragment = sender.text ?? ""
    }
}

extension ViewController: MKLocalSearchCompleterDelegate {
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
        self.tblSearchResult.reloadData()
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        // handle error
        print("Error : \(error.localizedDescription)")
    }
}
extension ViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.view.endEditing(true)
        return true
    }
}

extension ViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let searchResult = searchResults[indexPath.row]
        let strTitle = searchResult.title
        let strSubTitle = searchResult.subtitle
        
        cell.textLabel?.text = strTitle
        cell.detailTextLabel?.text = strSubTitle
        
        tableView.separatorColor = UIColor.lightGray
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let completion = searchResults[indexPath.row]
        
        let searchRequest = MKLocalSearch.Request(completion: completion)
        let search = MKLocalSearch(request: searchRequest)
        search.start { (response, error) in
            let coordinate = response?.mapItems[0].placemark.coordinate
            print(String(describing: coordinate))
        }
    }
}
