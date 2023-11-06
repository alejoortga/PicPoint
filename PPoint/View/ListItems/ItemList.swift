//
//  ItemList.swift
//  PPoint
//
//  Created by A on 8/21/23.
//

import SwiftUI
import SwiftData
import CoreLocation
import TipKit

struct ItemList: View {
    
    var categories : Category
    @Environment(\.modelContext) private var modelContext
    @State private var showAddItem = false
    @State private var searchText = ""
    var body: some View {
        List{
            
            
            Section {
                
                ForEach(filteredListItem, id: \.self){ item in
                    
                    NavigationLink(destination: detailProduct(item: item)){
                        ItemCategoryCard(item: item)
                    }.tint(.black)
                
                    
                    
                }.onDelete(perform: { indexSet in
                    categories.itemForCategory.remove(atOffsets: indexSet)
                })
            } header: {
                Text("Item in the list:\(categories.itemForCategory.count)")
            }

        }.overlay{
            if categories.itemForCategory.isEmpty{
                
                VStack{
                    TipView(PicPointItemTip(), arrowEdge: .top)
                    ContentUnavailableView {
                        
                        Label {
                            Text("No items")
                        } icon: {
                            Image(systemName: "globe")
                                .symbolRenderingMode(.hierarchical)
                                .foregroundStyle(.teal)
                            
                        }
                        
                    } description: {
                        Text("New items will appear here.")
                    }
                }
            }
        }
        
        .searchable(text: $searchText)
        .navigationTitle("List of \(categories.categoryName)")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar{
            ToolbarItem(placement: .topBarTrailing) {
                Button{
                    showAddItem.toggle()
                }label: {
                    Label{
                        Text("Add item")
                    } icon: {
                        Image(systemName: "plus.circle.fill")
                            .symbolRenderingMode(.hierarchical)
                            .foregroundStyle(.teal)
                            
                    }
                }
            }
        }.sheet(isPresented: $showAddItem){
            NavigationStack{
                CreCategoryItem(category: categories)
            }.presentationDetents([.large,.large])

        }
        
    }
    
    var filteredListItem : [ItemForCategory] {
        if searchText.isEmpty{
            return categories.itemForCategory
        }
        
        let itemName = categories.categoryName
        let filteredList = try? categories.itemForCategory.filter(#Predicate{item in
            item.productName.contains(searchText) && itemName == item.category?.categoryName
        })
        return filteredList ?? []
    }
    

}

#Preview {
    MainActor.assumeIsolated {
        let container = PreviewSampleData.container
        return Group {
            
            ItemList(categories: .preview)
                .modelContainer(container)
        }
    }
}
