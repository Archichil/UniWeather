//
//  LocationSearchViewModel.swift
//  UniWeather
//
//  Created by Artur Kukhatskavolets on 31.03.25.
//

import Combine
import MapKit
import CoreLocation
import WeatherService

class LocationSearchViewModel: NSObject, ObservableObject {
    @Published var locationResults: [MKLocalSearchCompletion] = []
    @Published var searchTerm: String = ""
    @Published var address: String = ""

    private var cancellables: Set<AnyCancellable> = []
    private var searchCompleter = MKLocalSearchCompleter()
    private var currentPromise: ((Result<[MKLocalSearchCompletion], Error>) -> Void)?

    override init() {
        super.init()
        searchCompleter.delegate = self
        searchCompleter.resultTypes = [.address, .pointOfInterest]

        $searchTerm
            .debounce(for: .seconds(0.3), scheduler: RunLoop.main)
            .removeDuplicates()
            .flatMap { currentSearchTerm in
                self.searchTermToResults(searchTerm: currentSearchTerm)
            }
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print("[DEBUG]: Failed while searching: \(error.localizedDescription)")
                }
            }, receiveValue: { results in
                self.locationResults = results
            })
            .store(in: &cancellables)
    }

    func searchTermToResults(searchTerm: String) -> Future<[MKLocalSearchCompletion], Error> {
        Future { promise in
            self.searchCompleter.queryFragment = searchTerm
            self.currentPromise = promise
        }
    }

    func reverseGeocode(location: MKLocalSearchCompletion) async -> Coordinates {
        let searchRequest = MKLocalSearch.Request(completion: location)
        let search = MKLocalSearch(request: searchRequest)
        var result: Coordinates
        
        let response = try? await search.start()
        let coords = response?.mapItems.first?.placemark.coordinate
        result = Coordinates(lat: coords?.latitude ?? 0, lon: coords?.longitude ?? 0)
        return result
    }
}

extension LocationSearchViewModel: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
            currentPromise?(.success(completer.results))
        }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print("[DEBUG]: Failed to perform search autocompletion: \(error.localizedDescription)")
    }
}
