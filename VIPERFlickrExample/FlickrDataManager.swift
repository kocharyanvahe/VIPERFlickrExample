//
//  FlickrDataManager.swift
//  VIPERFlickrExample
//
//  Created by Kocharyan, Vahe on 11/18/17.
//  Copyright © 2017 Kocharyan, Vahe. All rights reserved.
//

import Foundation
import SDWebImage

protocol FlickrPhotoSearchProtocol: class {
    func fetchPhotosForSearchText(searchText: String, page: Int, closure: @escaping (Error?, Int, [FlickrPhotoModel]?) -> Void) -> Void
}

protocol FlickrPhotoLoadImageProtocol: class {
    func loadImageFromUrl(_ url: URL, closure: @escaping (UIImage?, Error?) -> Void)
}

class FlickrDataManager: FlickrPhotoSearchProtocol, FlickrPhotoLoadImageProtocol {
    
    //Memory Cache Photo services
    func loadImageFromUrl(_ url: URL, closure: @escaping (UIImage?, Error?) -> Void) {
        SDWebImageManager.shared().imageDownloader?.downloadImage(with: url as URL!, options: .useNSURLCache, progress: nil, completed: { (image, cache, error, finished) in
            if ((image != nil) && finished) {
                closure(image, error as Error?)
            }
        })
    }
    
    struct Errors {
        static let invalidAccessErrorCode = 100
    }
    
    struct FlickerAPIMetadataKeys {
        static let failureStatusCode = "code"
    }
    
    struct FlickrAPI {
        static let APIKey = "256f876f8852b9f6328632d38486e995"
        static let tagsSearchFormat = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=%@&tags=%@&page=%i&format=json&nojsoncallback=1"
    }
    
    func fetchPhotosForSearchText(searchText: String, page: Int, closure: @escaping (Error?, Int, [FlickrPhotoModel]?) -> Void) -> Void {
        let escapedSearchText = searchText.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        let format = FlickrAPI.tagsSearchFormat
        let arguments: [CVarArg] = [FlickrAPI.APIKey, escapedSearchText!, page]
        let photosURL = String(format: format, arguments: arguments)
        let url = URL(string: photosURL)!
        let request = URLRequest(url: url as URL)
        let searchTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil {
                print("Error fetching photos: \(String(describing: error?.localizedDescription))")
                closure(error as Error?, 0, nil)
            }
            do {
                let resultsDictionary = try JSONSerialization.jsonObject(with: data!, options: []) as? [String : AnyObject]
                guard let results = resultsDictionary else { return }
                if let statusCode = results[FlickerAPIMetadataKeys.failureStatusCode] as? Int {
                    if statusCode == Errors.invalidAccessErrorCode {
                        let invalidAccessError = NSError(domain: "FlickrAPIDomain", code: statusCode, userInfo: nil)
                        closure(invalidAccessError, 0, nil)
                        return
                    }
                }
                guard let photosContainer = resultsDictionary!["photos"] as? NSDictionary else { return }
                guard let totalPageCountString = photosContainer["total"] as? String else { return }
                guard let totalPageCount = NSInteger(totalPageCountString as String) else { return }
                guard let photosArray = photosContainer["photo"] as? [NSDictionary] else { return }
                let flickrPhotos: [FlickrPhotoModel] = photosArray.map({ (photoDictionary) -> FlickrPhotoModel in
                    let photoId = photoDictionary["id"] as? String ?? ""
                    let farm = photoDictionary["farm"] as? Int ?? 0
                    let secret = photoDictionary["secret"] as? String ?? ""
                    let server = photoDictionary["server"] as? String ?? ""
                    let title = photoDictionary["title"] as? String ?? ""
                    let flickrPhoto = FlickrPhotoModel(photoId: photoId, farm: farm, secret: secret, server: server, title: title)
                    return flickrPhoto
                })
                closure(nil, totalPageCount, flickrPhotos)
            } catch let error as NSError {
                print("Error parsing JSON: \(error)")
                closure(error, 0, nil)
                return
            }
        }
        searchTask.resume()
    }
}
