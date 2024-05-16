//
//  TLButton.swift
//  WiscO
//
//  Created by Nils Wenning on 01.05.24.
//

import SwiftUI

struct TLButton: View {
    let title: String
    let background: Color
    let action: () -> Void
    
    var body: some View {
        Button{
           // Action
            action()
        }label: {
            ZStack{
                RoundedRectangle(cornerRadius: 10).foregroundColor(background)
                Text(title)
                    .foregroundColor(.white)
            }
        }.padding(10)
    }
}

#Preview {
    TLButton(title: "Color", background: .cyan){
        // Action
    }
}
