//
//  PhotoDetailInteractor.swift
//  VIPERFlickrExample
//
//  Created by Kocharyan, Vahe on 11/18/17.
//  Copyright © 2017 Kocharyan, Vahe. All rights reserved.
//

import UIKit

protocol PhotoDetailInteractorOutput: class {
    func sendLoadedPhotoImage(_ image: UIImage)
}

protocol PhotoDetailInteractorInput: class {
    func configurePhotoModel(_ photoModel: FlickrPhotoModel)
    func loadUIImageFromUrl()
    func getPhotoImageTitle() -> String
}

class PhotoDetailInteractor: PhotoDetailInteractorInput {
    
    weak var presenter: PhotoDetailInteractorOutput!
    var photoModel: FlickrPhotoModel?
    var imageDataManager: FlickrPhotoLoadImageProtocol!
    
    func configurePhotoModel(_ photoModel: FlickrPhotoModel) {
        self.photoModel = photoModel
    }
    
    func loadUIImageFromUrl() {
        imageDataManager.loadImageFromUrl(self.photoModel!.largePhotoUrl as URL) { (image, error) in
            if let image = image {
                self.presenter.sendLoadedPhotoImage(image)
            }
        }
    }
    
    func getPhotoImageTitle() -> String {
        if let title = self.photoModel?.title {
            return title
        }
        return ""
    }
}
