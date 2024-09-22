//
//  DetailView.swift
//  UnibuiAssignment
//
//  Created by admin on 9/17/24.
//

import SwiftUI

struct DetailView: View {
    
    @StateObject private var viewModel: DetailViewModel
    
    init(viewModel: DetailViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationStack {
            GeometryReader { navStackGeometry in
                VStack(spacing: 0) {
                    ZStack(alignment: .top) {
                        VStack {
                            // Background for the image, 300px high
                            Color.purple.opacity(0.3)
                                .frame(height: viewModel.imageHeight + navStackGeometry.safeAreaInsets.top + viewModel.dividerHeight + viewModel.dividerPadding + 7)
                                .ignoresSafeArea(.container, edges: .top) // Extend to top edge
                        }
                        
                        // Image placed in the center of the background
                        VStack {
                            Image(viewModel.image, bundle: nil)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: viewModel.imageWidth, height: viewModel.imageHeight)
                            //                                .clipShape(Circle())
                            //                                .overlay(
                            //                                    Circle().stroke(.gray, lineWidth: viewModel.imageOverlayWidth).opacity(0.2)
                            //                                )
                                .background(
                                    GeometryReader { geometry in
                                        Color.clear
                                            .onAppear {
                                                viewModel.updateImageSize(geometry)
                                                print("GeometryReader size: \(geometry.size.height)")
                                            }
                                            .onChange(of: geometry.size) { newSize in
                                                // Re-trigger a layout when the size changes
                                                viewModel.updateImageSize(geometry)
                                            }
                                    }
                                )
                            //                            .padding(.top, 25)
                            Rectangle()
                                .fill(.gray)
                                .frame(height: viewModel.dividerHeight)
                                .padding(.top, viewModel.dividerPadding)
                                .opacity(0.3)
                            // Job description positioned at the bottom of the purple background, aligned left
                            JobTitleView(with: viewModel)
                        }
                    }
                    
                    Text("Location: \(viewModel.job!.location)")
                    Text(viewModel.job!.jobDescription)
                    Text(viewModel.job!.requirements)
                    Text(viewModel.job!.companyName)
                    
                    Spacer() // Push content to fill the rest of the screen
                }
                .navigationBarTitleDisplayMode(.inline)
                .onChange(of: viewModel.topSafeAreaHeight) { newSafeAreaHeight in
                    // Ensure the layout updates based on new safe area insets
                    print("Safe area height updated: \(newSafeAreaHeight)")
                    viewModel.updateTopSafeAreaHeight(geometry: nil, newHeight: newSafeAreaHeight)
                }
                .onAppear {
                    viewModel.updateTopSafeAreaHeight(geometry: navStackGeometry, newHeight: nil)
                }
            }
        }
    }
}

#Preview {
    DetailView(viewModel: DetailViewModel(Job(id: 0, jobTitle: "Human Resources", companyName: "Janitorial Services Inc.", location: "San Francisco", jobDescription: "Find the best", requirements: "Be thorough")))
}

struct JobTitleView: View {
    let viewModel: DetailViewModel
    init(with viewModel: DetailViewModel) {
        self.viewModel = viewModel
    }
    var body: some View {
        Text(viewModel.job!.jobTitle)
            .frame(maxWidth: .infinity, alignment: .leading) // Align left
            .padding(.top, 0) // Add padding to the top
            .padding(.leading, 15) // Add padding to the left
            .font(.custom("Courier New", size: 25)).bold()
    }
}
