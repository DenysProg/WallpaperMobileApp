//
//  PhotoModelDataService.swift
//  WallpaperMobileApp
//
//  Created by Denys Nikolaichuk on 01.05.2023.
//

import Foundation
import Combine

// https://api.unsplash.com/photos/random?count=5&client_id=8EN1sryixWQtRetOI-C8FvFQyZgO15Q-FBDWSP4QF5I

class PhotoModelDataService {
    static let instatse = PhotoModelDataService()
    
    @Published var photoModel: [PhotoModel] = []
    @Published var collectionModel: [CollectionModel] = []
    @Published var collectionPhotos: [CollectionPhotosModel] = []
    @Published var page: Int = 1
    @Published var collectionPage: Int = 1
    @Published var photosPage: Int = 1
    var cancellables = Set<AnyCancellable>()
    
    private init() {
        downloadData()
    }
    
    func downloadData() {
        guard let url = URL(string: "https://api.unsplash.com/photos?page=\(page)&client_id=\(publicKey)") else { return }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: DispatchQueue.main)
            .tryMap(handleOutput)
            .decode(type: [PhotoModel].self, decoder: JSONDecoder())
            .sink { (completion) in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error downloading data. \(error)")
                }
                
            } receiveValue: { [weak self] returnedPhotoModel in
                self?.photoModel.append(contentsOf: returnedPhotoModel) 
            }
            .store(in: &cancellables)
    }
    
    func downloadCollectionData() async throws -> [CollectionModel]? {
        guard let url = URL(string: "https://api.unsplash.com/collections?page=\(collectionPage)&client_id=\(publicKey)") else { return nil }
        do {
            let (data, response) = try await URLSession.shared.data(from: url, delegate: nil)
            return handleResponse(data: data, response: response)
        } catch {
            throw error
        }
    }
    
    func downloadRelatedPhotoCollection(id: String) async throws -> [CollectionModel]? {
        guard let url = URL(string: "https://api.unsplash.com/collections/\(id)/related?client_id=\(publicKey)") else { return nil }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            return handleRelatedResponse(data: data, response: response)
        } catch {
            throw error
        }
    }
    
    func downloadCollectionPhotos(id: String) async throws -> [CollectionPhotosModel]? {
        guard let url = URL(string: "https://api.unsplash.com/collections/\(id)/photos?page=\(photosPage)&client_id=\(publicKey)") else { return nil }
       
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            return handleCollectionPhotosResponse(data: data, response: response)
        } catch {
            throw error
        }
    }
    
    func downloadRandomPhoto() async throws -> [CollectionPhotosModel]? {
        guard let url = URL(string: "https://api.unsplash.com/photos/random?count=30&client_id=\(publicKey)") else { return nil }
    
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            return handleRandomResponse(data: data, response: response)
        } catch {
            throw error
        }
    }
    
    private func handleOutput(output: URLSession.DataTaskPublisher.Output) throws -> Data {
        guard
            let response = output.response as? HTTPURLResponse,
            response.statusCode >= 200 && response.statusCode < 300 else {
            throw URLError(.badServerResponse)
        }
        
        return output.data
    }
    
    private func handleCollectionPhotosResponse(data: Data?, response: URLResponse?) -> [CollectionPhotosModel]? {
        guard
            let data = data,
            let model = try? JSONDecoder().decode([CollectionPhotosModel].self, from: data),
            let response = response as? HTTPURLResponse,
            response.statusCode >= 200 && response.statusCode < 300 else {
            return nil
        }
        
        collectionPhotos.append(contentsOf: model)
        
        return collectionPhotos
    }
    
    private func handleRandomResponse(data: Data?, response: URLResponse?) -> [CollectionPhotosModel]? {
        guard
            let data = data,
            let model = try? JSONDecoder().decode([CollectionPhotosModel].self, from: data),
            let response = response as? HTTPURLResponse,
            response.statusCode >= 200 && response.statusCode < 300 else {
            return nil
        }
        
        return model
    }
    
    private func handleRelatedResponse(data: Data?, response: URLResponse?) -> [CollectionModel]? {
        guard
            let data = data,
            let model = try? JSONDecoder().decode([CollectionModel].self, from: data),
            let response = response as? HTTPURLResponse,
            response.statusCode >= 200 && response.statusCode < 300 else {
            return nil
        }
        
        return model
    }
    
    private func handleResponse(data: Data?, response: URLResponse?) -> [CollectionModel]? {
        guard
            let data = data,
            let model = try? JSONDecoder().decode([CollectionModel].self, from: data),
            let response = response as? HTTPURLResponse,
            response.statusCode >= 200 && response.statusCode < 300 else {
            return nil
        }
        
        collectionModel.append(contentsOf: model)
        
        return collectionModel
    }
}
