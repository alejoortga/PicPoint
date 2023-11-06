//
//  Testing.swift
//  PPoint
//
//  Created by A. Ortega on 9/28/23.
//

import SwiftUI

struct Testing: View {
    @State private var backgroundColor: Color = .black
        
    let colors: [Color] = [.teal, .yellow, .red, .purple, .green, .pink]
        
        var body: some View {
            VStack {
                ZStack{
                    Rectangle()
                        .foregroundColor(backgroundColor).ignoresSafeArea(.all)
                        .animation(Animation.easeInOut(duration:3).repeatForever(), value: backgroundColor)
                    
                    VStack{
                        VStack(){
                            
                            Spacer()
                            

                            Spacer()
                            
                            ZStack{
                                
                                ZStack{
                                    
                                
                                    
                                    Image("Cuoco")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 150)
                                        .minimumScaleFactor(1.0)
                                    
                                }
                                Text("PicPoint")
                                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                    .foregroundColor(Color.white)
                                    .font(.system(size: 90, design: .rounded)).fontWeight(.black)
                                    .foregroundStyle(.white)
                                    .minimumScaleFactor(0.01)
                                    .multilineTextAlignment(.leading)
                                    .opacity(1)
                                
                            }
                            
                            Spacer()
                            Text("CUOCO")
                                .font(.system(size: 15, design: .rounded)).fontWeight(.semibold)
                        }
                    }
                }
            }
            .onAppear {
                for (index, _) in colors.enumerated() {
                    DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 1.0) {
                        withAnimation {
                            self.backgroundColor = self.colors.randomElement() ?? .clear
                        }
                    }
                }
            }
        }
    
        
}

#Preview {
    Testing()
}
