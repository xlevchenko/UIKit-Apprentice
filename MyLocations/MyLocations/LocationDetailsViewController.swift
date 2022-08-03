//
//  LocationDetailsViewController.swift
//  MyLocations
//
//  Created by Olexsii Levchenko on 8/3/22.
//

import UIKit
import CoreLocation

class LocationDetailsViewController: UITableViewController {
    
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var cordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    var placemark: CLPlacemark?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    @IBAction func cancel(_ sender: Any) {
        
    }
    
    
    @IBAction func done(_ sender: Any) {
        
    }
}
