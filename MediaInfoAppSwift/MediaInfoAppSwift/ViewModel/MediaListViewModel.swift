//
//  MediaListViewModel.swift
//  TestMediaInfoApp
//
//  Created by sargis on 2/9/18.
//  Copyright © 2018 sargis. All rights reserved.
//

import Foundation
import RealmSwift

class MediaListViewModel {

    let networkingService: NetworkingServiceProtocol
    let dataManager: DataManager
    
    fileprivate var mediaCollection: Results<Media>?
    
    private var cellViewModels: [MediaListCellViewModel] = [MediaListCellViewModel]() {
        didSet {
            self.reloadCollectionViewClosure?()
        }
    }
    
    var isLoading: Bool = false {
        didSet {
            self.updateLoadingStatus?()
        }
    }
    
    var numberOfCells: Int {
        return cellViewModels.count
    }
    
    var selectedIndex: Int?
    var reloadCollectionViewClosure: (()->())?
    var updateLoadingStatus: (()->())?
    
    init() {
        self.networkingService = NetworkingService()
        self.dataManager = DataManager()
    }
    
    func initFetch() {
        self.isLoading = true
        self.syncDataWithDB()
        
        networkingService.fetchMediaInfo { [weak self] (success,  error) in
            self?.isLoading = false
            if let error = error {
                print(error)
            } else {
                //db manager to compare fetched data to mediacollection and notify view model to process again and reload collection view
                
                self?.mediaCollection = (self?.dataManager.getAllMedia())!
                // if there is diff
                self?.processFetchedMedia(mediaCollection: (self?.mediaCollection)!)
            }
        }
    }
    
    func syncDataWithDB() {
        if let mediaFromDb = dataManager.getAllMedia() {
            self.processFetchedMedia(mediaCollection: mediaFromDb)
        }
    }
    
    func getCellViewModel(at indexPath: IndexPath ) -> MediaListCellViewModel {
        return cellViewModels[indexPath.row]
    }
    
    func createCellViewModel( media: Media ) -> MediaListCellViewModel {
        let date = Date(timeIntervalSince1970: media.date)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return MediaListCellViewModel( titleText: media.title,
                                       categoryText: media.category,
                                       coverPhotoUrl: media.coverPhotoUrl,
                                       dateText: dateFormatter.string(from: date),
                                       isReviewed: media.isReviewed)
    }
    
    private func processFetchedMedia( mediaCollection: Results<Media> ) {
        self.mediaCollection = mediaCollection
        var cellViewModels = [MediaListCellViewModel]()
        for media in mediaCollection {
            cellViewModels.append( createCellViewModel(media: media) )
        }
        self.cellViewModels = cellViewModels
    }
    
}

extension MediaListViewModel {
    func userPressed( at indexPath: IndexPath ){
        self.selectedIndex = indexPath.row
    }
}

struct MediaListCellViewModel {
    let titleText: String?
    let categoryText: String?
    let coverPhotoUrl: String?
    let dateText: String?
    let isReviewed: Bool?
}

