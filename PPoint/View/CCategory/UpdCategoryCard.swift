//
//  UpdCategoryCard.swift
//  PPoint
//
//  Created by A on 8/21/23.
//

import SwiftUI

struct UpdCategoryCard: View {
    
    var category : Category
    
    @Environment(\.self) var environment
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var categoryName = ""
    @State private var emojiCategory = ""
    @State private var startDate = Date()
    
    @State private var colorSelected : Color = .pink
    @State private var resolvedColor : Color.Resolved?
    
    @State private var red = 1.0
    @State private var green = 0.1764705882
    @State private var blue = 0.3333333333
    @State private var opacity = 1.0

    
    var body: some View {
        Form {
            Section {
                HStack{
                    Text("Category Tittle:")
                        .font(.system(size: 15, design: .rounded))
                    TextField(category.categoryName.isEmpty ? "Enter title here..." : category.categoryName, text: $categoryName)
                        .font(.system(size: 18, design: .rounded))
                        .foregroundColor(.primary)
                        .textFieldStyle(.plain)
                        .multilineTextAlignment(.trailing)
                    
                }
                HStack{
                    Text("Category Emoji : ")
                        .font(.system(size: 15, design: .rounded))
                    TextField(category.emojiCategory.isEmpty ? "Select your emoji..." : category.emojiCategory, text: $emojiCategory)                        .onChange(of: emojiCategory) {oldValue,  newValue in
                        if newValue.count > 1 {
                            emojiCategory = String(newValue.prefix(1))
                        }
                    }
                    .textFieldStyle(.plain)
                    .multilineTextAlignment(.trailing)

                }
            } header: {
                Text("Edit your card").bold()
            }
            Section{
                HStack{
                    Text("Change color")
                        .font(.system(size: 15, design: .rounded))
                    ColorPicker("", selection: $colorSelected, supportsOpacity: false)
                }.onChange(of: colorSelected, initial: true, getColor)
                    .onAppear{
                        colorSelected = Color(red: category.red, green: category.green, blue: category.blue)
                    }
            } header: {
                Text("Edit the color of your card").bold()
            }
        }.navigationTitle("Update Card")
            .toolbar{
                ToolbarItem(placement: .cancellationAction) {
                    Button("Dismiss"){
                        dismiss()
                    }
                }
                ToolbarItem(placement: .primaryAction) {
                    Button("Done"){
                        let impact = UIImpactFeedbackGenerator(style: .heavy)
                        impact.impactOccurred()
                        getColor()
                        updateCategory()
                        
                        dismiss()

                    }
                }
            }
    }
    
    private func updateCategory(){
        if !categoryName.isEmpty{
            category.categoryName = categoryName
        }
        
        if !emojiCategory.isEmpty{
            category.emojiCategory = emojiCategory
        }
        
        if !red.description.isEmpty && !green.description.isEmpty && !blue.description.isEmpty && !opacity.description.isEmpty{
            category.red = red
            category.blue = blue
            category.green = green
            category.opacity = opacity
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
    MainActor.assumeIsolated {
        let container = PreviewSampleData.container
        
        return Group {
            UpdCategoryCard(category: Category.preview)
                .modelContainer(container)
        }
    }
}
