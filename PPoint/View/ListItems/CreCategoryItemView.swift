//
//  CreCategoryItemView.swift
//  PPoint
//
//  Created by A. Ortega on 10/29/23.
//

import SwiftUI
import Combine
import PhotosUI
import SwiftData

struct CreCategoryItemView: View {
    
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
                            } icon: {
                                Image(systemName: "photo.circle")
                                    .symbolRenderingMode(.hierarchical)
                                    .foregroundStyle(.teal)}
                        } description: {
                            Text("Image selected will appear here.")
                        }
                        
                    }
                }.listRowInsets(EdgeInsets())      
            }
            Section{
                HStack{
                    PhotosPicker(selection: $selectedPhoto,matching: .images,photoLibrary:.shared()) {
                        Label("Gallery", systemImage: "photo")
                            .foregroundStyle(.black)
                    }.photosPickerStyle(.presentation)
                }
                
                
                
                Button {
                    showCamera.toggle()
                } label: {
                    Label {
                        Text("Camera")
                            .foregroundStyle(.black)
                    } icon: {
                        Image(systemName: "camera")
                            .foregroundStyle(.black)
                    }.fullScreenCover(isPresented: $showCamera, content: {
                        CameraView(selectedImage: $selectedImage)
                            .presentationCornerRadius(30)
                            .ignoresSafeArea(.all)
                    })

                }
                
                VStack{
                    TextField("Title", text: $productName)
                        .font(.system(size: 30, design: .rounded).bold())
                        .multilineTextAlignment(.center)
                        .minimumScaleFactor(1.0)

                    
                    TextField("Price", text: $productPrice)
                    .font(.system(size: 30, design: .rounded).bold())
                    .foregroundStyle(.green)
                    .multilineTextAlignment(.center)
                    .minimumScaleFactor(.greatestFiniteMagnitude)
                    .keyboardType(.asciiCapableNumberPad)
                }
                
            }
            
            
            
            
            
            
//            Section {
//
//                
//                VStack{
//                    TextField("Title", text: $productName)
//                        .font(.system(size: 30, design: .rounded).bold())
//                        .multilineTextAlignment(.center)
//
//                    
//                    TextField("Price", text: $productPrice)
//                    .font(.system(size: 30, design: .rounded).bold())
//                    .foregroundStyle(.green)
//                    .multilineTextAlignment(.center)
//                }
//                
//            }
                        
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
            CreCategoryItemView(category: Category.preview)
                .modelContainer(container)
        }
    }
}
