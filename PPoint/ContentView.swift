//
//  ContentView.swift
//  PPoint
//
//  Created by A on 8/21/23.
//

import SwiftUI
import SwiftData
import CoreLocation
import TipKit



struct ContentView: View {
    
    @Environment(\.modelContext) private var modelContext
    
    @Query(sort: \Category.startDate, order: .reverse)
    
    
    var category: [Category]
    
    
    @State private var showAddCategory = false
    @State private var selection : Category?
    @State private var path : [Category] = []
    @State private var editCard = false
    
    private let adaptativeColumns = [GridItem(.adaptive(minimum: 170))]
    
    @State private var showPlash = true
    
    @ObservedObject private var locationManagerActualLocation = LocationManager()
    
    @State private var isAppOpening = true
    
    
    
    var body: some View {
        
        ZStack{
            
            if isAppOpening {
                OpenningApp()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            withAnimation {
                                self.isAppOpening = false
                            }
                        }
                    }
            } else {
            
            NavigationStack{
                ScrollView{
                    VStack{
                        Grid{
                            LazyVGrid(columns: adaptativeColumns, spacing: 8){
                                ForEach(category){ categories in
                                    
                                    
                                    NavigationLink(destination: ItemList(categories: categories)){
                                        CategoryCard(category: categories)
                                            .frame(height: 100)
                                            .contextMenu(ContextMenu(menuItems: {
                                                
                                                Button(action: {
                                                    editCard = true
                                                    selection = categories
                                                }, label: {
                                                    
                                                    Text("Edit")
                                                    Image(systemName: "pencil")
                                                    
                                                })
                                                
                                                Button(role: .destructive) {
                                                    deleteCategory(categories)
                                                } label: {
                                                    Text("Remove")
                                                    Image(systemName: "trash")
                                                }
                                                
                                                
                                                
                                            }))
                                            .sheet(isPresented: Binding(
                                                get: { editCard },
                                                set: { editCard = $0 }
                                            )) {
                                                if let selectedCategory = selection{
                                                    NavigationStack{
                                                        UpdCategoryCard(category: selectedCategory) .presentationBackground(.ultraThinMaterial)
                                                            .presentationCornerRadius(30)
                                                    }
                                                }
                                            }
                                    }.buttonStyle(.plain)
                                }.onDelete(perform: deleteCategories(at:))
                            }
                        }
                    }.padding(.horizontal, 20)
                    
                }
                
                .overlay {
                    
                    
                    
                    if category.isEmpty{
                        
                        VStack{
                            
                            
                            ContentUnavailableView {
                                Label {
                                    Text("No categories")
                                } icon: {
                                    Image(systemName: "location.circle")
                                        .symbolRenderingMode(.hierarchical)
                                    .foregroundStyle(.teal)}
                            } description: {
                                Text("New categories will appear here.")
                            }
                            
                            TipView(PicPointTip(), arrowEdge: .bottom).padding(.horizontal, 10)
                            
                        }
                        
                        
                    }
                }
                .navigationTitle("Categories")
                .toolbar{
                    ToolbarItem(placement: .bottomBar){
                        
                        HStack{
                            Button{
                                showAddCategory = true
                            }label: {
                                HStack {
                                    Image(systemName: "plus.circle.fill")
                                    Text("Add Category")
                                        .font(.system(.body, design: .rounded).bold())
                                }
                                
                                
                                
                            }
                            Spacer()
                        }
                        .buttonStyle(.plain)
                        
                    }
                }
                
                
                .sheet(isPresented: $showAddCategory){
                    NavigationStack{
                        CategoryCardView()
                    }.presentationDetents([.height(320),.height(320)])
                        .presentationBackground(.clear)
                        .cornerRadius(20)
                        .padding(.horizontal, 10)
                }
            }
            
        }
        }.onAppear{
            DispatchQueue.main.asyncAfter(deadline: .now() + 2)
            {
                withAnimation {
                    self.showPlash = false
                }
            }
        }
        
        
        
        
    }
    
    private func deleteCategories(at offsets : IndexSet){
        withAnimation {
            offsets.map{ category[$0]}.forEach(deleteCategory)
        }
    }
    private func deleteCategory(_ category : Category) {
        
        if category.categoryName == selection?.categoryName{
            selection = nil
        }
        modelContext.delete(category)
    }
    
}

#Preview {
    ContentView()
        .modelContainer(PreviewSampleData.container)
}
