//
//  Job.swift
//  UnibuiAssignment
//
//  Created by admin on 9/16/24.
//

import Foundation

enum JobType: String {
    case software
    case data
    case writer
    case marketing
    case support
    case hr
    case other
}

let software = ["software", "internet", "network", "developer"]
let data = ["data", "analyst"]
let writer = ["writer"]
let marketing = ["marketing"]
let support = ["support"]
let hr = ["human", "hr"]

struct Job: Identifiable {
//    var id: String {
//        return "\(jobTitle) + \(companyName)"
//    }
    var id: Int
    let jobTitle: String
    let companyName: String
    let location: String
    let jobDescription: String
    let requirements: String
    
    // background image displayed based on job type
    var type: JobType {
        switch jobTitle {
        case software.first(where: {jobTitle.contains($0) == true}):
            return .software
        case data.first(where: {jobTitle.contains($0) == true}):
            return .data
        case writer.first(where: {jobTitle.contains($0) == true}):
            return .writer
        case marketing.first(where: {jobTitle.contains($0) == true}):
            return .marketing
        case support.first(where: {jobTitle.contains($0) == true}):
            return .support
        case hr.first(where: {jobTitle.contains($0) == true}):
            return .hr
        default:
            return .other
        }
    }
}
