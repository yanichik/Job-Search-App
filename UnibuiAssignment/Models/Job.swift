//
//  Job.swift
//  UnibuiAssignment
//
//  Created by Yan Brunshteyn on 9/16/24.
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
    var id: Int
    let jobTitle: String
    let companyName: String
    let location: String
    let jobDescription: String
    let requirements: String
    
    // background image displayed based on job type
    var type: JobType {
        let lowercasedJobTitle = jobTitle.lowercased()
        switch lowercasedJobTitle {
        case _ where !(software.filter {lowercasedJobTitle.contains($0)}.isEmpty):
            return .software
        case _ where !(data.filter {lowercasedJobTitle.contains($0)}.isEmpty):
            return .data
        case _ where !(writer.filter {lowercasedJobTitle.contains($0)}.isEmpty):
            return .writer
        case _ where !(marketing.filter {lowercasedJobTitle.contains($0)}.isEmpty):
            return .marketing
        case _ where !(support.filter {lowercasedJobTitle.contains($0)}.isEmpty):
            return .support
        case _ where !(hr.filter {lowercasedJobTitle.contains($0)}.isEmpty):
            return .hr
        default:
            return .other
        }
    }
}
