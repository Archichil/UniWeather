//
//  CalendarManager.swift
//  UniWeather
//
//  Created by Daniil on 1.05.25.
//

import EventKit
import SwiftUI

struct Holiday: Identifiable {
    let id = UUID()
    let title: String
    let notes: String?
    let date: Date
}

class CalendarManager {
    static let shared = CalendarManager()
    private let eventStore = EKEventStore()

    private init() {}

    func requestCalendarAccess(completion: @escaping (Bool) -> Void) {
        eventStore.requestFullAccessToEvents { result, err in
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }

    func getHolidays(daysAhead: Int, completion: @escaping ([Holiday]) -> Void) {
        let status = EKEventStore.authorizationStatus(for: .event)

        if status == .fullAccess {
            fetchHolidays(daysAhead: daysAhead, completion: completion)
        } else {
            requestCalendarAccess { granted in
                if granted {
                    self.fetchHolidays(daysAhead: daysAhead, completion: completion)
                } else {
                    completion([])
                }
            }
        }
    }

    private func fetchHolidays(daysAhead: Int, completion: @escaping ([Holiday]) -> Void) {
        let calendars = eventStore.calendars(for: .event)
        let now = Date()
        guard let endDate = Calendar.current.date(byAdding: .day, value: daysAhead, to: now) else {
            completion([])
            return
        }

        let predicate = eventStore.predicateForEvents(
            withStart: now,
            end: endDate,
            calendars: calendars
        )

        let events = eventStore.events(matching: predicate)
            .filter { !$0.title.isEmpty }
            .map { Holiday(title: $0.title, notes: $0.notes, date: $0.startDate) }
            .sorted { $0.date < $1.date }

        completion(events)
    }
}
