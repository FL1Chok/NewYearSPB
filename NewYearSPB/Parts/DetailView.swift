import SwiftUI

struct EventDetailView: View {
    let event: Event
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Event image
                if let uiImage = UIImage(named: event.imageURL) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 220)
                        .clipped()
                } else {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 220)
                        .overlay(
                            Image(systemName: "photo")
                                .font(.largeTitle)
                                .foregroundColor(.gray)
                        )
                }
                
                VStack(alignment: .leading, spacing: 16) {
                    // Title and tags
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text(event.eventType.rawValue)
                                .font(.system(size: 14, weight: .medium))
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(16)
                            
                            Text(event.ageCategory.rawValue)
                                .font(.system(size: 14, weight: .medium))
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(Color.orange)
                                .foregroundColor(.white)
                                .cornerRadius(16)
                        }
                        
                        Text(event.title)
                            .font(.title)
                            .fontWeight(.bold)
                    }
                    
                    // Price (показываем только если есть цена)
                    if !event.priceString.isEmpty {
                        HStack {
                            Text("Стоимость")
                                .font(.headline)
                            Spacer()
                            Text(event.priceString)
                                .font(.headline)
                                .foregroundColor(.blue)
                        }
                        Divider()
                    }
                    
                    // Date and time
                    VStack(alignment: .leading, spacing: 12) {
                        EventInfoRow(
                            icon: "calendar",
                            title: event.dateRangeString
                        )
                        
                        if !event.sessionTimes.isEmpty {
                            EventInfoRow(
                                icon: "clock",
                                title: event.sessionTimes.joined(separator: ", ")
                            )
                        }
                        
                        if !event.locationAddress.isEmpty {
                            EventInfoRow(
                                icon: "mappin.and.ellipse",
                                title: event.locationAddress
                            )
                        }
                        
                        if !event.phone.isEmpty {
                            EventInfoRow(
                                icon: "phone",
                                title: event.phone,
                                isLink: true
                            )
                        }
                        
                        if !event.website.isEmpty {
                            EventInfoRow(
                                icon: "globe",
                                title: event.website,
                                isLink: true
                            )
                        }
                    }
                    
                    Divider()
                    
                    // Description (показываем только если есть описание)
                    if !event.fullDescription.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Описание")
                                .font(.headline)
                            Text(event.fullDescription)
                                .font(.body)
                                .lineSpacing(4)
                        }
                    }
                }
                .padding()
            }
        }
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
    }
}
