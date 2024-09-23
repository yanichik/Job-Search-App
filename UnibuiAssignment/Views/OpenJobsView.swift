//
//  OpenJobsView.swift
//  UnibuiAssignment
//
//  Created by Yan Brunshteyn on 9/12/24.
//

import SwiftUI
import CoreData

struct OpenJobsView: View {
    @ObservedObject var csvDataManager = CSVDataManager()
    @State private var displayErrorAlert = false
    @State private var errorMessage: String?
    @State private var searchQuery = ""
    @State private var likedJobs: Set<Int> = []
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    
    var filteredJobs: [Job] {
            // Filter jobs based on the search query
            if searchQuery.isEmpty {
                return csvDataManager.jobs
            } else {
                return csvDataManager.jobs.filter { job in
                    job.jobTitle.localizedCaseInsensitiveContains(searchQuery) 
                }
            }
        }
    
    var body: some View {
        NavigationStack {
            // Search Bar
            TextField("Search by job title:", text: $searchQuery)
                .padding(8)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding()
            JobsListView(jobs: filteredJobs, likedJobs: $likedJobs)
                .padding(.leading, -10)
                .padding(.trailing, -10)
        }
        .background(Color(.clear)) // Set a background color
        .onAppear(perform: { loadJobs() })
        .alert("Error Loading Jobs", isPresented: $displayErrorAlert, actions: {
            Button("OK", role: .cancel) { }
        }, message: {
            Text(errorMessage ?? "Unkown Error Occurred")
        })
    }
    
    private func loadJobs() {
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
    }
    
    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()
            
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

#Preview {
    OpenJobsView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}

struct JobsListView: View {
    var jobs: [Job]
    @Binding var likedJobs: Set<Int>
    var body: some View {
        List {
            HeaderView()
            ForEach(jobs) { job in
                let detailViewModel = JobDetailViewModel(job)
                NavigationLink(destination: JobDetailView(viewModel: detailViewModel)) {
                    HStack {
                        GeometryReader { geometry in
                            HStack {
                                // Title
                                Text(job.jobTitle)
                                    .font(.custom("Courier New", size: 16))
                                    .bold()
                                    .frame(width: geometry.size.width * 0.45, alignment: .leading)
                                    .lineLimit(2)
                                    .fixedSize(horizontal: false, vertical: true)
                                    .padding(.leading, -15)
                                
                                // Company Name
                                Text(job.companyName)
                                    .font(.custom("Courier New", size: 12))
                                    .frame(width: geometry.size.width * 0.2, alignment: .leading)
                                    .lineLimit(2)
                                    .padding(.leading, 0)
                                
                                // Location
                                Text(job.location)
                                    .font(.custom("Courier New", size: 12))
                                    .frame(width: geometry.size.width * 0.25, alignment: .leading)
                                    .lineLimit(2)
                                // Like Button
                                Button(action: {
                                    toggleLike(forJob: job)
//                                    print("liked")
                                }) {
                                    Image(systemName: likedJobs.contains(job.id) ? "heart.fill" : "heart")
                                        .foregroundColor(likedJobs.contains(job.id) ? .red : .gray)
                                }
                                .frame(width: geometry.size.width * 0.05, alignment: .leading)
                            }
                            .frame(height: geometry.size.height) // Constrain GeometryReader height to avoid expansion
                        }
                        .frame(height: 35) // Set a fixed height for the entire HStack to constrain the GeometryReader
                    }
                    .gridColumnAlignment(.center)
                }
                .navigationTitle("Open Positions")
                .padding(.trailing, -15)
            }
        }
    }
    private func toggleLike(forJob job: Job) {
        if likedJobs.contains(job.id){
            likedJobs.remove(job.id)
        } else {
            
        }
        
    }
}

struct HeaderView: View {
    var body: some View {
        HStack {
            Text("Position")
                .frame(maxWidth: .infinity, alignment: .center)
            Text("Company")
                .frame(maxWidth: .infinity, alignment: .center)
            Text("Location")
                .frame(maxWidth: .infinity, alignment: .center)
        }
        .font(.custom("Courier new", size: 18))
        .bold()
    }
}
