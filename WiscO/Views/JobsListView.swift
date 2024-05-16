//
//  JobsListView.swift
//  WiscO
//
//  Created by Nils Wenning on 01.05.24.
//

import SwiftUI

struct JobsListView: View {
    @StateObject var viewModel = JobsListViewModel()
    
    @State private var selection: JobModel?

    var body: some View {
        NavigationStack{
            List(selection: $selection) {
                ForEach(viewModel.jobs) { job in
                    NavigationLink(destination: JobResultView(jobInfo: job)) {
                        JobListItem(jobInfo: job)
                    }
                }
            }.refreshable {
                viewModel.updateList()
            }
            .overlay {
                if viewModel.jobs.isEmpty {
                    ContentUnavailableView {
                         Label("No Recent Transcription Jobs", systemImage: "square.and.arrow.up.circle")
                    } description: {
                         Text("New Jobs you create will appear here.")
                    }
                }
            }
        }
        .onAppear{
            viewModel.updateList()
        }
    }
}

#Preview {
    JobsListView()
}
