//
//  ImageLoader.swift
//  Teremok-TV
//
//  Created by R9G on 27/10/2018.
//  Copyright © 2018 xmedia. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage

struct ImageLoader {

    static func image(from url: String, complition: @escaping (UIImage) -> Void) {
        Alamofire.request(url).responseImage { response in
            if let image = response.result.value {
                complition(image)
            }
        }
    }
    
    func downloadFrom(url: URL, name: String) {
        Alamofire.request(url).responseImage { response in
            if let image = response.result.value {
                //print("image downloaded: \(image)")
                self.saveImageToDocumentDirectory(image: image, name: name)
            }
        }
    }
    func dataFrom(url: URL, comletion: @escaping (Data?) -> Void) {
        Alamofire.request(url).responseImage { response in
            comletion(response.result.value?.pngData())
        }
    }
    
    func saveImageToDocumentDirectory(image: UIImage, name: String) {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileName = name + ".png" // name of the image to be saved
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        if let data = image.pngData(),!FileManager.default.fileExists(atPath: fileURL.path){
            do {
                try data.write(to: fileURL)
                print("file saved")
            } catch {
                print("error saving file:", error)
            }
        }
        else {
            print("error saving")
        }
    }
    
    static func loadImageFromDocumentDirectory(nameOfImage : String) -> UIImage {
        let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let nsUserDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
        if let dirPath = paths.first{
            let imageURL = URL(fileURLWithPath: dirPath).appendingPathComponent(nameOfImage)
            let image    = UIImage(contentsOfFile: imageURL.path)
            return image!
        }
        return #imageLiteral(resourceName: "icNowifi")
    }
    
  
}
