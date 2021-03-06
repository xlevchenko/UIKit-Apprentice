//
//  ListDetailViewController.swift
//  Checklists
//
//  Created by Olexsii Levchenko on 7/19/22.
//

import UIKit

protocol ListDetailViewControllerDelegate: AnyObject {
    func listDetailViewControllerDidCancel(_ controller: ListDetailViewController)
    func listDetailViewController(_ controller: ListDetailViewController, didFinishAditing checklist: Checklist)
    func listDetailViewController(_ controller: ListDetailViewController, didFinishEditing checklist: Checklist)
}


class ListDetailViewController: UITableViewController {

    @IBOutlet var textField: UITextField!
    @IBOutlet var doneBarButton: UIBarButtonItem!
    @IBOutlet weak var iconImage: UIImageView!
    
    weak var delegate: ListDetailViewControllerDelegate?
    var checklistToEdit: Checklist?
    
    var iconName = "Folder"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let checklistToEdit = checklistToEdit {
            title = checklistToEdit.name
            doneBarButton.isEnabled = true
            iconName = checklistToEdit.iconName
        }
        iconImage.image = UIImage(named: iconName)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
    }

    
    @IBAction func cancelButton() {
        delegate?.listDetailViewControllerDidCancel(self)
    }
    
    @IBAction func doneButton() {
        if let checklistToEdit = checklistToEdit {
            checklistToEdit.name = textField.text!
            checklistToEdit.iconName = iconName
            delegate?.listDetailViewController(self, didFinishEditing: checklistToEdit)
        } else {
            let checklist = Checklist(name: textField.text!, iconName: iconName)
            checklist.iconName = iconName
            delegate?.listDetailViewController(self, didFinishAditing: checklist)
        }
    }
    
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return indexPath.section == 1 ? indexPath : nil
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PickIcon" {
            let controller = segue.destination as! IconPickerViewController
            controller.delegate = self
        }
    }
}


extension ListDetailViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldText = textField.text!
        let stringRange = Range(range, in: oldText)!
        let newText = oldText.replacingCharacters(in: stringRange, with: string)
        doneBarButton.isEnabled = !newText.isEmpty
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        doneBarButton.isEnabled = false
        return true
    }
}


// MARK: - Icon Picker View Controller Delegate
extension ListDetailViewController: IconPickerViewControllerDeleget {
    func iconPicker(_ picker: IconPickerViewController, didPicker iconName: String) {
        self.iconName = iconName
        iconImage.image = UIImage(named: iconName)
        navigationController?.popViewController(animated: true)
    }
}
