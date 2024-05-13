// CreateTransactionView.swift
// Finances Helper
//
// Created by Kendrick on 10/05/24.

import SwiftUI

// SwiftUI view for creating a new transaction
struct CreateTransactionView: View {
    @Environment(\.dismiss) private var dismiss // Environment variable to dismiss the view
    let type: TransactionType // Type of transaction (income or expense)
    @ObservedObject var rootVM: RootViewModel // View model for the root view
    @StateObject private var viewModel: CreateTransactionViewModel // View model for creating transactions
    
    // Initialize the view with the provided transaction type and view model
    init(type: TransactionType, rootVM: RootViewModel) {
        self.type = type
        self._rootVM = ObservedObject(wrappedValue: rootVM)
        self._viewModel = StateObject(wrappedValue: CreateTransactionViewModel(context: rootVM.coreDataManager.mainContext, transactionType: rootVM.currentTab))
    }
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 32) {
                    dateButton // Date picker button
                    amountTextField // Text field for entering the amount
                    noteTextField // Text field for entering the note
                    CategoriesTagsView(createVM: viewModel) // View for selecting categories
                }
                .padding()
            }
            .navigationTitle("New " + type.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                // Cancel button
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                    }
                }
                
                // Save button
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        if let account = rootVM.activeAccount {
                            viewModel.create(type: type, date: viewModel.date, forAccount: account, created: rootVM.userService.currentUser)
                        }
                        dismiss()
                    } label: {
                        Text("Save")
                    }
                    .disabled(viewModel.disabledSave)
                }
            }
            .overlay {
                createCategoryView // Overlay view for creating a new category
            }
        }
        .preferredColorScheme(.light)
    }
}

// Preview provider for CreateTransactionView
struct CreateTransactionView_Previews: PreviewProvider {
    static var previews: some View {
        CreateTransactionView(type: .income, rootVM: RootViewModel(context: dev.viewContext))
    }
}

// Extension to CreateTransactionView for private functions
extension CreateTransactionView {
    // Date picker button
    private var dateButton: some View {
        DatePicker(selection: $viewModel.date, displayedComponents: .date) {}
            .labelsHidden()
            .hLeading()
    }
    
    // Text field for entering the amount
    private var amountTextField: some View {
        HStack {
            NumberTextField(value: $viewModel.amount, promt: "", label: nil)
            Text(rootVM.activeAccount?.currencyCode ?? "USD")
                .font(.title3)
        }
    }
    
    // Text field for entering the note
    private var noteTextField: some View {
        VStack {
            TextField("Note", text: $viewModel.note)
                .font(.title3.weight(.medium))
            Divider()
        }
    }
    
    // Overlay view for creating a new category
    private var createCategoryView: some View {
        Group {
            if let type = viewModel.createCategoryViewType {
                Color.secondary.opacity(0.3).ignoresSafeArea()
                    .onTapGesture {
                        viewModel.createCategoryViewType = nil
                    }
                CreateCategoryView(viewType: type, rootVM: rootVM, createVM: viewModel)
                    .padding()
            }
        }
        .animation(.easeInOut, value: viewModel.createCategoryViewType)
    }
}
