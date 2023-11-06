//
//  UpdItemCategory.swift
//  PPoint
//
//  Created by A. Ortega on 9/27/23.
//

import SwiftUI
import Combine

struct UpdItemCategory: View {
    
    var item : ItemForCategory
    
    @Environment(\.self) var environment
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var productPrice = ""
    @State private var productName = ""
    @State private var show = false
    
    
    
    
    var body: some View {
        Form{
            Section {
                HStack{
                    Text("Product Name")
                        .font(.system(size: 15, design: .rounded))
                    TextField(item.productName.isEmpty ? "Enter title here": item.productName, text: $productName)
                        .foregroundColor(.primary)
                        .textFieldStyle(.plain)
                        .multilineTextAlignment(.trailing)
                        .font(.system(size: 18, design: .rounded))
                    
                }
                HStack{
                    Text("Product Price")
                        .font(.system(size: 15, design: .rounded))
                    TextField(item.productPrice.isEmpty ? "Enter price here": item.productPrice, text: $productPrice)
                        .font(.system(size: 18, design: .rounded))
                        .multilineTextAlignment(.trailing)
                        .keyboardType(.numberPad)
                        .onReceive(Just(productPrice)){ newValue in
                            
                            let filtered = newValue.filter { "0123456789".contains($0)}
                            if filtered != newValue{
                                self.productPrice = filtered
                            }
                        }
                        .textFieldStyle(.plain)
                }
            } header: {
                Text("Edit your item").bold()
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
                        updateItem()
                        dismiss()

                    }
                }
            }

        

        
    }
    
    func updateItem(){
        if !productName.isEmpty{
            item.productName = productName
        }
        
        if !productPrice.isEmpty{
            item.productPrice = productPrice
        }
    }
}

#Preview {
    MainActor.assumeIsolated {
        let container = PreviewSampleData.container
        
        return Group {
            UpdItemCategory(item: ItemForCategory.preview)
                .modelContainer(container)
        }
    }
}
