//
//  LocationSearchViewModel.swift
//  UniWeather
//
//  Created by Artur Kukhatskavolets on 31.03.25.
//

import Combine
import MapKit
import CoreLocation

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

    func reverseGeocode(location: MKLocalSearchCompletion) {
        let searchRequest = MKLocalSearch.Request(completion: location)
        let search = MKLocalSearch(request: searchRequest)

        search.start { response, error in
            guard error == nil,
                  let coordinate = response?.mapItems.first?.placemark.coordinate else {
                print("Reverse geocoding error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            self.updateAddress(with: coordinate)
        }
    }

    private func updateAddress(with coordinate: CLLocationCoordinate2D) {
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            guard let placemark = placemarks?.first else {
                print("Reverse geocode error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            self.address = "\(placemark.locality ?? ""), \(coordinate.latitude), \(coordinate.longitude)"
        }
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
