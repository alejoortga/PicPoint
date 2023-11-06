//
//  detailProductItem.swift
//  PPoint
//
//  Created by A on 8/27/23.
//

import SwiftUI

struct detailProductItem: View {
    
    var item : ItemForCategory
    @State private var openRoute = false
    @State private var showEditCategory = false
    
    var body: some View {
        ZStack{
            ZStack{
                if let selectedPhotoData = item.image, let uiImage = UIImage(data: selectedPhotoData){
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: UIScreen.main.bounds.width)
                        .clipped()
                        .ignoresSafeArea(.all)
                }else {
                    Image("botero")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: UIScreen.main.bounds.width)
                        .clipped()
                        .ignoresSafeArea(.all)
                }
                
            }
            
            .safeAreaInset(edge: .bottom) {
                
                HStack{
                    
                    VStack{
                        Spacer()
                        
                        HStack{
                            
                            VStack(alignment : .leading){
                                
                                Button(action: {
                                    self.openRoute.toggle()
                                }, label: {
                                    RoundedRectangle(cornerRadius: 15).frame(width: 60, height: 60).foregroundColor(.white).overlay{
                                        
                                        
                                        VStack{
                                            
                                            Image(systemName: "mappin.and.ellipse.circle.fill")
                                                .foregroundColor(.green)
                                                .font(.system(size: 40, design: .rounded))
                                                .minimumScaleFactor(0.01)
                                            
                                        }
                                    }
                                    
                                })
                                .sheet(isPresented: $openRoute){
                                    routeItem(item: item)

                                }
                                
                            }
                            VStack(alignment: .leading){
                                
                                Text(item.productName)
                                    .font(.system(.title, design: .rounded)).bold()
                                    .padding(.horizontal, 10)
                                
                                HStack{
                                    Text("$\(item.productPrice)")
                                        .font(.system(size: 13, design: .rounded))
                                        .foregroundStyle(.green).bold()
                                        .padding(.horizontal, 10)

                                    Spacer()
                                }
                            }
                        }.foregroundColor(.black)
                            .padding(.horizontal)
                            .frame(height: 90)
                            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 20))
                            .padding(.horizontal,30)
                    }
                    
                }
            }
        }

        
    }
}


#Preview {
    MainActor.assumeIsolated {
        let container = PreviewSampleData.container
        
        return Group {
            detailProductItem(item: ItemForCategory.preview)
                .modelContainer(container)
        }
    }
}
