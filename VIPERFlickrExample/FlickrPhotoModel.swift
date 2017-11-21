//
//  FlickrPhotoModel.swift
//  VIPERFlickrExample
//
//  Created by Kocharyan, Vahe on 11/18/17.
//  Copyright © 2017 Kocharyan, Vahe. All rights reserved.
//

import Foundation

struct FlickrPhotoModel {
    let photoId: String
    let farm: Int
    let secret: String
    let server: String
    let title: String
    
    var photoUrl: URL {
        return flickrImageURL()
    }
    
    var largePhotoUrl: URL {
        return flickrImageURL(size: "b")
    }
    
    private func flickrImageURL(size: String = "m") -> URL {
        return URL(string: "https://farm\(farm).staticflickr.com/\(server)/\(photoId)_\(secret)_\(size).jpg")!
    }
}
