//
//  CategoryCardView.swift
//  PPoint
//
//  Created by A. Ortega on 10/28/23.
//

import SwiftUI
import TipKit

struct CategoryCardView: View {
    
    @Environment(\.self) var environment
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    
    @State private var categoryName = ""
    @State private var emojiCategory = ""
    @State private var startDate = Date()
    
    @State private var colorSelected : Color = .white
    @State private var resolvedColor : Color.Resolved?
    
    @State private var red = 0.85490019608
    @State private var green = 0.8196078431
    @State private var blue = 0.6117647059
    @State private var opacity = 1.0
    
    //This part it says if both fields arent empty!
    var isButtonEnable : Bool {
        
        return !categoryName.isEmpty && !emojiCategory.isEmpty

    }
    
    
    var body: some View {
        ZStack{
            Color(colorSelected).ignoresSafeArea(.all)
            
            
            
            VStack{
                
                TipView(TipCreaCate(), arrowEdge: .bottom).padding(.horizontal,10)
                
                Circle().frame(height: 40).foregroundColor(.black).opacity(0.15).overlay{
                    TextField("🌻", text: $emojiCategory)
                        .font(.system(size: 27,design: .rounded).bold())
                        .multilineTextAlignment(.center)
                        .onChange(of: emojiCategory) {oldValue,  newValue in
                            if newValue.count > 1 {
                                emojiCategory = String(newValue.prefix(1))
                            }
                        }
                }
            
                
                TextField("Title", text: $categoryName)
                    .font(.system(size: 30, design: .rounded).bold())
                    .foregroundStyle(.primary)
                    .multilineTextAlignment(.center)
                
                HStack{
                    
                    ColorPicker("", selection: $colorSelected, supportsOpacity: false)
                    
                    
                }.onChange(of: colorSelected, initial: true, getColor)
                    .padding(.horizontal, 30)
            }
        }.foregroundStyle(.black)

        .toolbar{
            ToolbarItem(placement: .cancellationAction) {
                Button("Dismiss"){
                    dismiss()
                }.foregroundStyle(.red)
            }
            
            ToolbarItem(placement: .primaryAction) {
                
              
                
                Button("Done"){
                    let impact = UIImpactFeedbackGenerator(style: .heavy)
                    impact.impactOccurred()
                    addCategory()
                    dismiss()

                }.disabled(!isButtonEnable)

                
                
            }
        }
    }
    
    private func addCategory(){
        withAnimation {
            let newCategory = Category(categoryName: categoryName, emojiCategory: emojiCategory, startDate: startDate, red: red, green: green, blue: blue, opacity: opacity)
            modelContext.insert(newCategory)
        }
    }
    
    func getColor() {
        resolvedColor = colorSelected.resolve(in: environment)
        
        if let resolvedColor = resolvedColor {
            red = Double(resolvedColor.red)
            green = Double(resolvedColor.green)
            blue = Double(resolvedColor.blue)
            opacity = Double(resolvedColor.opacity)
        }
    }
    
    func simpleSuccess(){
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
}

#Preview {
    CategoryCardView()
}
