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

    static func image(from url: String, complition: @escaping (UIImage?) -> Void) {
        AF.request(url).responseImage { response in
			switch response.result {
				case .success(let image):
					complition(image)
				case .failure:
					complition(nil)
			}
        }
    }
    
    func downloadFrom(url: URL, name: String) {
        AF.request(url).responseImage { response in
			switch response.result {
				case .success(let image):
					self.saveImageToDocumentDirectory(image: image, name: name)
				case .failure:
					return
			}
        }
    }
    func dataFrom(url: URL, comletion: @escaping (Data?) -> Void) {
        AF.request(url).responseImage { response in
			switch response.result {
				case .success(let image):
					comletion(image.pngData())
				case .failure:
					return
			}
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
