//
//  FilterView.swift
//  NewYearSPB
//
//

import SwiftUI

struct FilterView: View {
    @ObservedObject var viewModel: EventsViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var tempSelectedEventTypes: Set<EventType> = []
    @State private var tempSelectedAgeCategory: AgeCategory = .all
    @State private var tempSelectedPriceCategories: Set<PriceCategory> = []
    
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        // Event Type filters
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Тип мероприятия")
                                .font(.headline)
                            
                            FlowLayout(spacing: 8) {
                                ForEach(EventType.allCases, id: \.self) { type in
                                    FilterChip(
                                        title: type.rawValue,
                                        isSelected: tempSelectedEventTypes.contains(type),
                                        action: {
                                            if tempSelectedEventTypes.contains(type) {
                                                tempSelectedEventTypes.remove(type)
                                            } else {
                                                tempSelectedEventTypes.insert(type)
                                            }
                                        }
                                    )
                                }
                            }
                        }
                        .padding(.horizontal)
                        
                        // Age Category filters
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Возрастная категория")
                                .font(.headline)
                            
                            FlowLayout(spacing: 8) {
                                ForEach(AgeCategory.allCases) { category in
                                    FilterChip(
                                        title: category.rawValue,
                                        isSelected: tempSelectedAgeCategory == category,
                                        action: {
                                            tempSelectedAgeCategory = category
                                        }
                                    )
                                }
                            }
                        }
                        .padding(.horizontal)
                        
                        // Price Category filters
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Цена")
                                .font(.headline)
                            
                            FlowLayout(spacing: 8) {
                                ForEach(PriceCategory.allCases, id: \.self) { category in
                                    FilterChip(
                                        title: category.rawValue,
                                        subtitle: category.description,
                                        isSelected: tempSelectedPriceCategories.contains(category),
                                        action: {
                                            if tempSelectedPriceCategories.contains(category) {
                                                tempSelectedPriceCategories.remove(category)
                                            } else {
                                                tempSelectedPriceCategories.insert(category)
                                            }
                                        }
                                    )
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.vertical)
                }
                
                // Bottom buttons
                HStack {
                    Button(action: {
                        tempSelectedEventTypes = []
                        tempSelectedAgeCategory = .all
                        tempSelectedPriceCategories = []
                    }) {
                        Text("Сбросить")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                            .foregroundColor(.primary)
                    }
                    
                    Button(action: {
                        viewModel.selectedEventTypes = tempSelectedEventTypes
                        viewModel.selectedAgeCategory = tempSelectedAgeCategory
                        viewModel.selectedPriceCategories = tempSelectedPriceCategories
                        viewModel.applyFilters()
                        dismiss()
                    }) {
                        Text("Применить")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                            .foregroundColor(.white)
                    }
                }
                .padding()
            }
            .navigationTitle("Фильтры")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark")
                    }
                }
            }
            .onAppear {
                tempSelectedEventTypes = viewModel.selectedEventTypes
                tempSelectedAgeCategory = viewModel.selectedAgeCategory
                tempSelectedPriceCategories = viewModel.selectedPriceCategories
            }
        }
    }
}

struct FilterChip: View {
    let title: String
    var subtitle: String? = nil
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack {
                Text(title)
                    .font(.system(size: 14))
                    .foregroundColor(isSelected ? .white : .primary)
                
                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(.system(size: 12))
                        .foregroundColor(isSelected ? .white.opacity(0.8) : .secondary)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(isSelected ? Color.blue : Color(.systemGray6))
            .cornerRadius(20)
        }
    }
}
#Preview {
    FilterView(viewModel:     .init())
}
