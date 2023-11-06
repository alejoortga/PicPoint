//
//  OnBoardingView.swift
//  PPoint
//
//  Created by A. Ortega on 10/22/23.
//

import SwiftUI

struct OnBoardingView: View {
    
    @State private var scale: CGFloat = 0.5
    @State private var showImage = false
    @State private var yOffset: CGFloat = 0
    @State private var secondVStackOffset: CGFloat = 0
    @State private var secondVStackOpacity: Double = 0
    @State private var thirdVstackOffset: CGFloat = 0
    @State private var thirdVStackOpacity : Double = 0
    @State private var showDataManaged = false
    
    @State private var showOnboarding = !UserDefaults.standard.bool(forKey: "hasShownOnboarding")
    
    var body: some View {
        if showOnboarding {
            ZStack {
                Color(.systemGroupedBackground)
                    .ignoresSafeArea(.all)
                
                VStack(alignment: .leading) {
                    if showImage {
                        Image("PicPoint")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 80, height: 80)
                            .cornerRadius(10)
                    }
                    
                    Text("Welcome to")
                        .foregroundStyle(.primary)
                        .minimumScaleFactor(0.5)
                    
                    Text("PicPoint")
                        .foregroundStyle(Color(red: 249/255, green: 219/255, blue: 87/255))
                        .minimumScaleFactor(0.5)
                }.font(.system(size: 45, design: .rounded).bold())
                    .scaleEffect(scale)
                    .offset(y: yOffset)
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
                VStack{
                    Spacer()
                    VStack(alignment: .leading){
                        HStack{
                            Image(systemName: "viewfinder.circle")
                                .font(.system(size: 30))
                                .foregroundStyle(Color(red: 249/255, green: 219/255, blue: 87/255))
                                .padding(.trailing, 10)
                            
                            VStack(alignment: .leading){
                                Text("Create Categories")
                                    .font(.system(size: 20, design: .rounded).bold())
                                    .minimumScaleFactor(1.0)
                                Text("Organiza con emojis, colores y nombres de tus categoría.")
                                    .foregroundStyle(.secondary)
                                    .minimumScaleFactor(0.3)
                            }.padding(.bottom, 10)
                        }
                        HStack{
                            Image(systemName: "camera.circle")
                                .font(.system(size: 30))
                                .foregroundStyle(Color(red: 249/255, green: 219/255, blue: 87/255))
                                .padding(.trailing, 10)
                            
                            VStack(alignment: .leading){
                                Text("Save Products")
                                    .font(.system(size: 20, design: .rounded).bold())
                                Text("Crea, etiqueta y asigna precios a tus artículos.")
                                    .foregroundStyle(.secondary)
                                    .minimumScaleFactor(0.3)
                            }
                        }.padding(.bottom, 10)
                        HStack{
                            Image(systemName: "map.circle")
                                .font(.system(size: 30))
                                .foregroundStyle(Color(red: 249/255, green: 219/255, blue: 87/255))
                                .padding(.trailing, 10)
                            
                            VStack(alignment: .leading){
                                Text("Create Routes")
                                    .font(.system(size: 20, design: .rounded).bold())
                                Text("Localiza y rastrea tus artículos en tiempo real, calcula distancias y traza rutas.")
                                    .foregroundStyle(.secondary)
                                    .minimumScaleFactor(0.3)
                                
                            }
                        }
                        
                    }.padding(.horizontal, 50)
                        .padding(.top, 300)
                        .minimumScaleFactor(0.5)
                        .offset(y: secondVStackOffset)
                        .opacity(secondVStackOpacity)
                        .animation(
                            Animation.easeInOut(duration: 0.3)
                                .repeatCount(0, autoreverses: true)
                                .delay(0)
                        )
                    Spacer()
                    VStack{
                        VStack{
                            Image(systemName: "figure.wave")
                                .renderingMode(.original)
                                .foregroundColor(.yellow)
                                .font(.system(size: 20))
                            
                            
                            Text("PicPoint collects your activity, which is not associated with your Apple ID, in order to improve and personalize. ")
                            
                                .font(.system(size: 11))
                                .foregroundStyle(.secondary)
                                .minimumScaleFactor(0.3)
                            
                            Button {
                                showDataManaged.toggle()
                            } label: {
                                Text("See how your data is managed...")
                                    .font(.system(size: 11))
                                    .foregroundStyle(Color(red: 249/255, green: 219/255, blue: 87/255))
                            }.sheet(isPresented: $showDataManaged, content: {
                                HowYourDataIsManaged()
                            })
                            
                        }.padding(.bottom,20)
                        
                        
                        
                        
                        Button("Continue"){
                            UserDefaults.standard.set(true, forKey: "hasShownOnboarding")
                            showOnboarding.toggle()
                        }.buttonStyle(.borderedProminent)
                            .tint(Color(red: 249/255, green: 219/255, blue: 87/255))
                            .foregroundColor(.primary)
                            .font(.system(size: 20, design: .rounded).bold())
                            .minimumScaleFactor(0.5)
                    }.padding(.horizontal, 70).minimumScaleFactor(0.5)
                        .offset(y: secondVStackOffset)
                        .opacity(secondVStackOpacity)
                        .animation(
                            Animation.easeInOut(duration: 0.5)
                                .repeatCount(0, autoreverses: true)
                                .delay(0)
                        )
                }
                
            }} else {
                
                NavigationLink("", destination: ContentView(), isActive: .constant(true))
                                .hidden()

            }
    }
}

#Preview {
    OnBoardingView()
}
