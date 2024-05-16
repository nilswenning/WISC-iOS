//
//  SumSettingsView.swift
//  WiscO
//
//  Created by Nils Wenning on 06.05.24.
//
import SwiftUI

struct SumSettingsView: View {
    
    @Binding var selectedServerIndex: Int?
    @Binding var selectedLanguageIndex: Int?
    @Binding var selectedSummaryIndex: Int?

    let serverOptions: [String]
    let languages: [String]
    let summaryStructure: [String]
    
    var gridLayout: [GridItem] = Array(repeating: .init(.flexible()), count: 2)

    var body: some View {
        Form {
            Text("Settings:")
                .font(.title2)
                .padding(.bottom, -30).listRowBackground(Color.clear)
            Section(header: Text("Transcription Server Selection")) {
                settingGrid(items: serverOptions, selectedIndex: $selectedServerIndex)
            }.listRowBackground(Color.clear)
            .padding(.vertical, -10)
            Section(header: Text("Language")) {
                settingGrid(items: languages, selectedIndex: $selectedLanguageIndex)
            }.listRowBackground(Color.clear)
            .padding(.vertical, -10)
            Section(header: Text("Summary Structure")) {
                settingGrid(items: summaryStructure, selectedIndex: $selectedSummaryIndex)
            }.listRowBackground(Color.clear)
            .padding(.vertical, -10)
        }
        .scrollContentBackground(.hidden)
    }
    
    private func settingGrid(items: [String], selectedIndex: Binding<Int?>) -> some View {
        LazyVGrid(columns: gridLayout, spacing: 10) {
            ForEach(items.indices, id: \.self) { index in
                Button(action: {
                }) {
                    HStack {
                        Text(items[index].capitalized)
                            .foregroundColor(selectedIndex.wrappedValue == index ? .white : .primary)
                            .padding(.horizontal)
                        Spacer()
                        if selectedIndex.wrappedValue == index {
                            Image(systemName: "checkmark")
                                .foregroundColor(.white)
                        }
                    }
                }
                .frame(maxWidth: .infinity, minHeight: 44)
                .background(selectedIndex.wrappedValue == index ? Color.blue : Color.secondary.opacity(0.2))
                .cornerRadius(8)
                .onTapGesture {
                    selectedIndex.wrappedValue = index
                }
            }
        }
        
    }
}

extension View {
    func centeredButton() -> some View {
        HStack {
            Spacer()
            self
            Spacer()
        }
        .padding()
        .background(Color.blue)
        .foregroundColor(.white)
        .cornerRadius(8)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        SumSettingsView(
            selectedServerIndex: .constant(0),
            selectedLanguageIndex: .constant(1),
            selectedSummaryIndex: .constant(2),
            serverOptions: ["Server 1", "Server 2", "Server 3"],
            languages: ["English", "Spanish", "French"],
            summaryStructure: ["Brief", "Detailed", "Comprehensive"]
        )
    }
}
