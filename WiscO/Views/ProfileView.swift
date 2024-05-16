//
//  ProfileView.swift
//  WiscO
//
//  Created by Nils Wenning on 01.05.24.
//

import SwiftUI

struct ProfileView: View {
    @StateObject var viewModel = ProfileViewModel()
    @StateObject var globalViewModel: GlobalViewModel

    
    var body: some View {
        NavigationView{
            VStack{
                if let user = viewModel.userInfo {
                    profile(user: user)
                }else{
                    ProgressView()
                    Button("Log Out"){
                        globalViewModel.logout()
                    }
                    .tint(.red)
                    .padding()
                }
            }
            .navigationTitle("Profile")
            .alert(isPresented: $viewModel.showingAlert) {
                            switch viewModel.alertType {
                            case .confirmation:
                                return Alert(title: Text("Confirmation"),
                                             message: Text(viewModel.alertMessage),
                                             primaryButton: .destructive(Text("I'm Sure")) {
                                                viewModel.resetServer()
                                             },
                                             secondaryButton: .cancel())
                            case .success, .error:
                                return Alert(title: Text("Status"),
                                             message: Text(viewModel.alertMessage),
                                             dismissButton: .default(Text("OK")))
                            }
                        }
        }.onAppear{
            viewModel.updateUserData()
        }
    }
    
    @ViewBuilder
    func profile(user: UserInfo) -> some View{
        // Avatar
        Image(systemName: "person.circle")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
            .frame(width:125, height: 125)
            .padding(/*@START_MENU_TOKEN@*/EdgeInsets()/*@END_MENU_TOKEN@*/)
        
        // Info: Name, Email, Member Since
        
        VStack(alignment: .leading, content: {
            HStack{
                Text("Name: ").bold()
                Text("\(user.name)")
            }
            .padding()
            HStack{
                Text("Email: ").bold()
                Text("\(user.email)")
            }.padding()
            HStack{
                Text("Minutes Left: ").bold()
                Text("\(user.quota)")
            }.padding()
            HStack{
                Text("Total Minutes used: ").bold()
                Text("\(user.used_minutes)")
            }.padding()
            HStack{
                Text("Member Since: ").bold()
                Text("\(Date(timeIntervalSince1970: user.created_at).formatted(date: .abbreviated, time: .shortened))")
            }.padding()
        }).padding()
        
        
        // Reset Server
        
        if user.role == "admin" {
            Button("Reset Server") {
                viewModel.confirmReset()
            }
            .tint(.red)
            .padding()
        }
        
        // Sign Out
        
        Button("Log Out"){
            globalViewModel.logout()
        }
        .tint(.red)
        .padding()
        Spacer()
    }
}


struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        // Create a sample UserInfo object with demo data
        let demoUser = UserInfo(name: "Test Name", role: "admin", email: "admin@wisco.de", password: "pass", api_key: "123", quota: 1000, created_at: Date().timeIntervalSince1970, used_minutes: 69)
        
        // Create a mock ProfileViewModel and inject the demo data
        let mockProfileViewModel = ProfileViewModel()
        mockProfileViewModel.userInfo = demoUser
        
        // Create a mock GlobalViewModel
        let mockGlobalViewModel = GlobalViewModel()
        
        // Wrap the ProfileView in a Group or another View if needed
        return Group {
            ProfileView(viewModel: mockProfileViewModel, globalViewModel: mockGlobalViewModel)
        }
    }
}
