//
//  StudentsData.swift
//  OnTheMap
//
//  Created by Marco Guevara on 1/07/23.
//

import Foundation

class StudentsData: NSObject {

    var students = [StudentInformation]()

    class func sharedInstance() -> StudentsData {
        struct Singleton {
            static var sharedInstance = StudentsData()
        }
        return Singleton.sharedInstance
    }

}
