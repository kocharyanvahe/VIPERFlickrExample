//
//  PhotoDetailAssembly.swift
//  VIPERFlickrExample
//
//  Created by Kocharyan, Vahe on 11/18/17.
//  Copyright © 2017 Kocharyan, Vahe. All rights reserved.
//

import UIKit

class PhotoDetailAssembly {
    static let sharedInstance = PhotoDetailAssembly()
    
    func configure(_ viewController: PhotoDetailViewController) {
        let APIDataManager: FlickrPhotoLoadImageProtocol = FlickrDataManager()
        let interactor = PhotoDetailInteractor()
        let presenter = PhotoDetailPresenter()
        viewController.presenter = presenter
        presenter.view = viewController
        interactor.presenter = presenter
        presenter.interactor = interactor
        interactor.imageDataManager = APIDataManager
    }
}
