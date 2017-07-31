//
//  ContactsTableVC.swift
//  Contacts App
//
//  Created by The Guest Family on 7/27/17.
//  Copyright © 2017 AlphaApplications. All rights reserved.
//

import UIKit
import CoreData

class ContactsTableVC: UITableViewController, UISearchBarDelegate, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var persons = [Person]()
    var filteredContacts = [Person]()
    var fetchedResultsController: NSFetchedResultsController<Person>!
    let transitionManager = TransitionManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        self.tableView.backgroundColor = UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1.0)
        
        fetch()
        attemptFetch()
        addNavBarImage()
        self.tableView.reloadData()
    }
    
    // Some setup for navigation bar
    func addNavBarImage() {
        let navController = navigationController
        
        let image = #imageLiteral(resourceName: "CoolContacts")
        let imageView = UIImageView(image: image)
        
        let bannerWidth = (navController?.navigationBar.frame.width)! / 2
        let bannerHeight = (navController?.navigationBar.frame.height)! / 2
        
        let bannerX = bannerWidth / 2 - image.size.width / 2
        let bannerY = bannerHeight / 2 - image.size.height / 2
        
        imageView.frame = CGRect(x: bannerX, y: bannerY, width: bannerWidth, height: bannerHeight)
        imageView.contentMode = .scaleAspectFit
        
        navigationItem.titleView = imageView
    }
    
    // For convenience, saves on writing same code over and over again
    func getContext () -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    // MARK: - Searchbar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterContentForSearchText(searchText: searchBar.text!)
    }
    
    func filterContentForSearchText(searchText:String, scope:String="All"){
        filteredContacts = persons.filter{
            person in
            return person.firstName.lowercased().contains(searchText.lowercased())
        }
        tableView.reloadData()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }

    // MARK: - Fetchresults controller / filtering data
    func attemptFetch(){
        let fetchRequest : NSFetchRequest<Person> = Person.fetchRequest() as! NSFetchRequest<Person>
        let nameSort = NSSortDescriptor(key: "firstName", ascending: false)
        fetchRequest.sortDescriptors = [nameSort]
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: getContext(), sectionNameKeyPath: nil, cacheName: nil)
        
        controller.delegate = self
        self.fetchedResultsController = controller //notifies for changes in data to the views
        
        do{
            try controller.performFetch()
        }
        catch{
            let error = error as NSError
            print("\(error)")
        }
        //fetches items from core data adds all core data  to the array monsters
        do{
            let fetchedContacts = try getContext().fetch(fetchRequest as! NSFetchRequest<NSFetchRequestResult>) as! [Person]
            self.persons = fetchedContacts
        }
        catch{
            let error = error as NSError
            print("\(error)")
        }
    }
    
    // MARK: - Data Source
    func fetch() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:"Contact")
        do {
            persons = try getContext().fetch(fetchRequest) as! [Person]
        } catch let error as NSError {
            print("Could not fetch. \(error)")
        }
    }
    
    func save(firstName: String, lastName: String, dob: String, phoneNumber: String, zipCode: String) {

        guard let entity = NSEntityDescription.entity(forEntityName:"Contact", in: getContext()) else { return }
        let person = NSManagedObject(entity: entity, insertInto: getContext())
        person.setValue(firstName, forKey: "firstName")
        person.setValue(lastName, forKey: "lastName")
        person.setValue(dob, forKey: "dateOfBirth")
        person.setValue(phoneNumber, forKey: "phoneNumber")
        person.setValue(zipCode, forKey: "zipCode")
        do {
            try getContext().save()
            self.persons.append(person as! Person) //previously just contact, no casting!
        } catch let error as NSError {
            print("Couldn't save. \(error)")
        }
    }
    
    func update(indexPath: IndexPath, firstName: String, lastName: String, dob: String, phoneNumber: String, zipCode: String) {

        let contact = persons[indexPath.row]
        contact.setValue(firstName, forKey: "firstName")
        contact.setValue(lastName, forKey: "lastName")
        contact.setValue(dob, forKey: "dateOfBirth")
        contact.setValue(phoneNumber, forKey: "phoneNumber")
        contact.setValue(zipCode, forKey: "zipCode")
        do {
            try getContext().save()
            persons[indexPath.row] = contact
        } catch let error as NSError {
            print("Couldn't update. \(error)")
        }
    }

    func delete(_ contact: NSManagedObject, at indexPath: IndexPath) {
        
        getContext().delete(contact)
        persons.remove(at: indexPath.row)
        
        //Always remember to save after deleting, updates Core Data
        do {
            try getContext().save()
        } catch {
            print("Something went wrong \(error.localizedDescription)")
        }
    }
    
    // MARK: - Table View Setup
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        //create a lable size to fit the Table View
        let messageLbl = UILabel(frame: CGRect(x: 0, y: 0,
                                               width: self.tableView.bounds.size.width,
                                               height: self.tableView.bounds.size.height))
        //center the text
        messageLbl.textAlignment = NSTextAlignment.center
        //auto size the text
        messageLbl.sizeToFit()
        //set back to label view
        self.tableView.backgroundView = messageLbl
        self.tableView.separatorStyle = .none
        
        if (persons.count == 0) {
            messageLbl.text = "No data is available"
        } else {
            messageLbl.text = ""
        }
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if searchBar.becomeFirstResponder() && searchBar.text != ""{
            return filteredContacts.count
        }
        return persons.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath) as? PersonsCell
        
        configureCell(cell:cell!,indexPath:indexPath as NSIndexPath)
        
        return cell!
    }
    
    func configureCell(cell:PersonsCell, indexPath:NSIndexPath){
        
        if searchBar.becomeFirstResponder() && searchBar.text != ""{
            let persons = filteredContacts[indexPath.row]
            cell.updateUI(person: persons)
        }
        else {
            let person = persons[indexPath.row]
            cell.updateUI(person: person)
        }
        
        
    }
 
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
 
    //Added to create a neat little slide in animation for each tablecell coming into view
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let originalFrameCell: CGRect = self.tableView.rectForRow(at: indexPath)
        //cell frame equals 0 - size of originalFameCell, this puts it offscreen to slide in
        cell.frame = CGRect(x: 0 - originalFrameCell.size.width,
                            y: originalFrameCell.origin.y,
                            width: originalFrameCell.size.width,
                            height: originalFrameCell.size.height)
        
        UIView.animate(withDuration: 0.65, delay: 0.15, usingSpringWithDamping: 1.0, initialSpringVelocity: 3.0, options: .curveLinear, animations: {
            cell.frame = originalFrameCell
        }) { _ in
            
        }
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            delete(persons[indexPath.row], at: indexPath)
            print("Deleting cell")
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
        }    
    }

    // MARK: - Navigation
    @IBAction func unwindToContactsList(segue:UIStoryboardSegue) {
        if let viewController = segue.source as? AddContactVC {
            guard let _firstName: String = viewController.firstNameLbl.text,
                let _lastName: String = viewController.lastNameLbl.text,
                let _dob: String = viewController.dateOfBirthLbl.text,
                let _phoneNumber: String = viewController.phoneNumberLbl.text,
                let _zipCode: String = viewController.zipCodeLbl.text
                else { return }
            if _firstName != "" && _lastName != "" && _dob != "" && _phoneNumber != "" && _zipCode != "" {
                if let indexPath = viewController.indexPathForContact {
                    viewController.transitioningDelegate = self.transitionManager
                    update(indexPath: indexPath, firstName: _firstName, lastName: _lastName, dob: _dob, phoneNumber: _phoneNumber, zipCode: _zipCode)
                    print("Any updates?")
                } else {
                    viewController.transitioningDelegate = self.transitionManager
                    save(firstName: _firstName, lastName: _lastName, dob: _dob, phoneNumber: _phoneNumber, zipCode: _zipCode)
                    print("added to tableview")
                }
            }
            tableView.reloadData()
        }
    }
    
    @IBAction func unwindFromUpdatingContact(segue:UIStoryboardSegue) {
        if let viewController = segue.source as? EditContactVC {
            guard let _firstName: String = viewController.firstNameLbl.text,
                let _lastName: String = viewController.lastNameLbl.text,
                let _dob: String = viewController.dateOfBirthLbl.text,
                let _phoneNumber: String = viewController.phoneNumberLbl.text,
                let _zipCode: String = viewController.zipCodeLbl.text
                else { return }
            if _firstName != "" && _lastName != "" && _dob != "" && _phoneNumber != "" && _zipCode != "" {
                if let indexPath = viewController.indexPath {
                    viewController.transitioningDelegate = self.transitionManager
                    update(indexPath: indexPath, firstName: _firstName, lastName: _lastName, dob: _dob, phoneNumber: _phoneNumber, zipCode: _zipCode)
                    print("Any updates?")
                }
            }
            tableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editContactSegue" {
            guard let navViewController = segue.destination as? UINavigationController else { return }
            guard let viewController = navViewController.topViewController as? EditContactVC else { return }
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let person = persons[indexPath.row]
            viewController.transitioningDelegate = self.transitionManager
            viewController.contact = person
            viewController.indexPath = indexPath
        }
    }
}

