//
//  EditContactVC.swift
//  Contacts App
//
//  Created by The Guest Family on 7/27/17.
//  Copyright © 2017 AlphaApplications. All rights reserved.
//

import UIKit
import CoreData

class EditContactVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var firstNameLbl: UITextField!
    @IBOutlet weak var lastNameLbl: UITextField!
    @IBOutlet weak var dateOfBirthLbl: UITextField!
    @IBOutlet weak var phoneNumberLbl: UITextField!
    @IBOutlet weak var zipCodeLbl: UITextField!
    @IBOutlet weak var phoneWarningLbl: UILabel!
    @IBOutlet weak var zipWarningLbl: UILabel!
    
    var contact: Person? = nil
    var indexPath: IndexPath? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
        phoneWarningLbl.isHidden = true
        zipWarningLbl.isHidden = true
        
        phoneNumberLbl.delegate = self
        zipCodeLbl.delegate = self
        
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        //Formats the phone number in textfield
        if phoneNumberLbl.text != "" && (phoneNumberLbl.text?.characters.count)! < 13 {
            phoneWarningLbl.isHidden = false
            phoneNumberLbl.textColor = .red
            phoneWarningLbl.shake()
        } else {
            phoneWarningLbl.isHidden = true
            phoneNumberLbl.textColor = .black
        }
        
        if zipCodeLbl.text != "" && (zipCodeLbl.text?.characters.count)! < 4 {
            zipWarningLbl.isHidden = false
            zipCodeLbl.textColor = .red
            zipWarningLbl.shake()
        } else {
            zipWarningLbl.isHidden = true
            zipCodeLbl.textColor = .black
        }
        
        //Sets the proper limit and adds formatting to phone number
        if textField == phoneNumberLbl {
            let length: Int = getLength(textField.text!)
            if length == 10 {
                if range.length == 0 {
                    return false
                }
            }
            if length == 3 {
                let num: String = formatNumber(textField.text!)
                textField.text = num + "-"
                if range.length > 0 {
                    textField.text = (num as NSString).substring(to: 3)
                }
            }
            else if length == 6{
                let num : String = self.formatNumber(textField.text!)
                
                let prefix  = (num as NSString).substring(to: 3)
                let postfix = (num as NSString).substring(from: 3)
                
                textField.text = "(" + prefix + ")" + " " + postfix + "-" //prefix + "-" + postfix + "-"
                
                if range.length > 0{
                    textField.text = prefix + postfix
                }
            }
        }
        
        if textField == zipCodeLbl {
            let length: Int = getLength(textField.text!)
            if length == 5 {
                if range.length == 0 {
                    return false
                }
            }
        }
        return true
    }
    
    // Methods to help in formatting phone number
    func formatNumber(_ mobileNumber: String) -> String {
        var mobileNumber = mobileNumber.replacingOccurrences(of: "(", with: "")
        mobileNumber = mobileNumber.replacingOccurrences(of: ")", with: "")
        mobileNumber = mobileNumber.replacingOccurrences(of: " ", with: "")
        mobileNumber = mobileNumber.replacingOccurrences(of: "-", with: "")
        mobileNumber = mobileNumber.replacingOccurrences(of: "+", with: "")
        
        return mobileNumber
    }
    
    func getLength(_ mobileNumber: String) -> Int {
        var mobileNumber = mobileNumber.replacingOccurrences(of: "(", with: "")
        mobileNumber = mobileNumber.replacingOccurrences(of: ")", with: "")
        mobileNumber = mobileNumber.replacingOccurrences(of: " ", with: "")
        mobileNumber = mobileNumber.replacingOccurrences(of: "-", with: "")
        mobileNumber = mobileNumber.replacingOccurrences(of: "+", with: "")
        let length: Int = (mobileNumber.characters.count)
        return length
    }
    
    //Function above and this IBAction allow user to pick date of birth
    @IBAction func dateFieldEditing(_ sender: UITextField) {
        let datePickerView: UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.date
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(datePickerValueChanged), for: UIControlEvents.valueChanged)
    }
    
    @IBAction func UpdateInfoBtn(_ sender: UIButton) {
        if (firstNameLbl.text! == "" || lastNameLbl.text == "" || dateOfBirthLbl.text == "" || phoneNumberLbl.text == "" || zipCodeLbl.text == "" || firstNameLbl.text == "" && (phoneNumberLbl.text?.characters.count)! <= 10 && (zipCodeLbl.text?.characters.count)! <= 5) {
            
            let alertController = UIAlertController(title: "Warning", message:
                "You must fill out all fields appropriately", preferredStyle: UIAlertControllerStyle.alert)
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

