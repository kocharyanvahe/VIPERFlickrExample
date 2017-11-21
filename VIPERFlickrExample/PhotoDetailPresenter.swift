//
//  PhotoDetailPresenter.swift
//  VIPERFlickrExample
//
//  Created by Kocharyan, Vahe on 11/18/17.
//  Copyright © 2017 Kocharyan, Vahe. All rights reserved.
//

import UIKit

protocol PhotoDetailPresenterInput: PhotoDetailViewControllerOutput, PhotoDetailInteractorOutput {
    
}

class PhotoDetailPresenter: PhotoDetailPresenterInput {
    
    weak var view: PhotoDetailViewControllerInput!
    var interactor: PhotoDetailInteractorInput!
    
    //Passing data from PhotoSearch Module Router
    func saveSelectedPhotoModel(_ photoModel: FlickrPhotoModel) {
        self.interactor.configurePhotoModel(photoModel)
    }
    
    func loadLargePhotoImage() {
        self.interactor.loadUIImageFromUrl()
    }
    
    //result comes from Interactor
    func sendLoadedPhotoImage(_ image: UIImage) {
        self.view.addLargeLoadedPhoto(image)
    }
    
    func getPhotoImageTitle() {
        let imageTitle = self.interactor.getPhotoImageTitle()
        self.view.addPhotoImageTitle(imageTitle)
    }
}
