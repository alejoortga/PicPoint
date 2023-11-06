//
//  CreCategoryItem.swift
//  PPoint
//
//  Created by A on 8/27/23.
//

import SwiftUI
import Combine
import PhotosUI
import SwiftData


struct CreCategoryItem: View {
    
    var category : Category
    
    
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    //add information for the item.
    
    @State private var productPrice = ""
    @State private var productName = ""
    @State private var show = false
    @State private var latitude = 0.0
    @State private var longitude = 0.0
    
    @StateObject var locationDataManager = LocationManager()
    
    //Photos
    @State var selectedPhoto : PhotosPickerItem?
    @State var seletedPhotoData : Data?
    @State var selectedImage : UIImage?
    
    
    //Camera
    @State private var showCamera = false
    
    
    var isButtonEnable : Bool {
        
        return !productName.isEmpty && !productPrice.isEmpty
    }
    
    var body: some View {
        
        Form {
            Section {
                
                
                HStack(alignment: .top){
                    
                    VStack{
                        RoundedRectangle(cornerRadius: 10).aspectRatio(contentMode: .fit).foregroundStyle(.clear)
                    }
                    
                }.background{
                    
                    if let seletedPhotoData, let uiImage = UIImage(data: seletedPhotoData){
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                    }
                    else {
                        
                        ContentUnavailableView {
                            Label {
                                Text("No images selected yet")
                                    .font(.system(size:25, design: .rounded).bold())
                            } icon: {
                                Image(systemName: "photo.circle")
                                    .symbolRenderingMode(.hierarchical)
                                    .foregroundStyle(.teal)}
                        } description: {
                            Text("Image selected will appear here.")
                                .font(.system(size:15, design: .rounded))
                        }
                        
                    }
            
                    
                }.listRowInsets(EdgeInsets())
                PhotosPicker(selection: $selectedPhoto,matching: .images,photoLibrary:.shared()) {
                    Label("Gallery", systemImage: "photo")
                        .foregroundStyle(.primary)
                        .font(.system(size:15, design: .rounded).bold())
                }.photosPickerStyle(.presentation)
                    
                
                
                Button {
                    showCamera.toggle()
                } label: {
                    Label {
                        Text("Camera")
                            .font(.system(size:15, design: .rounded).bold())
                    } icon: {
                        Image(systemName: "camera")
                            .font(.system(size:15, design: .rounded).bold())
                            .foregroundStyle(.primary)
                    }.fullScreenCover(isPresented: $showCamera, content: {
                        CameraView(selectedImage: $selectedImage)
                            .presentationCornerRadius(30)
                            .ignoresSafeArea(.all)
                    })

                }

            } header: {
                Text("Image").bold()
            } footer: {
                Text("Image of your product")
            }
            
            Section {
                HStack{
                    Text("Product Name")
                        .font(.system(size: 15, design: .rounded).bold())
                    TextField("Title", text: $productName)
                        .foregroundColor(.primary)
                        .textFieldStyle(.plain)
                        .multilineTextAlignment(.trailing)
                        .font(.system(size: 18, design: .rounded).bold())
                    
                }
                HStack{
                    Text("Product Price")
                        .font(.system(size: 15, design: .rounded).bold())
                    TextField("Price", text: $productPrice)
                        .font(.system(size: 18, design: .rounded).bold())
                        .multilineTextAlignment(.trailing)
                        .keyboardType(.numbersAndPunctuation)
                        .foregroundStyle(.green)
                        .onReceive(Just(productPrice)){ newValue in
                            
                            let filtered = newValue.filter { "0123456789".contains($0)}
                            if filtered != newValue{
                                self.productPrice = filtered
                            }
                        }
                        .textFieldStyle(.plain)
                }
            } header: {
                Text("Add your item").bold()
            }
                        
        }.task(id: selectedPhoto) {
            if let data = try? await selectedPhoto?.loadTransferable(type: Data.self){
                seletedPhotoData = data
                
            }
        }
        
        .task(id: selectedImage) {
            if let image = selectedImage,
               let data = image.jpegData(compressionQuality: 0.8){
                seletedPhotoData = data
            }
        }
        
        .onChange(of: locationDataManager.locationManager.location?.coordinate.latitude.description){ oldValue, newValue in
            
            if let latitudeString = newValue, let latitude = Double(latitudeString){
                
                self.latitude = latitude
            }
            
        }
        
        
        .onChange(of: locationDataManager.locationManager.location?.coordinate.longitude.description){ oldValue, newValue in
            
            if let longitudString = newValue, let longitude = Double(longitudString){
                
                self.longitude = longitude
            }
            
        }
        
        
        .navigationTitle("Add Item")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar{
                ToolbarItem(placement: .cancellationAction) {
                    Button("Dismiss"){
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .primaryAction){
                    Button("Done"){
                        addItem()
                        dismiss()
                    }.disabled(!isButtonEnable)
                }
            }
    }
    
    private func addItem(){
        withAnimation {
            
            var imageData : Data?
            
            imageData = seletedPhotoData
            
            let newItem = ItemForCategory(productName: productName, productPrice: productPrice, productDescription: "Test", latitude: latitude, longitude: longitude, image: imageData)
            
            modelContext.insert(newItem)
            newItem.category = category
            category.itemForCategory.append(newItem)
        }
    }
    
    
}


#Preview {
    MainActor.assumeIsolated {
        let container = PreviewSampleData.container
        
        return Group {
            CreCategoryItem(category: Category.preview)
                .modelContainer(container)
        }
    }
}
