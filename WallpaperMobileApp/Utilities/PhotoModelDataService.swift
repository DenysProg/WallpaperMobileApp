//
//  PhotoModelDataService.swift
//  WallpaperMobileApp
//
//  Created by Denys Nikolaichuk on 01.05.2023.
//

import Foundation
import Combine

class PhotoModelDataService {
    static let instatne = PhotoModelDataService()
    
    @Published var photoModels: [PhotoModel] = []
    @Published var page: Int = 1
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
                self?.photoModels.append(contentsOf: returnedPhotoModel) 
            }
            .store(in: &cancellables)
    }
    
    private func handleOutput(output: URLSession.DataTaskPublisher.Output) throws -> Data {
        guard
            let response = output.response as? HTTPURLResponse,
            response.statusCode >= 200 && response.statusCode < 300 else {
            throw URLError(.badServerResponse)
        }
        
        return output.data
    }
}
