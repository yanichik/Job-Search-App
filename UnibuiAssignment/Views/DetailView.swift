//
//  DetailView.swift
//  UnibuiAssignment
//
//  Created by admin on 9/17/24.
//

import SwiftUI
/*
 job description, requirements, and company information.
 */
struct DetailView: View {
    var job: Job?
    init(_ job: Job? = nil) {
        self.job = job
    }
    var body: some View {
        NavigationStack {
            
            VStack {
                Image("icons8-hr-96", bundle: nil)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 150, height: 150)
                    .clipShape(Circle())
                    .overlay(
                        Circle().stroke(.white, lineWidth: 5.0)
                    )
                    .frame(maxWidth: .infinity, maxHeight: 200, alignment: .top) // Align to top
                    .background(Color.black)
                Text(job!.jobDescription)
                Text(job!.requirements)
                Text(job!.companyName)
            }.navigationTitle("Position: \(job!.jobTitle)").navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    DetailView(Job(id: 0, jobTitle: "Janitor", companyName: "Janitorial Services Inc.", location: "San Francisco", jobDescription: "Clean everything", requirements: "Be thourough"))
}
