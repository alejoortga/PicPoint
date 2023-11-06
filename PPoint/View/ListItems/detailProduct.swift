//
//  detailProduct.swift
//  PPoint
//
//  Created by A. Ortega on 11/5/23.
//

import SwiftUI

struct detailProduct: View {
    
    var item : ItemForCategory
    @State private var openRoute = false
    @State private var showEditCategory = false
    
    @State private var scale: CGFloat = 1
    @State private var opacity: Double = 1
    
    var body: some View {
        ZStack{
            Color(.systemGroupedBackground).ignoresSafeArea(.all)


            VStack{
                
                Form{
                    Section {
                        HStack(alignment: .top){
                            
                            VStack{
                                RoundedRectangle(cornerRadius: 10).aspectRatio(contentMode: .fit).foregroundStyle(.clear)
                            }
                            
                        }.background{
                            ZStack{
                                if let selectedPhotoData = item.image, let uiImage = UIImage(data: selectedPhotoData){
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                }else {
                                    Image("botero")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                }
                            }
                        }.listRowInsets(EdgeInsets())
                        
                    }
                }
               
                Spacer()
            
                    
                    VStack{
                        Text(item.productName)
                            .font(.system(size: 30, design: .rounded).bold())
                            .minimumScaleFactor(0.5)
                        Text("$\(item.productPrice)")
                            .foregroundStyle(.green)
                            .font(.system(size: 20, design: .rounded).bold())
                            .minimumScaleFactor(0.5)
                    }
                    
                    
                    Button(action: {
                        self.openRoute.toggle()
                    }, label: {
                        ZStack{

                            Circle()
                                .frame(maxWidth: 100)
                                .opacity(0.5)
                                .scaleEffect(scale)
                                .onAppear {
                                    withAnimation(Animation.easeInOut(duration: 1).repeatForever(autoreverses: true)) {
                                        scale = 0.8
                                    }
                                }
                            
                            ZStack{
                                Circle()
                                    .frame(maxWidth: 75)
                                
                                Image(systemName: "map.fill")
                                    .foregroundStyle(.white)
                                    .font(.system(size: 30))
                            }
                        }.foregroundStyle(.green)
                            .padding(.bottom,20 )
                    }).sheet(isPresented: $openRoute){
                        routeItem(item: item)
                        
                    }
                    
                

            }
        }.toolbar{
                ToolbarItem(placement: .topBarTrailing){
                    
                    HStack{
                        Button{
                            showEditCategory.toggle()
                        }label: {
                            Image(systemName: "pencil")
                                .foregroundColor(.primary)
                        }

                    }

                   
                }
            }.sheet(isPresented: $showEditCategory, content: {
                NavigationStack{
                    UpdItemCategory(item: item)
                }
            })
    }
}

#Preview {
    MainActor.assumeIsolated {
        let container = PreviewSampleData.container
        return Group {
            detailProduct(item: ItemForCategory.preview)
                .modelContainer(container)
        }
    }
}
