//
//  PhotoSearchInteractor.swift
//  VIPERFlickrExample
//
//  Created by Kocharyan, Vahe on 11/18/17.
//  Copyright © 2017 Kocharyan, Vahe. All rights reserved.
//

import UIKit

protocol PhotoSearchInteractorInput: class {
    func fetchAllPhotosFromDataManager(_ searchTag: String, page: Int)
}

protocol PhotoSearchInteractorOutput: class {
    func providedPhotos(_ photos: [FlickrPhotoModel], totalPages: Int)
    func serviceError(_ error: Error)
}

class PhotoSearchInteractor: PhotoSearchInteractorInput {
    weak var presenter: PhotoSearchInteractorOutput!
    var APIDataManager: FlickrPhotoSearchProtocol!
    
    func fetchAllPhotosFromDataManager(_ searchTag: String, page: Int) {
        APIDataManager.fetchPhotosForSearchText(searchText: searchTag, page: page) { (error, totalPages, flickrPhotos) in
            if let photos = flickrPhotos {
                self.presenter.providedPhotos(photos, totalPages: totalPages)
            } else if let error = error {
                self.presenter.serviceError(error)
            }
        }
    }
}
