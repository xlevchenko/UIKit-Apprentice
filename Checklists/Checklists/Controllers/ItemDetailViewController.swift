//
//  ItemDetailViewController.swift
//  Checklists
//
//  Created by Olexsii Levchenko on 7/7/22.
//

import UIKit

protocol ItemDetailViewControllerDelegate: AnyObject {
    func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController)
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishAdding item: ChecklistItem)
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishEditing item: ChecklistItem)
}

class ItemDetailViewController: UITableViewController, UITextFieldDelegate {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    @IBOutlet weak var shouldRemindSwith: UISwitch!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    weak var delegate: ItemDetailViewControllerDelegate?
    
    var itemToEdit: ChecklistItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.delegate = self
        
        if let itemToEdit = itemToEdit {
            title = "Edit Item"
            textField.text = itemToEdit.text
            doneBarButton.isEnabled = true
            
            shouldRemindSwith.isOn = itemToEdit.shouldRemind
            datePicker.date = itemToEdit.dueDate
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        delegate?.itemDetailViewControllerDidCancel(self)
    }
    
    
    @IBAction func doneButton(_ sender: Any) {
        if let itemToEdit = itemToEdit {
            itemToEdit.text = textField.text!
            
            itemToEdit.shouldRemind = shouldRemindSwith.isOn
            itemToEdit.dueDate = datePicker.date
            itemToEdit.scheduleNotification()
            
            delegate?.itemDetailViewController(self, didFinishEditing: itemToEdit)
        } else  {
            let item = ChecklistItem()
            item.text = textField.text!
            item.checked = false
            
            item.shouldRemind = shouldRemindSwith.isOn
            item.dueDate = datePicker.date
            item.scheduleNotification()
            
            delegate?.itemDetailViewController(self, didFinishAdding: item)
        }
    }
    
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    
    
    //MARK: - UITextFieldDelegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldText = textField.text!
        let startingRange = Range(range, in: oldText)!
        let newText = oldText.replacingCharacters(in: startingRange, with: string)
        if newText.isEmpty {
            doneBarButton.isEnabled = false
        } else {
            doneBarButton.isEnabled = true
        }
        return true
    }
    
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
      doneBarButton.isEnabled = false
      return true
    }
    
    @IBAction func shouldRemindToggled(_ sender: UISwitch) {
        textField.resignFirstResponder()
        
        if sender.isOn {
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.alert, .sound]) { _, _ in
                //do nothing
            }
        }
    }
}
