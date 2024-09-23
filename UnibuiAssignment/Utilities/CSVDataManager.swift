//
//  CSVDataManager.swift
//  UnibuiAssignment
//
//  Created by Yan Brunshteyn on 9/16/24.
//

import Foundation

enum CSVError: Error {
    case FILE_READING
    case FILE_PATH
    case PARSING_NUMBER_COLUMNS
    case PARSING_OTHER
}

class CSVDataManager: ObservableObject {
    
    @Published var jobs = [Job]()
    
    func fetchCSVData(from file: String) -> Result<String, CSVError> {
        if let file = Bundle.main.path(forResource: file, ofType: "csv") {
            do {
                let fileContent = try String(contentsOfFile: file)
                return .success(fileContent)
            } catch {
                return .failure(.FILE_READING)
            }
        }
        return .failure(.FILE_PATH)
    }
    
    func parseCSVData(_ csvContent: String) -> Result<[[String]], CSVError> {
        var parsedCSVData = [[String]]()
        let rows = csvContent.components(separatedBy: "\n")
        let expectedColumnCount = 5 // Expected number of columns in jobs data
        let pattern = "\"([^\"]*)\""
        for row in rows {
            guard !row.isEmpty else { continue }
            if !row.contains("\""){
                let columns = row.components(separatedBy: ",")
                parsedCSVData.append(columns)
            } else {
                do {
                    var columns = [String]()
                    let regex = try NSRegularExpression(pattern: pattern)
                    let nsString = row as NSString
                    let matches = regex.matches(in: row, range: NSRange(location: 0, length: nsString.length))
                    for (i, match) in matches.enumerated() {
                        // match start range - if first range:
                        if i == 0 {
                            // first capture componenets separated by "," until that range
                            // create start & end indexes, then substring from that range, then apply substring.components(separatedBy: ",")
                            let startIndex = row.index(row.startIndex, offsetBy: 0)
                            let endIndex = row.index(row.startIndex, offsetBy: match.range.location)
                            let subString = row[startIndex..<endIndex]
                            let components = subString.components(separatedBy: ",").filter {!$0.isEmpty}
                            columns.append(contentsOf: components)
                            // then add match itself
                            if let range = Range(match.range(at: 1), in: row) {
                                let inQuotes = String(row[range])
                                columns.append(inQuotes)
                            }
                            // if first and only match
                            if i == matches.count - 1 {
                                let startIndex = row.index(row.startIndex, offsetBy: match.range.location + match.range.length)
                                let endIndex = row.endIndex
                                let subString = row[startIndex..<endIndex]
                                let components = subString.components(separatedBy: ",").filter {!$0.isEmpty}
                                columns.append(contentsOf: components)
                            }
                        } else {
                            // if last range:
                            // separate components by "," with substring that starts at end of this match until end of row
                            if i == matches.count - 1 {
                                var startIndex = row.index(row.startIndex, offsetBy: matches[i-1].range.location + matches[i-1].range.length)
                                var endIndex = row.index(row.startIndex, offsetBy: match.range.location)
                                var subString = row[startIndex..<endIndex]
                                let trimmedSubString = subString.trimmingCharacters(in: CharacterSet(charactersIn: ","))
                                var components = trimmedSubString.components(separatedBy: ",").filter {!$0.isEmpty}
                                columns.append(contentsOf: components)
                                if let range = Range(match.range(at: 1), in: row) {
                                    let inQuotes = String(row[range])
                                    columns.append(inQuotes)
                                }
                                startIndex = row.index(row.startIndex, offsetBy: match.range.location + match.range.length)
                                endIndex = row.endIndex
                                subString = row[startIndex..<endIndex]
                                components = subString.components(separatedBy: ",").filter {!$0.isEmpty}
                                columns.append(contentsOf: components)
                            } else {
                                // else :
                                // separate components by "," with substring that starts at end of previous match until start of this one
                                let startIndex = row.index(row.startIndex, offsetBy: matches[i-1].range.location + match.range.length)
                                let endIndex = row.index(row.startIndex, offsetBy: match.range.location)
                                let subString = row[startIndex..<endIndex]
                                let components = subString.components(separatedBy: ",").filter {!$0.isEmpty}
                                columns.append(contentsOf: components)
                            }
                        }
                    }
                    if columns.count != expectedColumnCount {
                        return .failure(.PARSING_NUMBER_COLUMNS) // Trigger parsing error if column count is incorrect
                    }
                    parsedCSVData.append(columns)
                } catch {
                    return .failure(.PARSING_OTHER)
                }
            }
        }
        return .success(parsedCSVData)
    }
    func loadJobs(from file: String) -> CSVError? {
        let result = fetchCSVData(from: file)
        switch result {
        case .success(let csvContent):
            let result = parseCSVData(csvContent)
            switch result {
            case .success(let parsedCSVData):
                for (i, row) in parsedCSVData.dropFirst().enumerated() {
                    let job = Job(id: i, jobTitle: row[0], companyName: row[1], location: row[2], jobDescription: row[3], requirements: row[4])
                    self.jobs.append(job)
                }
            case .failure(let error):
                return error
            }
            return nil
        case .failure(let error):
            return error
        }
    }
}
