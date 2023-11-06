//
//  CreCategoryCard.swift
//  PPoint
//
//  Created by A on 8/21/23.
//

import SwiftUI

struct CreCategoryCard: View {
    
    @Environment(\.self) var environment
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    
    @State private var categoryName = ""
    @State private var emojiCategory = ""
    @State private var startDate = Date()
    
    @State private var colorSelected : Color = .teal
    @State private var resolvedColor : Color.Resolved?
    
    @State private var red = 1.0
    @State private var green = 0.1764705882
    @State private var blue = 0.3333333333
    @State private var opacity = 1.0
    
    //This part it says if both fields arent empty!
    var isButtonEnable : Bool {
        
        return !categoryName.isEmpty && !emojiCategory.isEmpty
    }
    
    
    var body: some View {
        Form {
            Section{
                VStack{
                    RoundedRectangle(cornerRadius: 0).frame(height: 150).foregroundColor(colorSelected).overlay{
                        
                       
                        RoundedRectangle(cornerRadius: 9).strokeBorder(.white, lineWidth: 2).padding(5)
                        
                        VStack{
                            
                            
                            HStack{
                                
                                
                                
                                Text(categoryName)
                                    .bold()
                                    .foregroundStyle(.white)
                                    .font(.system(size:30, design: .rounded).bold())
                                    .minimumScaleFactor(0.01)
                                    .multilineTextAlignment(.leading)
                                
                                Spacer()
                                
                                Circle().frame(height: 40).foregroundColor(.white).opacity(0.15).overlay{
                                    Text(emojiCategory)
                                        .font(.system(size: 21))
                                }
                            }
                            
                            Spacer()

                            Text("Your list is empty.")
                                .foregroundColor(.white)
                                .font(.system(size: 12.5))
                                .minimumScaleFactor(0.01)
                            
                            
                        }.padding()
                    }
                }.listRowInsets(EdgeInsets())
                
            } footer: {
                Text("Style of your card.")
                
            }
            Section(header: Text("Edit your card").bold()) {
                
                HStack{
                    Text("Category Title: ")
                        .font(.system(size: 15, design: .rounded))
                    TextField("Enter title here...", text: $categoryName)
                        .foregroundColor(.primary)
                        .textFieldStyle(.plain)
                        .multilineTextAlignment(.trailing)
                        .font(.system(size: 18, design: .rounded))
                }
                HStack{
                    Text("Category Emoji: ")
                        .font(.system(size: 15, design: .rounded))
                    TextField("Select your emoji", text: $emojiCategory)
                        .font(.system(size: 18, design: .rounded))
                        .onChange(of: emojiCategory) {oldValue,  newValue in
                            if newValue.count > 1 {
                                emojiCategory = String(newValue.prefix(1))
                            }
                        }
                    
                        .multilineTextAlignment(.trailing)
                    
                }
                
            }
            
            Section(header: Text("Color of your cards").bold()) {
                
                HStack{
                    Text("Choose a color:")
                        .font(.system(size: 15, design: .rounded))
                    
                    ColorPicker("", selection: $colorSelected, supportsOpacity: false)
                    
                    
                }.onChange(of: colorSelected, initial: true, getColor)
                
            }
            
        }
        
        .navigationTitle("Create Category")
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
    CreCategoryCard()
}
