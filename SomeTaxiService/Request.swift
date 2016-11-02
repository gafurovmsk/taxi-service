//
//  Request.swift
//  SomeTaxiService
//
//  Created by Nik on 01.11.16.
//  Copyright © 2016 Gafurov. All rights reserved.
//

import UIKit

class Request: NSObject {

    var requestNumber: String?
    var name: String?
    var createdAt: String?
    var requestID: String?
    var details: Details?
}

class Details {
    var statusText: String?  // в первых запросах обознач. как status
    var fullName: String?
    var description: String?
    var solutionDescription: String? // возможность редактирования
    var createdAt: String?
    var actualRecoveryTime: String?

}