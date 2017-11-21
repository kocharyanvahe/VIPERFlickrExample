//
//  PhotoSearchRouting.swift
//  VIPERFlickrExample
//
//  Created by Kocharyan, Vahe on 11/18/17.
//  Copyright © 2017 Kocharyan, Vahe. All rights reserved.
//

import UIKit

protocol PhotoSearchRouterInput: class {
    func navigateToPhotoDetail()
    func passDataToNextScene(_ segue: UIStoryboardSegue)
}

class PhotoSearchRouting: PhotoSearchRouterInput {
    
    weak var viewController: PhotoViewController!
    
    //MARK:- Navigation
    func navigateToPhotoDetail() {
        viewController.performSegue(withIdentifier: "ShowPhotoDetail", sender: nil)
    }
    
    func passDataToNextScene(_ segue: UIStoryboardSegue) {
        if segue.identifier == "ShowPhotoDetail" {
            passDataToShowPhotoDetailScene(segue)
        }
    }
    
    //navigate to another module
    func passDataToShowPhotoDetailScene(_ segue: UIStoryboardSegue) {
        if let selectedIndexPath = viewController.photoCollectionView.indexPathsForSelectedItems?.first {
            let selectedPhotoModel = viewController.photos[selectedIndexPath.row]
            let showDetailViewController = segue.destination as! PhotoDetailViewController
            showDetailViewController.presenter.saveSelectedPhotoModel(selectedPhotoModel)
        }
    }
}
