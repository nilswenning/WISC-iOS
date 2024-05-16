//
//  JobListItem.swift
//  WiscO
//
//  Created by Nils Wenning on 04.05.24.
//

import SwiftUI

struct JobListItem: View {
    /**
     This view needs to update when the trip changes.
     */
    var jobInfo: JobModel
    
    init(jobInfo: JobModel) {
        self.jobInfo = jobInfo
    }
    
    var body: some View {
        HStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(
                     jobInfo.status == "summary-saved" ? Color.green :
                     jobInfo.status == "failed" ? Color.red :
                     Color.gray) 
                .frame(width: 64, height: 64)
                .overlay(
                    Text(String(jobInfo.summary_file_name.first ?? " ")) // Safely unwrapping with a fallback
                        .font(.system(size: 48))
                        .foregroundColor(.white) // Fixed foreground color
                )
                .padding(.trailing)
            
            VStack(alignment: .leading) {
                Text(jobInfo.summary_file_name)
                    .font(.headline)
                Text(jobInfo.status)
                    .font(.subheadline)
            }
        }
    }
}

#Preview {
    JobListItem(jobInfo: .preview) as JobListItem
}

