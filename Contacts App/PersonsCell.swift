//
//  PersonsCell.swift
//  Contacts App
//
//  Created by The Guest Family on 7/27/17.
//  Copyright © 2017 AlphaApplications. All rights reserved.
//

import UIKit

class PersonsCell: UITableViewCell {
    
    @IBOutlet weak var firstName: UILabel!
    @IBOutlet weak var lastName: UILabel!
    @IBOutlet weak var phoneNumber: UILabel!
    @IBOutlet weak var dob: UILabel!
    @IBOutlet weak var zipCode: UILabel!
    @IBOutlet weak var cardView: UIView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        cardSetUp()
    }
    
    //Set up the design of the cardview
    func cardSetUp() {
        cardView.backgroundColor = UIColor.white
        contentView.backgroundColor = UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1.0)
        contentView.translatesAutoresizingMaskIntoConstraints = true
        
        cardView.layer.cornerRadius = 5.0
        cardView.layer.masksToBounds = false
        cardView.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
        cardView.layer.shadowOffset = CGSize(width: 0, height: 0)
        cardView.layer.shadowOpacity = 0.8
    }
    
    func updateUI(person:Person){
        
        firstName?.text = person.value(forKey:"firstName") as? String
        lastName?.text = person.value(forKey:"lastName") as? String
        dob?.text = person.value(forKey:"dateOfBirth") as? String
        phoneNumber?.text = person.value(forKey:"phoneNumber") as? String
        zipCode?.text = person.value(forKey:"zipCode") as? String
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
