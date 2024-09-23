//
//  JobDetailViewModel.swift
//  UnibuiAssignment
//
//  Created by admin on 9/19/24.
//

import Foundation
import SwiftUI

class JobDetailViewModel: ObservableObject {
    @Published var topSafeAreaHeight: CGFloat = 0 // Store the top safe area height
    @Published var image: String = ""
    @Published var imageHeight: CGFloat = 150 // Store the image height
    @Published var imageWidth: CGFloat = 150  // Store the image width
    @Published var imageOverlayWidth: CGFloat = 5
    @Published var dividerHeight: CGFloat = 2
    @Published var dividerPadding: CGFloat = 22
    
    var job: Job?
    
    init(_ job: Job? = nil) {
        self.job = job
        DispatchQueue.main.async {
            self.image = {
                switch job!.type {
                case .data:
                    return "glare-data-analyst-infographics-and-statistics-1"
                case .hr:
                    return "notes-female-hr-conducts-an-in-person-interview"
                case .marketing:
                    return "3d-casual-life-browser-window-and-magnifying-glass-in-hand"
                case .software:
                    return "network-software-development-and-programming-script"
                case .support:
                    return "notes-support-specialist-working-on-helpline"
                case .writer:
                    return "haze-hand-with-a-pen"
                case .other:
                    return "lettering-lettering-join-our-team-text"
                }
            }()
        }
    }
    
    func updateImageSize(_ geometry: GeometryProxy) {
        DispatchQueue.main.async {
            self.imageHeight = geometry.size.height
            self.imageWidth = geometry.size.width
        }
    }
    
    func updateTopSafeAreaHeight(geometry: GeometryProxy?, newHeight: CGFloat?) {
        if let geometry = geometry {
            DispatchQueue.main.async {
                self.topSafeAreaHeight = geometry.safeAreaInsets.top
            }
            return
        }
        if let newHeight = newHeight {
            DispatchQueue.main.async {
                self.topSafeAreaHeight = newHeight
            }
            return
        }
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            DispatchQueue.main.async {
                self.topSafeAreaHeight = window.safeAreaInsets.top
            }
        }
    }
}
