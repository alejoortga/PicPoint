//
//  OpenningApp.swift
//  PPoint
//
//  Created by A. Ortega on 11/4/23.
//

import SwiftUI

struct OpenningApp: View {
    
    
    @State private var scale: CGFloat = 0.5
    @State private var showImage = false
    @State private var yOffset: CGFloat = 0
    @State private var secondVStackOffset: CGFloat = 0
    @State private var secondVStackOpacity: Double = 0
    
    var body: some View {
        ZStack{
            Color(.systemBackground)
                .ignoresSafeArea(.all)
            VStack{
                if showImage {
                    Image("PicPoint")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 100)
                        .cornerRadius(10)
                }
                Text("PicPoint")
                    .foregroundStyle(Color(red: 249/255, green: 219/255, blue: 87/255))
                    .minimumScaleFactor(0.5)
            }.font(.system(size: 45, design: .rounded).bold())
                .scaleEffect(scale)
                .animation(
                    Animation.easeInOut(duration: 1)
                        .repeatCount(0, autoreverses: true)
                        .delay(0),
                    value: scale
                )
                .onAppear {
                    withAnimation {
                        scale = 1.0
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        withAnimation {
                            showImage = true
                            yOffset = -200 // Cambia este valor según tu necesidad
                        }
                        withAnimation(Animation.easeInOut(duration: 1)) {
                            secondVStackOffset = -50 // Cambia este valor según tu necesidad
                            secondVStackOpacity = 1.0
                        }
                    }
                }
        }
    }
}

#Preview {
    OpenningApp()
}
