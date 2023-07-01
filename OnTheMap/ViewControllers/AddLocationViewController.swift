//
//  AddLocationViewController.swift
//  OnTheMap
//
//  Created by Marco Guevara on 1/07/23.
//

import UIKit
import MapKit

class AddLocationViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var locationTextField: UITextField!
    
    @IBOutlet weak var websiteTextField: UITextField!
    
    @IBOutlet weak var findLocationButton: UIButton!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var objectId: String?
    
    var locationTextFieldIsEmpty = true
    var websiteTextFieldIsEmpty = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        locationTextField.delegate = self
        websiteTextField.delegate = self
        activityIndicator.isHidden = true
    }
    
    @IBAction func findLocation(_ sender: UIButton) {
        self.setLoading(true)
        let newLocation = locationTextField.text
        
        guard let url = URL(string: self.websiteTextField.text!), UIApplication.shared.canOpenURL(url) else {
            self.showAlert(message: "Please include 'https://' in your link.", title: "Invalid URL")
            setLoading(false)
            return
        }

        geocodePosition(newLocation: newLocation ?? "")
    }
    
    @IBAction func cancelAction(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func geocodePosition(newLocation: String) {
        CLGeocoder().geocodeAddressString(newLocation) { (newMarker, error) in
            if let error = error {
                self.showAlert(message: error.localizedDescription, title: "Location Not Found")
                self.setLoading(false)
                debugPrint("Location not found")
            } else {
                self.setLoading(false)
                var location: CLLocation?
                
                if let marker = newMarker, marker.count > 0 {
                    location = marker.first?.location
                }
                
                if let location = location {
                    self.loadNewLocation(location.coordinate)
                } else {
                    self.showAlert(message: "Load location error. Please try again later.", title: "Error")
                    self.setLoading(false)
                    debugPrint("Load location error")
                }
            }
        }
    }
    
    private func loadNewLocation(_ coordinate: CLLocationCoordinate2D) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "FinishAddLocationViewController") as! FinishAddLocationViewController
        controller.studentInformation = buildStudentInfo(coordinate)
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    private func buildStudentInfo(_ coordinate: CLLocationCoordinate2D) -> StudentInformation {
        
        var studentInfo = [
            "uniqueKey": Auth.key,
            "firstName": Auth.firstName,
            "lastName": Auth.lastName,
            "mapString": locationTextField.text!,
            "mediaURL": websiteTextField.text!,
            "latitude": coordinate.latitude,
            "longitude": coordinate.longitude,
            ] as [String: AnyObject]
        
        if let objectId = objectId {
            studentInfo["objectId"] = objectId as AnyObject
            print(objectId)
        }

        return StudentInformation(studentInfo)

    }
    
    // MARK: Loading state
    
    func setLoading(_ loading: Bool) {
        if loading {
            DispatchQueue.main.async {
                self.activityIndicator.isHidden = false
                self.activityIndicator.startAnimating()
                self.findLocationButton.isEnabled = false
                self.locationTextField.isEnabled = false
                self.websiteTextField.isEnabled = false
            }
        } else {
            DispatchQueue.main.async {
                self.activityIndicator.isHidden = true
                self.activityIndicator.stopAnimating()
                self.findLocationButton.isEnabled = true
                self.locationTextField.isEnabled = true
                self.websiteTextField.isEnabled = true
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == locationTextField {
            let currenText = locationTextField.text ?? ""
            guard let stringRange = Range(range, in: currenText) else { return false }
            let updatedText = currenText.replacingCharacters(in: stringRange, with: string)
            
            if updatedText.isEmpty && updatedText == "" {
                locationTextFieldIsEmpty = true
            } else {
                locationTextFieldIsEmpty = false
            }
        }
        
        if textField == websiteTextField {
            let currenText = websiteTextField.text ?? ""
            guard let stringRange = Range(range, in: currenText) else { return false }
            let updatedText = currenText.replacingCharacters(in: stringRange, with: string)
            
            if updatedText.isEmpty && updatedText == "" {
                websiteTextFieldIsEmpty = true
            } else {
                websiteTextFieldIsEmpty = false
            }
        }
        
        
        return true
        
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {

        if textField == locationTextField {
            locationTextFieldIsEmpty = true
        }
        if textField == websiteTextField {
            websiteTextFieldIsEmpty = true
        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
            findLocation(findLocationButton)
            
        }
        return true
    }

}
