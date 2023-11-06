//
//  CategoryCard.swift
//  PPoint
//
//  Created by A on 8/21/23.
//

import SwiftUI
import SwiftData

struct CategoryCard: View {
    
    let size = 200.0
    @State private var rotationAngle: Angle = .degrees(0)
    
    var category : Category
    var body: some View {

        ZStack{
            RoundedRectangle(cornerRadius: 15).fill(Color(red: category.red, green: category.green, blue: category.blue, opacity: category.opacity)).overlay{
                
                ZStack{
                    RoundedRectangle(cornerRadius: 13).strokeBorder(.white, lineWidth: 2).padding(5).overlay{
                        
                        ZStack{
                            Ellipse()
                                .frame(width: size, height: size * 0.4)
                                .foregroundColor(Color(red: category.red + 0.23, green: category.green + 0.10, blue: category.blue + 0.0, opacity: category.opacity))
                                .offset(x: -size * 0.2)
                                .rotationEffect(rotationAngle)
                                .cornerRadius(55)
                                .clipped()
                            Circle()
                                .frame(width: size, height: size * 0.2)
                                .foregroundColor(.black)
                                .offset(x: size * -0.4, y: size * 0.1)
                                .rotationEffect(rotationAngle)
                                .cornerRadius(50)
                                .clipped()
                            
                            Circle()
                                .frame(width: size, height: size * 0.2)
                                .foregroundColor(Color(red: category.red + 0.323, green: category.green + 0.315, blue: category.blue + 0.23, opacity: category.opacity))
                                .offset(x: size * -0.4, y: size * -0.1)
                                .rotationEffect(rotationAngle)
                                .cornerRadius(50)
                                .clipped()
                            
                            
                            Circle()
                                .frame(width: size, height: size * 0.3)
                                .foregroundColor(Color(red: category.red + 0.323, green: category.green + 0.315, blue: category.blue + 0.23, opacity: category.opacity))
                                .offset(x: size * -0.1)
                                .rotationEffect(rotationAngle)
                                .clipped()
                            
                            Ellipse()
                                .frame(width: size, height: size * 0.1)
                                .foregroundColor(.primary)
                                .offset(x: size * 0.2)
                                .rotationEffect(rotationAngle)
                                .cornerRadius(50)
                                .clipped()
                            
                            Circle()
                                .frame(width: size, height: size * 0.2)
                                .foregroundColor(.black)
                                .offset(x: size * 0.1, y: size * 0.2)
                                .rotationEffect(rotationAngle)
                                .cornerRadius(50)
                                .clipped()
                            
                            Circle()
                                .frame(width: 30)
                                .foregroundStyle(.primary)
                                .offset(x: size * 0.3)
                                .rotationEffect(rotationAngle)
                                
                            
                        }.blur(radius: 30.0)
                    }
                    
                    
                    VStack{
                        HStack{
                            Text(category.categoryName)
                                .font(.system(size: 30, design: .rounded)).fontWeight(.black)
                                .foregroundStyle(.primary)
                                .minimumScaleFactor(0.01)
                                .multilineTextAlignment(.leading)
                                .opacity(0.75)
                            
                            Spacer()
                            
                            Circle().frame(height: 40).opacity(0.15).overlay{
                                Text(category.emojiCategory)
                                    .font(.system(size: 22))
                            }.foregroundColor(.primary)
                        }
                        
                        Spacer()
                        
                        if category.itemForCategory.isEmpty{
                            Text("Your list is empty")
                                .foregroundStyle(.white)
                                .font(.system(size: 12.5, design: .rounded).bold())
                                .minimumScaleFactor(0.01)
                        }else {
                            Text("Qty: \(category.itemForCategory.count)")
                                .foregroundColor(.white)
                                .font(.system(size: 12.5, design: .rounded).bold())
                                .minimumScaleFactor(0.01)
                        }
                    }.padding()
                }
            }
        }.clipped()
            .cornerRadius(15)
            .onAppear {
                withAnimation(Animation.linear(duration: 20).repeatForever()) {

                    self.rotationAngle = .degrees(1000)
                }
            }
    }
    
}

#Preview {
    MainActor.assumeIsolated {
        let container = PreviewSampleData.container
        
        return Group {
            CategoryCard(category: Category.preview)
                .modelContainer(container)
        }
    }
}
