//
//  ShareMainView.swift
//  share
//
//  Created by Nils Wenning on 03.05.24.
//
// for some reason the file has to be here otherwise the preview dosnt work

import SwiftUI

struct ShareMainView: View {
    @StateObject var shareMainViewModel: ShareMainViewModel
    
    var body: some View {
        ZStack {
            if !shareMainViewModel.apiKey.isEmpty {
                VStack {
                    headerView
                    Divider()
                    Spacer()
                    
                    // Conditionally displaying SumSettingsView when summaryPrompt is not nil
                    if (shareMainViewModel.serverOptions?.summary_prompts) != nil {
                        SumSettingsView(
                            selectedServerIndex: $shareMainViewModel.selectedServerIndex,
                            selectedLanguageIndex: $shareMainViewModel.selectedLanguageIndex,
                            selectedSummaryIndex: $shareMainViewModel.selectedSummaryIndex,
                            serverOptions: shareMainViewModel.serverOptions!.server,  // Make sure serverOptions is already loaded
                            languages: shareMainViewModel.serverOptions!.languages,
                            summaryStructure: shareMainViewModel.serverOptions!.summary_prompts
                        )
                    }else{
                        Text("Loading Settings")
                        ProgressView()
                    }
                    
                    if shareMainViewModel.serverSuccess {
                        Text("Upload Done !")
                    }else{
                        Text("Uploading to: \(shareMainViewModel.serverUrl)")
                    }
                    TLButton(title: "Upload", background: .blue) {
                        shareMainViewModel.uploadFile()
                    }
                    .frame(height: 75)
                }
            } else {
                VStack {
                    headerView
                    Spacer()
                    Text("Error").font(.title2)
                    Text("Please use the App to Login")
                    Spacer()
                }
            }
            
            if shareMainViewModel.isLoading {
                Color.black.opacity(0.4).ignoresSafeArea()
                ProgressView()
            }
            if shareMainViewModel.serverSuccess {
                Rectangle()
                    .foregroundColor(.black.opacity(0.5))
                    .edgesIgnoringSafeArea(.all) // Full screen overlay

                // Checkmark symbol
                Image(systemName: "checkmark")
                    .resizable()
                    .frame(width: 80, height: 60)
                    .foregroundColor(.green)
            }
        }
    }
    
    var headerView: some View {
        Text("WISC-O")
            .font(.title.bold())
            .frame(maxWidth: .infinity)
            .overlay(alignment: .leading) {
                Button("Cancel") {
                    shareMainViewModel.close()
                }
                .tint(.red)
            }
            .padding()
    }
}

struct ShareMainView_Previews: PreviewProvider {
    static var previews: some View {
        let shareViewModel = ShareMainViewModel()
        ShareMainView(shareMainViewModel: shareViewModel)
    }
}
