//
//  ProgressBar.swift
//  Trivia
//
//  Created by Anton Nagornyi on 29.06.2022.
//

import SwiftUI

struct ProgressBar: View {
    
    var progress: CGFloat
    
    var body: some View {
        
        ZStack (alignment: .leading) {
            Rectangle()
                .frame(maxWidth: 350, maxHeight: 4)
                .cornerRadius(10)
                .foregroundColor(.gray.opacity(0.5))
            Rectangle()
                .frame(maxWidth: progress, maxHeight: 4)
                .foregroundColor(Color("accent"))
                .cornerRadius(10)
        }
        
        
    }
}

struct ProgressBar_Previews: PreviewProvider {
    static var previews: some View {
        ProgressBar(progress: 50)
    }
}
