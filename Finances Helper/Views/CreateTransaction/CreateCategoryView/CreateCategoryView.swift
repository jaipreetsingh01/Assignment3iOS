// CreateCategoryView.swift
// Finances Helper
//
// Created by Kendrick on 10/05/24.

import SwiftUI

// SwiftUI view for creating or editing a category
struct CreateCategoryView: View {
    let viewType: CreateCategoryViewType // Type of view (new or edit category)
    @ObservedObject var rootVM: RootViewModel // View model for the root view
    @ObservedObject var createVM: CreateTransactionViewModel // View model for creating transactions
    @State var colors = (1...10).map({_ in Color.random}) // Array of random colors for category selection
    @FocusState private var isFocused: Bool // State to manage focus of text field
    
    var body: some View {
        VStack(spacing: 32) {
            headerView // Header view with title and action buttons
            VStack {
                TextField("Title", text: $createVM.categoryTitle) // Text field for entering category title
                    .focused($isFocused) // Set focus on text field
                Divider() // Divider below text field
            }
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack {
                    // Display circles with color options for category
                    ForEach(colors, id: \.self) { color in
                        Circle()
                            .fill(color)
                            .frame(width: 30, height: 30)
                            .scaleEffect(color == createVM.categoryColor ? 1.2 : 1) // Scale effect for selected color
                            .opacity(color == createVM.categoryColor ? 1 : 0.5) // Opacity for selected color
                            .onTapGesture {
                                createVM.categoryColor = color // Update selected color
                            }
                    }
                }
                .padding(.horizontal, 16)
            }
            .frame(height: 50)
            .padding(.horizontal, -16)
            .onAppear {
                if let color = colors.first {
                    createVM.categoryColor = color // Set default color for category
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.02) {
                    isFocused = true // Set focus on text field after appearance
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5) // Add shadow to the view
    }
}

// Preview provider for CreateCategoryView
struct CreateCategoryView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.secondary
            CreateCategoryView(viewType: .new(isSub: true), rootVM: RootViewModel(context: dev.viewContext), createVM: CreateTransactionViewModel(context: dev.viewContext, transactionType: .expense))
                .padding()
        }
    }
}

// Extension to CreateCategoryView for private functions
extension CreateCategoryView {
    
    // Header view with title and action buttons
    private var headerView: some View {
        HStack {
            Button {
                isFocused = false
                createVM.createCategoryViewType = nil // Dismiss the view
            } label: {
                Image(systemName: "xmark") // Close button
            }
            Spacer()
            Text(viewType.navTitle) // Title based on view type (new or edit)
                .font(.headline.bold())
            Spacer()
            Button {
                isFocused = false
                switch viewType {
                case .new(let isSubcategory):
                    if isSubcategory {
                        createVM.addSubcategory() // Add new subcategory
                    } else {
                        createVM.addCategory() // Add new category
                    }
                case .edit:
                    break // No action for editing category
                }
            } label: {
                Image(systemName: "checkmark") // Confirm button
            }
            .disabled(createVM.categoryTitle.isEmpty) // Disable if category title is empty
        }
    }
}

// Enum defining the type of CreateCategoryView
enum CreateCategoryViewType: Identifiable, Equatable {
    
    case new(isSub: Bool) // New category or subcategory
    case edit(isSub: Bool, CategoryEntity) // Edit category or subcategory
    
    var id: Int {
        switch self {
        case .new:
            return 0
        case .edit:
            return 1
        }
    }
    
    var navTitle: String {
        switch self {
        case .new(let isSub):
            return "New \(isSub ? "subcategory" : "category")" // Title for new category or subcategory
        case .edit(let isSub, _):
            return "Edit \(isSub ? "subcategory" : "category")" // Title for editing category or subcategory
        }
    }
}
