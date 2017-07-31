//
//  EditContactVC.swift
//  Contacts App
//
//  Created by The Guest Family on 7/27/17.
//  Copyright © 2017 AlphaApplications. All rights reserved.
//

import UIKit
import CoreData

class EditContactVC: UIViewController {
    
    @IBOutlet weak var firstNameLbl: UITextField!
    @IBOutlet weak var lastNameLbl: UITextField!
    @IBOutlet weak var dateOfBirthLbl: UITextField!
    @IBOutlet weak var phoneNumberLbl: UITextField!
    @IBOutlet weak var zipCodeLbl: UITextField!
    
    var contact: Person? = nil
    var indexPath: IndexPath? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstNameLbl.text = contact?.value(forKey: "firstName") as? String
        lastNameLbl.text = contact?.value(forKey: "lastName") as? String
        dateOfBirthLbl.text = contact?.value(forKey: "dateOfBirth") as? String
        phoneNumberLbl.text = contact?.value(forKey: "phoneNumber") as? String
        zipCodeLbl.text = contact?.value(forKey: "zipCode") as? String
    }
    
    func datePickerValueChanged(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        dateOfBirthLbl.text = dateFormatter.string(from: sender.date)
    }
    
    //Function above and this IBAction allow user to pick date of birth
    @IBAction func dateFieldEditing(_ sender: UITextField) {
        let datePickerView: UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.date
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(datePickerValueChanged), for: UIControlEvents.valueChanged)
    }
    
    @IBAction func UpdateInfoBtn(_ sender: UIButton) {
        if (firstNameLbl.text == "" || lastNameLbl.text == "" || dateOfBirthLbl.text == "" || phoneNumberLbl.text == "" || zipCodeLbl.text == "" || firstNameLbl.text == "") {
            let alertController = UIAlertController(title: "Warning", message:
                "You must fill out all fields", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel,handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
        } else {
            performSegue(withIdentifier: "unwindFromUpdatingContact", sender: self)
        }
    }
    
    @IBAction func doneBtn(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
}

