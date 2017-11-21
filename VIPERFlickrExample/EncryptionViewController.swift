//
//  EncryptionViewController.swift
//  VIPERFlickrExample
//
//  Created by Kocharyan, Vahe on 11/19/17.
//  Copyright © 2017 Kocharyan, Vahe. All rights reserved.
//

import UIKit


class EncryptionViewController: UIViewController {
    
    weak var selectedImage: UIImage!

    @IBOutlet weak var imageToBase64TextView: UITextView!
    @IBOutlet weak var base64ToMD5TextView: UITextView!
    @IBOutlet weak var base64ToUIImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fill()
    }
    
    func fill() {
        let base64Text = imageToBase64(image: self.selectedImage)
        imageToBase64TextView.text = base64Text
        let stringConvertedToMD5 = base64Text?.toMD5()
        base64ToMD5TextView.text = stringConvertedToMD5
        if let base64Txt = base64Text {
            let convertedImage = base64ToUIImage(base64Text: base64Txt)
            base64ToUIImageView.image = convertedImage
        }
    }
    
    func imageToBase64(image: UIImage) -> String? {
        let imageData = UIImagePNGRepresentation(image)
        let base64String = imageData?.base64EncodedString(options: .lineLength64Characters)
        return base64String
    }
    
    func base64ToUIImage(base64Text: String) -> UIImage? {
        if let decodedData = Data(base64Encoded: base64Text, options: .ignoreUnknownCharacters) {
            let image = UIImage(data: decodedData)
            return image
        }
        return nil
    }
    
    @IBAction func backTapped(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension String {
    func toMD5()  -> String {
        if let messageData = self.data(using:String.Encoding.utf8) {
            var digestData = Data(count: Int(CC_MD5_DIGEST_LENGTH))
            _ = digestData.withUnsafeMutableBytes {digestBytes in
                messageData.withUnsafeBytes {messageBytes in
                    CC_MD5(messageBytes, CC_LONG((messageData.count)), digestBytes)
                }
            }
            return digestData.hexString()
        }
        return self
    }
}

extension Data {
    func hexString() -> String {
        let string = self.map{ String($0, radix:16) }.joined()
        return string
    }
}
