//
//  LoginResponse.swift
//  OnTheMap
//
//  Created by Marco Guevara on 1/07/23.
//

import Foundation

struct LoginResponse: Codable {
    let account: Account
    let session: Session
}
