//
//  HomeViewModel.swift
//  Traveling
//
//  Created by Rodolfo Gonzalez on 10-12-25.
//

import Foundation

@Observable
final class HomeViewModel {
    /// Observable state for Home and Search screens.
    /// Owns POI lists, search state, and lightweight UI flags.
    /// Data is loaded via POIRepositoryProtocol built in setup().
    /// Main POI list used by Home and as the base for text filtering.
    /// Populated by fetchAllPOI() after mapping domain -> Package.
    /// Each element is bound into UI (favorite toggles mutate it).
    var allPoiPackages: [Package] = []
    /// POIs returned from a nearby search (here: Chile bounding box).
    /// Shown in SearchView when searchText is empty.
    /// Filled by fetchChileanPOI().
    var allNearbyPackages: [Package] = []
    /// Filtered results derived from allPoiPackages by searchText.
    /// Updated by updateSearch() on each text change.
    /// Displayed in SearchView when searchText is not empty.
    var allNearbyFilterPackages: [Package] = []
    /// Static/mock countries used by HomeCountriesCollectionView.
    /// Loaded locally in loadCountries() during init().
    /// Not fetched from network in this ViewModel.
    var countries: [Country] = []
    /// Shared search state (text + selected filter type).
    /// Bound by TopHomeView and SearchView to drive UI changes.
    /// updateSearch() uses searchDetail.searchText as input.
    var searchDetail = SearchDetail()
    /// Optional selection placeholder (not currently used for navigation).
    /// Navigation to detail is handled by router + package id in the views.
    /// Keep for future: e.g. sheet/detail without router.
    var selectedPackage: Package?
    /// Indicates an in-flight network request for POIs.
    /// Set true/false around fetchAllPOI() and fetchChileanPOI().
    /// Useful for showing spinners or disabling actions.
    var isLoading: Bool = false
    /// Last diagnostic message (init/setup failures or fetch errors).
    /// Written when repo is nil or when searchBoundingBox throws.
    /// Can be surfaced to UI for debugging.
    var lastLog: String = ""
    
    
    // MARK: - Dependencies
    /// Repository used to perform POI network queries.
    /// Built in setup() using builders + NetworkServiceImp.
    /// Nil means setup failed; fetch methods will early-exit.
    private var poiRepo: POIRepositoryProtocol?
    
    /// Initializes dependencies and triggers initial data load.
    /// Runs setup() and fetchAllPOI() inside a Task.
    /// Also loads static countries synchronously.
    init() {
        Task {
            await self.setup()
            if self.allPoiPackages.isEmpty {
                await self.fetchAllPOI()
            }
        }
        self.loadCountries()
    }
    
    
    
    /// Recomputes filtered results based on searchDetail.searchText.
    /// Empty query clears allNearbyFilterPackages; otherwise filters by name.
    /// Called from SearchView/HomeView via onChange(of: searchText).
    func updateSearch() {
        let query = self.searchDetail.searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        if query.isEmpty {
            self.allNearbyFilterPackages = []
        } else {
            self.allNearbyFilterPackages = self.allPoiPackages.filter { $0.name.localizedCaseInsensitiveContains(query) }
        }
    }
    // MARK: - Setup simulador DI
    
    /// Fetches POIs for a global bounding box (full world extents).
    /// Saves mapped results into allPoiPackages for Home + filtering.
    /// Updates isLoading and lastLog for UI/diagnostics.
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
    /// Fetches POIs for a Chile bounding box (nearby shortcut).
    /// Saves mapped results into allNearbyPackages for SearchView.
    /// Triggered by the 'Search place nearby' button.
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
    /// Builds the networking stack and assigns poiRepo (manual DI).
    /// Uses localhost baseURL and the repository mapper POIMapperImp().
    /// On failure, leaves poiRepo nil and writes lastLog.
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
    /// Maps domain POIs into UI-friendly Package models.
    /// Drops POIs with missing/empty pictures (required by AsyncImage).
    /// Some fields are placeholders (rating/price/services).
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
    /// Loads a static list of countries for the Home carousel.
    /// This is local/mock data (no API call).
    /// Replace with backend data when available.
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
