//
//  Endpoints.swift
//  OnTheMap
//
//  Created by Marco Guevara on 1/07/23.
//

import Foundation

enum Endpoints {
    
    static let base = "https://onthemap-api.udacity.com/v1"
    
    case udacitySignUp
    case udacityLogin
    case getStudentLocations
    case addLocation
    case updateLocation
    case getLoggedInUserProfile
    
    var stringValue: String {
        switch self {
        case .udacitySignUp:
            return "https://auth.udacity.com/sign-up"
        case .udacityLogin:
            return Endpoints.base + "/session"
        case .getStudentLocations:
            return Endpoints.base + "/StudentLocation?limit=100&order=-updatedAt"
        case .addLocation:
            return Endpoints.base + "/StudentLocation"
        case .updateLocation:
            return Endpoints.base + "/StudentLocation/" + Auth.objectId
        case .getLoggedInUserProfile:
            return Endpoints.base + "/users/" + Auth.key
        }
    }
    
    var url: URL {
        return URL(string: stringValue)!
    }
}
