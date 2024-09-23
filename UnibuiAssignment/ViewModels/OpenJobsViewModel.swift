//
//  OpenJobsViewModel.swift
//  UnibuiAssignment
//
//  Created by Yan Brunshteyn on 9/23/24.
//

import SwiftUI

class OpenJobsViewModel: ObservableObject {
    @ObservedObject var csvDataManager = CSVDataManager()
    @Published var displayErrorAlert = false
    @Published var errorMessage: String?
    @Published var searchQuery = ""
    @Published var likedJobs: Set<Int> = []
    @Published var filteredJobs: [Job] = []
    
    func filterJobs() {
        // Filter jobs based on the search query
        if searchQuery.isEmpty {
            filteredJobs = csvDataManager.jobs
        } else {
            filteredJobs = csvDataManager.jobs.filter { job in
                job.jobTitle.localizedCaseInsensitiveContains(searchQuery)
            }
        }
    }
    
    func loadJobs() {
        let error = csvDataManager.loadJobs(from: "jobsMock")
        if let error = error {
            switch error {
            case .FILE_PATH:
                errorMessage = "Incorrect File Path."
            case .FILE_READING:
                errorMessage = "Cannot Read File."
            case .PARSING_NUMBER_COLUMNS:
                errorMessage = "Parsing Error: Incorrect Number of Columns."
            case .PARSING_OTHER:
                errorMessage = "Parsing Error: Data Formatted Incorrect."
            }
            displayErrorAlert = true
        }
        else {
            filterJobs()
        }
    }
    
    func toggleLike(forJob job: Job) {
        if likedJobs.contains(job.id) {
            likedJobs.remove(job.id)
        } else {
            likedJobs.insert(job.id)
        }
    }
}
