//
//  LocationSearchView.swift
//  UniWeather
//
//  Created by Artur Kukhatskavolets on 31.03.25.
//

import SwiftUI
import MapKit
import SwiftData
import WeatherService

struct LocationSearchView: View {
    // MARK: - Constants
    private enum Constants {
        enum Colors {
            static let highlight: Color = .white
            static let sheetBackground: Color = .blue
        }
        
        enum Icons {
            static let deleteIcon = "trash"
        }
        
        enum Text {
            static let navigationTitle = String(localized: "locationSearchView.navigationTitle")
            static let searchPrompt = String(localized: "locationSearchView.searchPrompt")
        }
    }
    
    // MARK: - Properties
    @StateObject private var viewModel = LocationSearchViewModel()
    @Environment(\.modelContext) private var context
    @Query(sort: \LocationEntity.timestamp, order: .reverse) private var items: [LocationEntity]
    @State private var isFocused = false
    @State private var isSheetPresented = false
    
    // MARK: - Main View
    var body: some View {
        NavigationStack {
            searchableList
                .navigationTitle(Constants.Text.navigationTitle)
        }
    }
    
    // MARK: - Subviews
    private var searchableList: some View {
        VStack {
            if isFocused {
                List {
                    searchResultsContent
                }
            } else {
                mainContent
            }
        }
        .searchable(
            text: $viewModel.searchTerm,
            isPresented: $isFocused,
            placement: .navigationBarDrawer(displayMode: .always),
            prompt: Constants.Text.searchPrompt
        )
        
    }
    
    @ViewBuilder
    private var searchResultsContent: some View {
        if !viewModel.searchTerm.isEmpty {
            ForEach(viewModel.locationResults, id: \.self) { location in
                locationRow(for: location)
            }
        }
    }
    
    private var mainContent: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 8) {
                ForEach(items) { item in
                    HStack {
                        LocationItemContainer(coordinate: Coordinates(lat: item.latitude, lon: item.longitude))
                            .frame(maxWidth: .infinity, alignment: .leading)
//                        Spacer()
                        Button(role: .destructive) {
                            deleteItem(item)
                        } label: {
                            Image(systemName: Constants.Icons.deleteIcon)
                                .font(.title2)
                                .foregroundColor(.red)
                        }
                        .buttonStyle(.borderless)
                    }
                }
            }
            .padding(.horizontal)
        }
    }

    
    private var sheetContent: some View {
        EmptyView()
            .presentationDragIndicator(.visible)
            .background(Constants.Colors.sheetBackground)
    }
    
    private func locationRow(for location: MKLocalSearchCompletion) -> some View {
        Button {
            Task {
                await handleLocationSelection(location)
            }
        } label: {
            VStack(alignment: .leading) {
                highlightedText(
                    location.title,
                    searchTerm: viewModel.searchTerm,
                    highlightColor: .primary
                )
                .foregroundStyle(.secondary)
                highlightedText(
                    location.subtitle,
                    searchTerm: viewModel.searchTerm,
                    highlightColor: .primary
                )
                .foregroundStyle(.secondary)
                .font(.caption)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
    
    private func handleLocationSelection(_ location: MKLocalSearchCompletion) async {
        let coordinate = await viewModel.reverseGeocode(location: location)
        addItem(coordinate: coordinate)
        isSheetPresented = true
        isFocused = false
        viewModel.searchTerm = ""
    }

    func highlightedText(_ text: String, searchTerm: String, highlightColor: Color) -> Text {
        guard !searchTerm.isEmpty else { return Text(text) }
        
        let lowerText = text.lowercased()
        let lowerSearchTerm = searchTerm.lowercased()
        var result = Text("")
        var currentIndex = lowerText.startIndex

        while let range = lowerText[currentIndex...].range(of: lowerSearchTerm) {
            // Add text before match
            let beforeMatch = text[currentIndex..<range.lowerBound]
            result = result + Text(beforeMatch)
            
            // Add highlighted match
            let match = text[range]
            result = result + Text(match).foregroundColor(highlightColor)
            
            currentIndex = range.upperBound
            if currentIndex == lowerText.endIndex {
                break
            }
        }
        
        // Add text after match
        if currentIndex < text.endIndex {
            let remainder = text[currentIndex..<text.endIndex]
            result = result + Text(remainder)
        }
        
        return result
    }
    
    // MARK: - Persistence
    func addItem(coordinate: Coordinates) {
        let entity = LocationEntity(latitude: coordinate.lat, longitude: coordinate.lon)
        context.insert(entity)
        try? context.save()
        updateUserDefaults()
    }
    
    func deleteItem(_ item: LocationEntity) {
        context.delete(item)
        try? context.save()
        updateUserDefaults()
    }
    
    func updateUserDefaults() {
        let sharedDefaults = UserDefaults(suiteName: "group.com.kuhockovolec.UniWeather1")!
        let encodedItems = try? JSONEncoder().encode(items)
        sharedDefaults.set(encodedItems, forKey: "savedLocations")
    }
}

// MARK: - Preview
#Preview {
    LocationSearchView()
        .preferredColorScheme(.dark)
}
