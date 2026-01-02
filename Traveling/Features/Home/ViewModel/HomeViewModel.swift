//
//  HomeViewModel.swift
//  Traveling
//
//  Created by Rodolfo Gonzalez on 10-12-25.
//

import Foundation

@Observable
final class HomeViewModel {
    
    
    var packages: [Package] = []
    var countries: [Country] = []
    var searchDetail = SearchDetail()
    
    var isLoading: Bool = false
    var lastLog: String = ""
    
    // MARK: - Dependencies
    private var poiRepo: POIRepositoryProtocol?
    
    
    init() {
        loadData()
        Task {
            await setup()
            await fetchAllPOI()
        }
    }
    
    // MARK: - Setup simulador DI
    private func setup() async {
        do {
            let url = "http://localhost:3000"

            let endPoint = try EndPointBuilderImp(baseURL: url)

            let requestBuilder = RequestBuilderImp(
                endPointBuilder: endPoint,
                payloadBuilder: nil
            )

            let client = NetworkClientImp()

            let network = NetworkServiceImp(
                client: client,
                requestBuilder: requestBuilder
            )

            self.poiRepo = POIRepositoryImp(
                network: network,
                mapper: POIMapperImp()
            )
        } catch {
            lastLog = "Initialization failed: \(error.localizedDescription)"
        }
    }

   
   
    private func fetchAllPOI() async {
        guard let repo = poiRepo else {
            lastLog = "⚠️ Networking not initialized."
            return
        }
        let params = POIBoundingBoxParametersDomainModel(
            north: 90.0,
            south: -90.0,
            east: 180.0,
            west: -180.0,
            categories: [],
            page: PageParameters(limit: 25),
            offset: 0
        )
        isLoading = true
        defer { isLoading = false }
        do {
            let result = try await repo.searchBoundingBox(params: params)
            let UIData = domainToUI(data: result)
            self.packages = UIData
            print(result.count)
            print(packages.count)
        } catch {
            lastLog = "❌ BoundingBox Error: \(error.localizedDescription)"
        }
    }
    
    private func domainToUI(data: [POIDomainModel]) -> [Package] {
        var listPOI: [Package] = []
         data.map {
             if $0.pictures != nil && $0.pictures!.count >= 1 {
                 listPOI.append(
                    Package(
                    id: $0.id,
                    imagesCollection: $0.pictures ?? [],
                    name: $0.name,
                    rating: 2,
                    numberReviews: 99,
                    description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
                    isFavorite: false,
                    price: 100,
                    servicesIncluded: [ServicesIncluded(id: UUID(), title: "2 day 1 night", subTitle: "Duration", icon: "clock.fill")]
                )
                )
            }
        }
        return listPOI
    }
    private func fetchChileanPOI() {
        
    }
    
    
    
    private func loadData() {
        
        self.countries = [
            Country(
                id: UUID(),
                name: "Cambodia",
                imageURL: "country1"
            ),
            Country(
                id: UUID(),
                name: "Cambodia",
                imageURL: "country1"
            ),
            Country(
                id: UUID(),
                name: "Cambodia",
                imageURL: "country1"
            )
        ]
    }
}




struct SearchDetail {
    var searchText: String = ""
    var searchType: SearchType = .all
}
struct Country: Identifiable {
    let id: UUID
    let name: String
    let imageURL: String
}
enum SearchType {
    case all
    case hotel
    case oversea
}
