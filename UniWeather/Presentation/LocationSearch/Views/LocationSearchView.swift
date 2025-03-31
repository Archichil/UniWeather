//
//  LocationSearchView.swift
//  UniWeather
//
//  Created by Artur Kukhatskavolets on 31.03.25.
//

import SwiftUI
import MapKit

struct LocationSearchView: View {
    // MARK: - Constants
    private enum Constants {
        enum Colors {
            static let highlight: Color = .white
            static let sheetBackground: Color = .blue
        }
        
        enum Text {
            static let navigationTitle = "Search"
            static let searchPrompt = "Search for a city or airport"
            static let errorMessage = "Unexpected Error"
            static let addressFormat = "City: %@, Coords: (Latitude: %f; Longitude: %f)"
        }
    }
    
    // MARK: - Properties
    @StateObject private var viewModel = LocationSearchViewModel()
    @State private var isFocused = false
    @State private var isSheetPresented = false
    
    // MARK: - Main View
    var body: some View {
        NavigationStack {
            searchableList
                .navigationTitle(Constants.Text.navigationTitle)
                .sheet(isPresented: $isSheetPresented) {
                    sheetContent
                }
        }
    }
    
    // MARK: - Subviews
    private var searchableList: some View {
        List {
            if isFocused {
                searchResultsContent
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
        Text(viewModel.address)
            .foregroundColor(Constants.Colors.highlight)
    }
    
    private var sheetContent: some View {
        EmptyView()
            .presentationDragIndicator(.visible)
            .background(Constants.Colors.sheetBackground)
    }
    
    private func locationRow(for location: MKLocalSearchCompletion) -> some View {
        Button {
            handleLocationSelection(location)
        } label: {
            VStack(alignment: .leading) {
                highlightedText(
                    location.title,
                    searchTerm: viewModel.searchTerm,
                    highlightColor: .white
                )
                .foregroundStyle(.secondary)
                highlightedText(
                    location.subtitle,
                    searchTerm: viewModel.searchTerm,
                    highlightColor: .white
                )
                .foregroundStyle(.secondary)
                .font(.caption)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
    
    private func handleLocationSelection(_ location: MKLocalSearchCompletion) {
        viewModel.reverseGeocode(location: location)
        isSheetPresented = true
        isFocused = false
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

}

// MARK: - Preview
#Preview {
    LocationSearchView()
        .preferredColorScheme(.dark)
}
