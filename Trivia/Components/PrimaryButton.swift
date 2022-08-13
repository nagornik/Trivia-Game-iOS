//
//  PrimaryButton.swift
//  Trivia
//
//  Created by Anton Nagornyi on 29.06.2022.
//

import SwiftUI

struct PrimaryButton: View {
    
    var text: String
    var background: Color = Color("accent")
    var padding = 18.0
    var fontStyle = Font.body
    
    var body: some View {
        
        Text(text)
            .foregroundColor(.white)
            .font(fontStyle)
            .bold()
            .padding(padding)
            .padding(.horizontal)
            .background(background)
            .shadow(radius: 10)
            .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
        
    }
}

struct PrimaryButton_Previews: PreviewProvider {
    static var previews: some View {
        PrimaryButton(text: "Next")
    }
}
