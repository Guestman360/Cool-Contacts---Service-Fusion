//
//  ViewController.swift
//  Contacts App
//
//  Created by The Guest Family on 7/27/17.
//  Copyright © 2017 AlphaApplications. All rights reserved.
//

import UIKit
import CoreData
import Foundation

class AddContactVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var firstNameLbl: UITextField!
    @IBOutlet weak var lastNameLbl: UITextField!
    @IBOutlet weak var dateOfBirthLbl: UITextField!
    @IBOutlet weak var phoneNumberLbl: UITextField!
    @IBOutlet weak var zipCodeLbl: UITextField!
    
    var contact: Person? = nil 
    var indexPathForContact: IndexPath? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
        phoneNumberLbl.delegate = self
        
        if let contact = self.contact {
            firstNameLbl.text = contact.value(forKey: "firstName") as? String
            lastNameLbl.text = contact.value(forKey: "lastName") as? String
            dateOfBirthLbl.text = contact.value(forKey: "dateOfBirth") as? String
            phoneNumberLbl.text = contact.value(forKey: "phoneNumber") as? String
            zipCodeLbl.text = contact.value(forKey: "zipCode") as? String
        }
    }
    
    //Formats the date to have a short style
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
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
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
                
                textField.text = prefix + "-" + postfix + "-"
                
                if range.length > 0{
                    textField.text = prefix + postfix
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
    
    @IBAction func AddInfoBtn(_ sender: Any) {
        if (firstNameLbl.text == "" || lastNameLbl.text == "" || dateOfBirthLbl.text == "" || phoneNumberLbl.text == "" || zipCodeLbl.text == "" || firstNameLbl.text == "") {
            let alertController = UIAlertController(title: "Warning", message:
                "You must fill out all fields", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel,handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
        } else {
            performSegue(withIdentifier: "unwindToContactsList", sender: self)
        }
    }
    
    @IBAction func CloseBtn(_ sender: Any) {
        firstNameLbl.text = nil
        lastNameLbl.text = nil
        dateOfBirthLbl.text = nil
        phoneNumberLbl.text = nil
        zipCodeLbl.text = nil
        
        performSegue(withIdentifier: "unwindToContactsList", sender: self)
    }

}

extension Date {
    func toString( dateFormat format  : String ) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
}

extension String.CharacterView {
    /// This method makes it easier extract a substring by character index where a character is viewed as a human-readable character.
    internal func substring(start: Int, offsetBy: Int) -> String? {
        guard let substringStartIndex = self.index(startIndex, offsetBy: start, limitedBy: endIndex) else {
            return nil
        }
        
        guard let substringEndIndex = self.index(startIndex, offsetBy: start + offsetBy, limitedBy: endIndex) else {
            return nil
        }
        
        return String(self[substringStartIndex ..< substringEndIndex])
    }
}

