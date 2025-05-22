//
//  Models.swift
//  NewYearSPB
//
//

import SwiftUI

struct Event: Identifiable {
    let id = UUID()
    let title: String
    let shortDescription: String
    let fullDescription: String
    let imageURL: String
    let eventType: EventType
    let ageCategory: AgeCategory
    let price: Int
    let priceCategory: PriceCategory
    let startDate: Date
    let endDate: Date
    let sessionTimes: [String]
    let location: String
    let locationAddress: String
    let phone: String
    let website: String
    
    // Computed property to get formatted price string
    var priceString: String {
        return "от \(price) ₽"
    }
    
    // Computed property to get formatted date range
    var dateRangeString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMMM"
        dateFormatter.locale = Locale(identifier: "ru_RU")
        return "\(dateFormatter.string(from: startDate)) - \(dateFormatter.string(from: endDate))"
    }
}

enum EventType: String, CaseIterable {
    case exhibition = "Выставка"
    case cinema = "Кино"
    case museum = "Музей"
    case theater = "Театр"
    case concert = "Концерт"
    case fair = "Ярмарка"
    case ball = "Бал"
    case other = "Другое"
    
    var id: String { self.rawValue }
}

enum AgeCategory: String, CaseIterable, Identifiable {
    case all = "Все возрасты"
    case zero = "0+"
    case three = "3+"
    case four = "4+"
    case six = "6+"
    case seven = "7+"
    case eight = "8+"
    case ten = "10+"
    case twelve = "12+"
    case sixteen = "16+"
    case eighteen = "18+"
    
    
    var id: String { self.rawValue }
}

enum PriceCategory: String, CaseIterable {
    case free = "Бесплатно"
    case cheap = "Недорого"
    case medium = "Средне"
    case expensive = "Дорого"
    
    var id: String { self.rawValue }
    
    var range: ClosedRange<Int> {
        switch self {
        case .free: return 0...0
        case .cheap: return 1...500
        case .medium: return 501...1500
        case .expensive: return 1501...Int.max
        }
    }
    
    var description: String {
        switch self {
        case .free: return "0 ₽"
        case .cheap: return "до 500 ₽"
        case .medium: return "500-1500 ₽"
        case .expensive: return "от 1500 ₽"
        }
    }
}

//View models

class EventsViewModel: ObservableObject {
    @Published var events: [Event] = []
    @Published var filteredEvents: [Event] = []
    
    // Filter states
    @Published var selectedEventTypes: Set<EventType> = []
    @Published var selectedAgeCategory: AgeCategory = .all
    @Published var selectedPriceCategories: Set<PriceCategory> = []
    @Published var isFilterSheetPresented = false
    
    init() {
        events = mockEvents
        filteredEvents = events
    }
    
    func applyFilters() {
        filteredEvents = events.filter { event in
            let matchesEventType = selectedEventTypes.isEmpty || selectedEventTypes.contains(event.eventType)
            let matchesAgeCategory = selectedAgeCategory == .all || selectedAgeCategory == event.ageCategory
            let matchesPriceCategory = selectedPriceCategories.isEmpty || selectedPriceCategories.contains(event.priceCategory)
            
            return matchesEventType && matchesAgeCategory && matchesPriceCategory
        }
    }
    
    func resetFilters() {
        selectedEventTypes = []
        selectedAgeCategory = .all
        selectedPriceCategories = []
        filteredEvents = events
    }
}
