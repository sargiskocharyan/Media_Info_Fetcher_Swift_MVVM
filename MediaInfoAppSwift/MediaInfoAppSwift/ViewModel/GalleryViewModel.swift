//
//  GalleryViewModel.swift
//  TestMediaInfoApp
//
//  Created by sargis on 2/11/18.
//  Copyright © 2018 sargis. All rights reserved.
//

import Foundation
import RealmSwift

class GalleryViewModel {
    
    var galleryType:GalleryType = .image
    var gallery: List<Gallery>?
    var video: List<Video>?
    
    var cellViewModels:[GalleryCellViewModel] = [GalleryCellViewModel]() {
        didSet {
            self.reloadCollectionViewClosure?()
        }
    }
    
    var numberOfCells: Int {
        return cellViewModels.count
    }
    
    var reloadCollectionViewClosure: (()->())?
    
    var selectedMediaIndex: Int?
    
    func initFetch() {
        let dataManager = DataManager()
        if let mediaFromDb = dataManager.getAllMedia() {
            let media = mediaFromDb[selectedMediaIndex!]
            if galleryType == .image, media.gallery.count > 0 {
                self.processFetchedImageGallery(gallery: media.gallery)
            }
            else if galleryType == .video, media.video.count > 0 {
                self.processFetchedVideoGallery(video: media.video)
            }
        }
    }
    
    func getCellViewModel( at indexPath: IndexPath ) -> GalleryCellViewModel {
        return cellViewModels[indexPath.row]
    }
    
    private func processFetchedImageGallery( gallery: List<Gallery> ) {
        self.gallery = gallery
        var cellViewModels = [GalleryCellViewModel]()
        for gal in gallery {
            cellViewModels.append(createCellViewModel(gallery: gal, video: nil) )
        }
        self.cellViewModels = cellViewModels
    }
    
    private func processFetchedVideoGallery( video: List<Video> ) {
        self.video = video
        var cellViewModels = [GalleryCellViewModel]()
        for vid in video {
            cellViewModels.append(createCellViewModel(gallery: nil, video: vid) )
        }
        self.cellViewModels = cellViewModels
    }
    
    func createCellViewModel( gallery: Gallery?, video: Video? ) -> GalleryCellViewModel {
        if galleryType == .image {
            return GalleryCellViewModel( titleText: gallery!.title,
                                         thumbnailUrl: gallery!.thumbnailUrl,
                                         contentUrl: gallery!.contentUrl,
                                         youtubeId: nil)
        }
        else {
            return GalleryCellViewModel( titleText: video!.title,
                                         thumbnailUrl: video!.thumbnailUrl,
                                         contentUrl: nil,
                                         youtubeId: video!.youtubeId)
        }
    }
}

struct GalleryCellViewModel {
    var titleText:String?
    var thumbnailUrl:String?
    var contentUrl: String?
    var youtubeId: String?
}
