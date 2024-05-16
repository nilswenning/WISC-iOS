//
//  JobResultView.swift
//  WiscO
//
//  Created by Nils Wenning on 05.05.24.
//

import SwiftUI
import MarkdownUI

struct JobResultView: View {
    
    @State var currentTab: Int = 0
    @Namespace var namespace
    
    
    var jobInfo: JobModel
    @StateObject private var viewModel: JobResultViewModel

    // Use an initializer to setup the viewModel
    init(jobInfo: JobModel) {
        self.jobInfo = jobInfo
        _viewModel = StateObject(wrappedValue: JobResultViewModel(jobInfo: jobInfo))
    }
    
    var body: some View {
        VStack{
            if viewModel.jobResult != nil {
                job()
            }else{
                ProgressView()
                job()
            }
        }
        .navigationTitle(jobInfo.summary_file_name)
        .alert(isPresented: $viewModel.alertShown) {
            Alert(title: Text("Response:"), message: Text(viewModel.alertText), dismissButton: .default(Text("OK")))
            }
}
    

    
    @ViewBuilder
    func job() -> some View{
        VStack {
            HStack{
                Text("Status: ").bold()
                Text("\(viewModel.jobInfo.status)")
                Spacer()
            }.padding()
            .frame(height: 50)
            .padding(.horizontal)
            
            Picker("", selection: $viewModel.tabSelectedValue) {
                Text("Transcription").tag(0)
                Text("Short Sumary").tag(1)
                Text("Redo").tag(2)

            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)
            TabView(selection: $viewModel.tabSelectedValue) {
                transcriptionView.tag(0)
                shortSummaryView.tag(1)
                RedoView.tag(2)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .animation(.easeIn, value: viewModel.tabSelectedValue)
            .refreshable {
                viewModel.updateData()
            }
        }
    }
    
    @ViewBuilder
    var transcriptionView: some View{
        VStack{
            ScrollView{
                Markdown(viewModel.transcription)
            }
        }.padding()

    }
    @ViewBuilder
    var shortSummaryView: some View{
        VStack{
            ScrollView{
                Markdown(viewModel.shortSummary)
            }
        }.padding()

    }
    @ViewBuilder
    var RedoView: some View{
        VStack{
            if (viewModel.serverOptions?.summary_prompts) != nil {
                SumSettingsView(
                    selectedServerIndex: $viewModel.selectedServerIndex,
                    selectedLanguageIndex: $viewModel.selectedLanguageIndex,
                    selectedSummaryIndex: $viewModel.selectedSummaryIndex,
                    serverOptions: viewModel.serverOptions!.server,
                    languages: viewModel.serverOptions!.languages,
                    summaryStructure: viewModel.serverOptions!.summary_prompts
                )
            }else{
                Text("Loading Settings")
                ProgressView()
            }


            HStack{
                TLButton(title: "Redo All", background: .red){
                    viewModel.restartJob()
                }
                if !(viewModel.jobInfo.status == "summary-saved"){
                    TLButton(title: "Summarize", background: .gray){
                        
                    }
                }else{
                    TLButton(title: "Summarize", background: .pink){
                        viewModel.resummarize()
                    }
                }

            }.frame(height: 100)
        }.onAppear{
            viewModel.updateServerOptions()
        }
    }

}

struct JobResultView_Previews: PreviewProvider {
    static var previews: some View {
        JobResultView(jobInfo: .preview)
            .environmentObject(JobResultViewModel.preview)
    }
}
