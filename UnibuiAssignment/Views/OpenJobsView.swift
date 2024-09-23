//
//  OpenJobsView.swift
//  UnibuiAssignment
//
//  Created by Yan Brunshteyn on 9/12/24.
//

import SwiftUI

struct OpenJobsView: View {
    
    @StateObject private var viewModel: OpenJobsViewModel
    
    init(viewModel: OpenJobsViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationStack {
            // Search Bar
            TextField("Search by job title:", text: $viewModel.searchQuery)
                .padding(8)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding()
                .onChange(of: viewModel.searchQuery) {
                    viewModel.filterJobs()
                }
            JobsListView(jobs: viewModel.filteredJobs, likedJobs: $viewModel.likedJobs)
                .padding(.leading, -10)
                .padding(.trailing, -10)
        }
        .background(Color(.clear)) // Set a background color
        .onAppear(perform: { viewModel.loadJobs() })
        .alert("Error Loading Jobs", isPresented: $viewModel.displayErrorAlert, actions: {
            Button("OK", role: .cancel) { }
        }, message: {
            Text(viewModel.errorMessage ?? "Unkown Error Occurred")
        })
    }
}


struct JobsListView: View {
    var jobs: [Job]
    @Binding var likedJobs: Set<Int>
    
    var body: some View {
        List {
            HeaderView()
            ForEach(jobs) { job in
                let detailViewModel = JobDetailViewModel(job)
                HStack {
                    NavigationLink(destination: JobDetailView(viewModel: detailViewModel)) {
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
                                // Like Button
                            }
                            .frame(height: geometry.size.height) // Constrain GeometryReader height to avoid expansion
                        }
                        .frame(height: 35) // Set a fixed height for the entire HStack to constrain the GeometryReader
                    }
                    .gridColumnAlignment(.center)
                    Divider()
                    Button(action: {
                        toggleLike(forJob: job)
                    }) {
                        Image(systemName: likedJobs.contains(job.id) ? "heart.fill" : "heart")
                            .foregroundColor(likedJobs.contains(job.id) ? Color.purple.opacity(0.8) : .gray)
                    }
                    .buttonStyle(PlainButtonStyle())
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
            likedJobs.insert(job.id)
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

#Preview {
    OpenJobsView(viewModel: OpenJobsViewModel())
}
