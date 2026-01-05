//
//  HomeViewModel.swift
//  Traveling
//
//  Created by Rodolfo Gonzalez on 10-12-25.
//

import Foundation

@Observable
final class HomeViewModel {
    var allPoiPackages: [Package] = []
    var allNearbyPackages: [Package] = []
    var allNearbyFilterPackages: [Package] = []
    var countries: [Country] = []
    var searchDetail = SearchDetail()
    var selectedPackage: Package?
    var isLoading: Bool = false
    var lastLog: String = ""
    
    
    // MARK: - Dependencies
    private var poiRepo: POIRepositoryProtocol?
    
    init() {
        Task {
            await self.setup()
            if self.allPoiPackages.isEmpty {
                await self.fetchAllPOI()
            }
        }
        self.loadCountries()
    }
    
    
    
    func updateSearch() {
        let query = self.searchDetail.searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        if query.isEmpty {
            self.allNearbyFilterPackages = []
        } else {
            self.allNearbyFilterPackages = self.allPoiPackages.filter { $0.name.localizedCaseInsensitiveContains(query) }
        }
    }
    // MARK: - Setup simulador DI
    
    func fetchAllPOI() async {
    guard let repo = poiRepo else {
        self.lastLog = "⚠️ Networking not initialized."
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
    self.isLoading = true
    defer { self.isLoading = false }
    do {
        let result = try await repo.searchBoundingBox(params: params)
        let UIData = domainToUI(data: result)
        self.allPoiPackages = UIData
        print(result.count)
        print(allPoiPackages.count)
        print(allPoiPackages)
    } catch {
        self.lastLog = "❌ BoundingBox Error: \(error.localizedDescription)"
    }
}
    func fetchChileanPOI() async {
        guard let repo = poiRepo else {
            self.lastLog = "⚠️ Networking not initialized."
            return
        }
        let params = POIBoundingBoxParametersDomainModel(
            north: -17.0,
            south: -56.0,
            east: -66.0,
            west: -110.0,
            categories: [],
            page: PageParameters(limit: 25),
            offset: 0
        )
        self.isLoading = true
        defer { self.isLoading = false }
        do {
            let result = try await repo.searchBoundingBox(params: params)
            let UIData = domainToUI(data: result)
            self.allNearbyPackages = UIData
        } catch {
            self.lastLog = "❌ BoundingBox Error: \(error.localizedDescription)"
        }
    }
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
    private func domainToUI(data: [POIDomainModel]) -> [Package] {
        data.compactMap { poi -> Package? in
            guard let pictures = poi.pictures, !pictures.isEmpty else {
                return nil  // Explícitamente retorna nil si no hay imágenes
            }
            
            return Package(
                id: poi.id,
                imagesCollection: pictures,
                name: poi.name,
                rating: 2,
                numberReviews: 99,
                description: "Lorem ipsum... asgdhvjasdasasdcasd sadfasdfas",
                isFavorite: false,
                price: 100,
                servicesIncluded: [ServicesIncluded(
                    id: UUID(),
                    title: "2 day 1 night",
                    subTitle: "Duration",
                    icon: "clock.fill"
                )]
            )
        }
    }
    private func loadCountries() {
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
