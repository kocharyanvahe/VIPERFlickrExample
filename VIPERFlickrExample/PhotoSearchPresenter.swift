//
//  PhotoSearchPresenter.swift
//  VIPERFlickrExample
//
//  Created by Kocharyan, Vahe on 11/18/17.
//  Copyright © 2017 Kocharyan, Vahe. All rights reserved.
//

import UIKit

protocol PhotoSearchPresenterInput: PhotoViewControllerOutput, PhotoSearchInteractorOutput {
    
}

class PhotoSearchPresenter: PhotoSearchPresenterInput {
    
    weak var view: PhotoViewControllerInput!
    var interactor: PhotoSearchInteractorInput!
    var router: PhotoSearchRouterInput!
    
    //Presenter says interactor ViewController needs photos
    func fetchPhotos(_ searchtag: String, page: Int) {
        if view.getTotalPhotoCount() == 0 {
            view.showWaitingView()
        }
        interactor.fetchAllPhotosFromDataManager(searchtag, page: page)
    }
    
    //Service return photos and interactor passes all data to presenter which make view display them
    func providedPhotos(_ photos: [FlickrPhotoModel], totalPages: Int) {
        self.view.hideWaitingView()
        self.view.displayFetchedPhotos(photos, totalPages: totalPages)
    }
    
    //Show error message from service
    func serviceError(_ error: Error) {
        self.view.displayErrorView(defaultErrorMessage)
    }
    
    func gotoPhotoDetailScreen() {
        self.router.navigateToPhotoDetail()
    }
    
    func passDataToNextScene(_ segue: UIStoryboardSegue) {
        self.router.passDataToNextScene(segue)
    }
}
