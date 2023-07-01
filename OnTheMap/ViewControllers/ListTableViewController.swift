//
//  ListTableViewController.swift
//  OnTheMap
//
//  Created by Marco Guevara on 1/07/23.
//

import UIKit

class ListTableViewController:  UITableViewController {
    
    @IBOutlet weak var studentTableView: UITableView!
    
    var myIndicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        
        
        super.viewDidLoad()

        myIndicator = UIActivityIndicatorView (style: .medium)
        self.view.addSubview(myIndicator)
        myIndicator.bringSubviewToFront(self.view)
        myIndicator.center = self.view.center
        showActivityIndicator()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        getStudentsList()
    }
    
    func getStudentsList() {
        showActivityIndicator()
        ApiClient.getStudentLocations() {students, error in
            StudentsData.sharedInstance().students = students ?? []
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.hideActivityIndicator()
            }
        }
    }
    
    @IBAction func reloadAction(_ sender: UIBarButtonItem) {
        getStudentsList()
    }
    
    @IBAction func logout(_ sender: UIBarButtonItem) {
        showActivityIndicator()
        ApiClient.logout {
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
                self.hideActivityIndicator()
            }
        }
    }
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {

        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return StudentsData.sharedInstance().students.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentTableViewCell", for: indexPath)
        let student = StudentsData.sharedInstance().students[indexPath.row]
        cell.textLabel?.text = "\(student.firstName)" + " " + "\(student.lastName)"
        cell.detailTextLabel?.text = "\(student.mediaURL ?? "")"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let student = StudentsData.sharedInstance().students[indexPath.row]
        openLink(student.mediaURL ?? "")
    }
    
    // MARK: Activity Indicator
    
    func showActivityIndicator() {
        myIndicator.isHidden = false
        myIndicator.startAnimating()
    }
    
    func hideActivityIndicator() {
        myIndicator.stopAnimating()
        myIndicator.isHidden = true
    }
}
