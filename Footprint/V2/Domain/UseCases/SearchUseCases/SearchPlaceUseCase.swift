//
//  SearchPlaceUseCase.swift
//  Footprint
//
//  Created by sandy on 11/26/24.
//

import GoogleMaps
import GooglePlaces

class SearchPlaceUseCase {
    
    func execute(_ text: String, location: Location, sessionToken: GMSAutocompleteSessionToken) async -> [SearchEntity] {
        let filter = GMSAutocompleteFilter()
        let searchBound: Double = 10.0
        let northEastBounds = CLLocationCoordinate2DMake(location.latitude + searchBound, location.longitude + searchBound);
        let southWestBounds = CLLocationCoordinate2DMake(location.latitude - searchBound, location.longitude - searchBound);
        filter.locationBias = GMSPlaceRectangularLocationOption(northEastBounds, southWestBounds);
        let placesClient: GMSPlacesClient = GMSPlacesClient()
        
        return await withCheckedContinuation { continuation in
            var searchItems: [SearchEntity] = []
            /*
             SessionToken: https://developers.google.com/maps/documentation/places/ios-sdk/usage-and-billing?hl=ko&_gl=1*1eu33bq*_up*MQ..*_ga*MTA4NDY1NTY5MS4xNzMyNTk3Nzg0*_ga_NRWSTWS78N*MTczMjU5Nzc4NC4xLjEuMTczMjU5Nzc4NS4wLjAuMA..#ac-per-request
             */
            placesClient.findAutocompletePredictions(fromQuery: text, filter: filter, sessionToken: sessionToken, callback: { (results, error) in
                guard let results = results else {
                    continuation.resume(returning: searchItems)
                    return
                }
                if let error = error {
                    print("Autocomplete error: \(error)")
                    continuation.resume(returning: searchItems)
                    return
                }
                
                results.forEach {
                    searchItems.append(
                        SearchEntity(
                            name: $0.attributedPrimaryText.string,
                            fullAddress: $0.attributedFullText.string,
                            placeId: $0.placeID,
                            types: $0.types
                        )
                    )
                }
                continuation.resume(returning: searchItems)
            })
        }
    }
}
