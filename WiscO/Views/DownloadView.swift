//
//  DlView.swift
//  WiscO
//
//  Created by Nils Wenning on 07.05.24.
//

import SwiftUI

struct DownloadView: View {
    @StateObject var viewModel = DownloadViewModel()
    
    var body: some View {
        ZStack {
            VStack {
                TextField("Enter text", text: $viewModel.link)
                    .textFieldStyle(.roundedBorder)
                    .padding()
                
                Button("Paste from Clipboard") {
                    pasteFromClipboard()
                }
                .buttonStyle(.borderedProminent)
                .padding()
                if !viewModel.errorText.isEmpty{
                    Text(viewModel.errorText).foregroundColor(.red)
                }
                Divider()
                
                // Conditionally displaying SumSettingsView when summaryPrompt is not nil
                if (viewModel.serverOptions?.summary_prompts) != nil {
                    SumSettingsView(
                        selectedServerIndex: $viewModel.selectedServerIndex,
                        selectedLanguageIndex: $viewModel.selectedLanguageIndex,
                        selectedSummaryIndex: $viewModel.selectedSummaryIndex,
                        serverOptions: viewModel.serverOptions!.server,  // Make sure serverOptions is already loaded
                        languages: viewModel.serverOptions!.languages,
                        summaryStructure: viewModel.serverOptions!.summary_prompts
                    )
                }else{
                    Text("Loading Settings")
                    ProgressView()
                }
                
                if viewModel.serverSuccess {
                    Text("Upload Done !")
                }
                TLButton(title: "Upload", background: .blue) {
                    viewModel.addLink()
                }
                .frame(height: 75)
            }
            if viewModel.isLoading {
                Rectangle()
                    .foregroundColor(.black.opacity(0.5))
                    .edgesIgnoringSafeArea(.all) // Full screen overlay
                ProgressView()
            }
            if viewModel.serverSuccess {
                Rectangle()
                    .foregroundColor(.black.opacity(0.5))
                    .edgesIgnoringSafeArea(.all) // Full screen overlay

                // Checkmark symbol
                Image(systemName: "checkmark")
                    .resizable()
                    .frame(width: 80, height: 60)
                    .foregroundColor(.green)
            }
        }.onAppear{
            viewModel.updateServerOptions()
        }
    }
    
    private func pasteFromClipboard() {
        if let clipboardContent = UIPasteboard.general.string {
            viewModel.link = clipboardContent
        }
    }
}

#Preview {
    DownloadView()
}
