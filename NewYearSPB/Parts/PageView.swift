import SwiftUI

struct PageView: View {
    @StateObject private var viewModel = EventsViewModel()
    @State private var searchText = ""
    @State private var selectedEvent: Event?
    @State private var shouldHideKeyboard = false
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    private var filteredEvents: [Event] {
        let baseEvents = viewModel.filteredEvents
        
        guard !searchText.isEmpty else { return baseEvents }
        
        let searchLowercased = searchText.lowercased()
        return baseEvents.filter { event in
            event.title.lowercased().contains(searchLowercased) ||
            event.shortDescription.lowercased().contains(searchLowercased) ||
            event.location.lowercased().contains(searchLowercased)
        }
    }
    
    private var searchField: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            TextField("Поиск мест и событий", text: $searchText)
                .foregroundColor(.primary)
                .autocorrectionDisabled()
                .overlay(alignment: .trailing) {
                    if !searchText.isEmpty {
                        Button(action: {
                            searchText = ""
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                                .padding(.trailing, 8)
                        }
                    }
                }
        }
        .padding(10)
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
    
    private var themeButton: some View {
        Button(action: { isDarkMode.toggle() }) {
            Image(systemName: isDarkMode ? "sun.max.fill" : "moon.fill")
                .font(.system(size: 22))
                .foregroundColor(.gray)
                .padding(8)
                .background(Color(.systemGray6))
                .cornerRadius(10)
        }
    }
    
    private var filterButton: some View {
        Button(action: { viewModel.isFilterSheetPresented = true }) {
            Image(systemName: "line.3.horizontal.decrease.circle")
                .font(.system(size: 22))
                .foregroundColor(.gray)
                .padding(8)
                .background(Color(.systemGray6))
                .cornerRadius(10)
        }
    }
    
    private func eventCard(for event: Event) -> some View {
        EventCardView(event: event)
            .onTapGesture {
                if UIApplication.shared.isKeyboardPresented {
                    UIApplication.shared.endEditing()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        selectedEvent = event
                    }
                } else {
                    selectedEvent = event
                }
            }
    }
    
    private var emptyStateView: some View {
        VStack {
            Spacer()
            Text("Ничего не нашлось")
                .font(.title3)
                .foregroundColor(.secondary)
            Spacer()
        }
        .frame(maxWidth: .infinity)
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                HStack {
                    themeButton
                    searchField
                    filterButton
                }
                .padding(.horizontal)
                .padding(.bottom, 10)
                
                ScrollView {
                    if filteredEvents.isEmpty {
                        emptyStateView
                            .frame(height: 300)
                    } else {
                        LazyVStack(spacing: 16) {
                            ForEach(filteredEvents) { event in
                                eventCard(for: event)
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Новогодний Петербург")
            .sheet(isPresented: $viewModel.isFilterSheetPresented) {
                FilterView(viewModel: viewModel)
                    .presentationBackgroundInteraction(.enabled(upThrough: .large))
                    .presentationDetents([.medium, .height(700)])
            }
            .sheet(item: $selectedEvent) { event in
                EventDetailView(event: event)
                    .presentationBackgroundInteraction(.enabled(upThrough: .large))
                    .presentationDetents([.medium, .height(700)])
            }
            .preferredColorScheme(isDarkMode ? .dark : .light)
        }
    }
}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    var isKeyboardPresented: Bool {
        guard let window = windows.first else { return false }
        return window.frame.height - window.safeAreaInsets.bottom - window.safeAreaLayoutGuide.layoutFrame.height > 0
    }
}

@main
struct FestivePetersburgApp: App {
    var body: some Scene {
        WindowGroup {
            PageView()
        }
    }
}
