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
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        descriptionTextView.text = ""
        categoryLabel.text = ""
        
        latitudeLabel.text = String(format: "%.8f", cordinate.latitude)
        longitudeLabel.text = String(format: "%.8f", cordinate.longitude)
        
        if let placemark = placemark {
            addressLabel.text = string(from: placemark)
        } else {
            addressLabel.text = "No Address Found"
        }
        
        dateLabel.text = format(date: Date())
    }
    
    
    @IBAction func cancel(_ sender: Any) {
        
    }
    
    
    @IBAction func done(_ sender: Any) {
        
    }
    
    
    // MARK: - Helper Methods
    func string(from placemark: CLPlacemark) -> String {
      var text = ""
      if let tmp = placemark.subThoroughfare {
        text += tmp + " "
      }
      if let tmp = placemark.thoroughfare {
        text += tmp + ", "
      }
      if let tmp = placemark.locality {
        text += tmp + ", "
      }
      if let tmp = placemark.administrativeArea {
        text += tmp + " "
      }
      if let tmp = placemark.postalCode {
        text += tmp + ", "
      }
      if let tmp = placemark.country {
        text += tmp
      }
      return text
    }
    
    func format(date: Date) -> String {
        return dateFormatter.string(from: date)
    }
}
