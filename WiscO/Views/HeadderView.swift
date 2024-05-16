//
//  HeadderView.swift
//  WiscO
//
//  Created by Nils Wenning on 01.05.24.
//

import SwiftUI

struct HeadderView: View {
    let title: String
    let subtitle: String
    let angle: Double
    let background: Color
    
    
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/).foregroundColor(background)
                .rotationEffect(Angle(degrees: angle))
            VStack{
                Text(title)
                    .font(.system(size: 50))
                    .foregroundColor(.white)
                    .bold()
                Text(subtitle)
                    .font(.system(size: 30))
                    .foregroundColor(.white)
            }
            .padding(.top, 50)
            
        }
        .frame(width: UIScreen.main.bounds.width * 3,height: 350)
        .offset(y: -150)
    }
}

#Preview {
    HeadderView(title: "Title", subtitle: "Subtilte", angle: 15, background: .blue)
}
