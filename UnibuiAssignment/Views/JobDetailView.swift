//
//  JobDetailView.swift
//  UnibuiAssignment
//
//  Created by Yan Brunshteyn on 9/17/24.
//

import SwiftUI

struct JobDetailView: View {
    
    @StateObject private var viewModel: JobDetailViewModel
    @State private var displayDescription: Bool = true
    @State private var displayRequirements: Bool = false
    
    init(viewModel: JobDetailViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationStack {
            GeometryReader { navStackGeometry in
                VStack(spacing: 0) {
                    ZStack(alignment: .top) {
                        ImageBackgroundView(viewModel: viewModel, geometry: navStackGeometry)
                        // Image placed in the center of the background
                        JobImageView(with: viewModel)
                    }
                    Text("Apply to: \(viewModel.job!.companyName)").padding(.top, -60)
                    HStack {
                        MoreDetailsButton(labelText: "Description", geometry: navStackGeometry, action: {
                            displayDescription.toggle() // Toggle description
                            displayRequirements = false // Hide requirements if description is shown
                        }, isHighlighted: $displayDescription) // Pass highlight state
                        
                        MoreDetailsButton(labelText: "Requirements", geometry: navStackGeometry, action: {
                            displayRequirements.toggle() // Toggle requirements
                            displayDescription = false // Hide description if requirements are shown
                        }, isHighlighted: $displayRequirements) // Pass highlight state
                    }
                    
                    .frame(width: navStackGeometry.size.width, alignment: .center)
                    .padding(.bottom, 20)
                    
                    // Show job description if turned on
                    if displayDescription == true {
                        Text(viewModel.job!.jobDescription)
                    }
                    // Show requirements if turned on
                    if displayRequirements == true {
                        Text(viewModel.job!.requirements)
                    }
                    Spacer() // Push content to fill the rest of the screen
                }
                .navigationBarTitleDisplayMode(.inline)
                .onChange(of: viewModel.topSafeAreaHeight) { newSafeAreaHeight in
                    // Ensure the layout updates based on new safe area insets
                    viewModel.updateTopSafeAreaHeight(geometry: nil, newHeight: newSafeAreaHeight)
                }
                .onAppear {
                    viewModel.updateTopSafeAreaHeight(geometry: navStackGeometry, newHeight: nil)
                }
            }
        }
    }
}

struct JobTitleView: View {
    let viewModel: JobDetailViewModel
    init(with viewModel: JobDetailViewModel) {
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

struct ImageBackgroundView: View {
    let viewModel: JobDetailViewModel
    let geometry: GeometryProxy
    init(viewModel: JobDetailViewModel, geometry: GeometryProxy) {
        self.viewModel = viewModel
        self.geometry = geometry
    }
    var body: some View {
        VStack {
            // Background for the image, 300px high
            Color.purple.opacity(0.3)
                .frame(height: viewModel.imageHeight + geometry.safeAreaInsets.top + viewModel.dividerHeight + viewModel.dividerPadding + 7)
                .clipShape(
                    .rect(
                        topLeadingRadius: 0,
                        bottomLeadingRadius: 12,
                        bottomTrailingRadius: 12,
                        topTrailingRadius: 0
                    )
                )
                .overlay(RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.purple, lineWidth: 1))
                .ignoresSafeArea(.container, edges: .top) // Extend to top edge
        }
    }
}

struct JobImageView: View {
    let viewModel: JobDetailViewModel
    init(with viewModel: JobDetailViewModel) {
        self.viewModel = viewModel
    }
    var body: some View {
        VStack(spacing: 35) {
            Image(viewModel.image, bundle: nil)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: viewModel.imageWidth, height: viewModel.imageHeight)
                .background(
                    GeometryReader { geometry in
                        Color.clear.onAppear {
                            viewModel.updateImageSize(geometry)
                        }
                        .onChange(of: geometry.size) { newSize in
                            // Re-trigger a layout when the size changes
                            viewModel.updateImageSize(geometry)
                        }
                    }
                )
            JobTitleView(with: viewModel)
        }
    }
}

struct MoreDetailsButton: View {
    let labelText: String
    let geometry: GeometryProxy
    let action: () -> Void // Closure for button action
    @Binding var isHighlighted: Bool // Indicates if the button is highlighted
    
    init(labelText: String, geometry: GeometryProxy, action: @escaping () -> Void, isHighlighted: Binding<Bool>) {
        self.labelText = labelText
        self.geometry = geometry
        self.action = action
        self._isHighlighted = isHighlighted
    }
    
    var body: some View {
        Button(action: action) {
            Text(labelText)
                .foregroundColor(isHighlighted ? .white : .black) // Text color per highlight status
        }
        .frame(width: geometry.size.width * 0.4, alignment: .center)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.gray, lineWidth: 1)
        )
        .background(isHighlighted ? Color.purple.opacity(0.4) : Color.clear) // Background color per highlight status
        .cornerRadius(8)
        .font(.custom("Courier New", size: 16))
        .bold()
    }
}

#Preview {
    JobDetailView(viewModel: JobDetailViewModel(Job(id: 0, jobTitle: "Janitor", companyName: "Janitorial Services Inc.", location: "San Francisco", jobDescription: "Find the best", requirements: "Be thorough")))
}
