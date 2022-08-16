//
//  LocationDetailsViewController.swift
//  MyLocations
//
//  Created by Olexsii Levchenko on 8/3/22.
//

import UIKit
import CoreLocation
import CoreData

class LocationDetailsViewController: UITableViewController {
    
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var addPhotoLabel: UILabel!
    @IBOutlet var imageHeight: NSLayoutConstraint!
    var image: UIImage?
    
    var cordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    var placemark: CLPlacemark?
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
    
    var categoryName = "No Category"
    
    var managedObjectContext: NSManagedObjectContext!
    var date = Date()
    
    var locationToEdit: Location? {
        didSet {
            if let location = locationToEdit {
                descriptionText = location.locationDescription
                categoryName = location.category
                date = location.date
                cordinate = CLLocationCoordinate2D(
                    latitude: location.latitude,
                    longitude: location.longitude)
                placemark = location.placemark
            }
        }
    }
    
    var descriptionText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let location = locationToEdit {
            title = "Edit Location"
        }
        
        descriptionTextView.text = descriptionText
        categoryLabel.text = ""
        
        latitudeLabel.text = String(format: "%.8f", cordinate.latitude)
        longitudeLabel.text = String(format: "%.8f", cordinate.longitude)
        
        if let placemark = placemark {
            addressLabel.text = string(from: placemark)
        } else {
            addressLabel.text = "No Address Found"
        }
        
        dateLabel.text = format(date: date)
        
        categoryLabel.text = categoryName
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        gestureRecognizer.cancelsTouchesInView = false
        tableView.addGestureRecognizer(gestureRecognizer)
        
        listenForBackgroundNotification()
    }
    
    
    @objc func hideKeyboard(_ gestureRecognizer: UITapGestureRecognizer) {
        let point = gestureRecognizer.location(in: tableView)
        let indexPath = tableView.indexPathForRow(at: point)
        
        if indexPath == nil || !(indexPath!.section == 0 && indexPath!.row == 0) {
            descriptionTextView.resignFirstResponder()
        }
    }
    
    
    @IBAction func cancel(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func done(_ sender: Any) {
        guard let mainView = navigationController?.parent?.view else { return }
        
        let hubView = HudView.hub(inView: mainView, animated: true)
        hubView.text = "Tagged"
        
        let location: Location
        
        if let temp = locationToEdit {
            hubView.text = "Updated"
            location = temp
        } else {
            hubView.text = "Tagged"
            location = Location(context: managedObjectContext)
        }
        
        location.locationDescription = descriptionTextView.text
        location.category = categoryName
        location.latitude = cordinate.latitude
        location.longitude = cordinate.longitude
        location.date = date
        location.placemark = placemark
        
        do {
            try managedObjectContext.save()
            afterDelay(0.6) {
                hubView.hide()
                self.navigationController?.popViewController(animated: true)
            }
            
        } catch {
            fatalCoreDataError(error)
        }
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
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PickCategory" {
           let controller = segue.destination as! CategoryPickerViewController
            controller.selectedCategoryName = categoryName
        }
    }
    
    @IBAction func categoryPickerDidPickerCategory(_ segue: UIStoryboardSegue) {
        let controller = segue.source as! CategoryPickerViewController
        categoryName = controller.selectedCategoryName
        categoryLabel.text = categoryName
    }
    
    
    //MARK: - Table View Controller
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath.section == 0 || indexPath.section == 1 {
            return indexPath
        } else {
            return nil
        }
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == 0 {
            descriptionTextView.becomeFirstResponder()
        } else if indexPath.section == 1 && indexPath.row == 0 {
            tableView.deselectRow(at: indexPath, animated: true)
            pickPhoto()
        }
    }
    
    func show(image: UIImage) {
        imageView.image = image
        imageView.isHidden = false
        addPhotoLabel.text = ""
        imageHeight.constant = 260
        tableView.reloadData()
    }
    
    
    func listenForBackgroundNotification() {
        NotificationCenter.default.addObserver(
            forName: UIScene.didEnterBackgroundNotification,
            object: nil,
            queue: OperationQueue.main) { _ in
                if self.presentedViewController != nil {
                    self.dismiss(animated: false)
                }
                self.descriptionTextView.resignFirstResponder()
            }
    }
}


extension LocationDetailsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
   //MARK: - Image Halper Methods
    
    func takePhotoWithCamera() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true)
    }
    
    
    func choosePhotoFromLibrary() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        if let theImage = image {
            show(image: theImage)
        }
        
        dismiss(animated: true)
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
    
    
    func pickPhoto() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            showPhotoMenu()
        } else {
            choosePhotoFromLibrary()
        }
    }
    
    
    func showPhotoMenu() {
        let alert = UIAlertController(
            title: nil,
            message: nil,
            preferredStyle: .actionSheet)
        
        let actCancel = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(actCancel)
        
        let actPhoto = UIAlertAction(title: "Take Photo", style: .default) { _ in
            self.takePhotoWithCamera()
        }
        alert.addAction(actPhoto)
        
        let actLibrary = UIAlertAction(title: "Chose From Library", style: .default) { _ in
            self.choosePhotoFromLibrary()
        }
        alert.addAction(actLibrary)
        
        present(alert, animated: true)
    }
}
