//
//  ContentView.swift
//  WiscO
//
//  Created by Nils Wenning on 26.04.24.
//

import SwiftUI

struct MainView: View {
    
    @StateObject var loginViewModel = LoginViewModel()
    @StateObject var globalViewModel = GlobalViewModel()

    var body: some View {
        NavigationView {
            if globalViewModel.isLoggedIn {
                accountView
            } else {
                LoginView(globalViewModel: globalViewModel)
            }
        }
    }
    @ViewBuilder
    var accountView: some View{
        TabView{
            JobsListView().tabItem {
                Label("Home", systemImage: "house")
            }
            DownloadView().tabItem {
                Label("Link DL", systemImage: "video")
            }
            ProfileView(globalViewModel: globalViewModel).tabItem {Label("Profile", systemImage: "person.circle")
            }
        }
    }
}

#Preview {
    MainView()
}
