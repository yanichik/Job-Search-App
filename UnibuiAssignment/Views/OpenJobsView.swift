//
//  OpenJobsView.swift
//  UnibuiAssignment
//
//  Created by admin on 9/12/24.
//

import SwiftUI
import CoreData

struct OpenJobsView: View {
    @ObservedObject var csvDataManager = CSVDataManager()
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    
    var body: some View {
        NavigationStack {
            JobsListView(jobs: csvDataManager.jobs)
                .padding(.leading, -10)
                .padding(.trailing, -10)
        }
        .background(Color(.clear)) // Set a background color
        .onAppear(perform: {
            csvDataManager.loadJobs(from: "jobsMock")
        })
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
    var body: some View {
        List {
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
            ForEach(jobs) { job in
                let detailViewModel = DetailViewModel(job)
                NavigationLink(destination: DetailView(viewModel: detailViewModel)) {
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
                                    .frame(width: geometry.size.width * 0.25, alignment: .leading)
                                    .lineLimit(2)
                                    .padding(.leading, 0)
                                
                                // Location
                                Text(job.location)
                                    .font(.custom("Courier New", size: 12))
                                    .frame(width: geometry.size.width * 0.3, alignment: .leading)
                                    .lineLimit(2)
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
}
