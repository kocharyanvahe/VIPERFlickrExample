//
//  PhotoDetailViewController.swift
//  VIPERFlickrExample
//
//  Created by Kocharyan, Vahe on 11/18/17.
//  Copyright © 2017 Kocharyan, Vahe. All rights reserved.
//

import UIKit

protocol PhotoDetailViewControllerInput: class {
    func addLargeLoadedPhoto(_ photo: UIImage)
    func addPhotoImageTitle(_ title: String)
}

protocol PhotoDetailViewControllerOutput: class {
    func saveSelectedPhotoModel(_ photoModel: FlickrPhotoModel)
    func loadLargePhotoImage()
    func getPhotoImageTitle()
}

class PhotoDetailViewController: UIViewController, PhotoDetailViewControllerInput {
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var photoTitleLabel: UILabel!
    
    var presenter: PhotoDetailViewControllerOutput!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        PhotoDetailAssembly.sharedInstance.configure(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //ask title and image from presenter
        self.presenter.getPhotoImageTitle()
        self.presenter.loadLargePhotoImage()
    }
    
    //result comes from presenter
    func addLargeLoadedPhoto(_ photo: UIImage) {
        self.photoImageView.image = photo
    }
    
    func addPhotoImageTitle(_ title: String) {
        self.navigationBar.topItem?.title = title
        self.photoTitleLabel.text = title
    }

    @IBAction func backTapped(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EncryptionSegue" {
            if let navController = segue.destination as? UINavigationController {
                if let encryptionVC = navController.topViewController as? EncryptionViewController {
                    encryptionVC.selectedImage = self.photoImageView.image
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
