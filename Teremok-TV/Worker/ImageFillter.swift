//
//  ImageFillter.swift
//  Teremok-TV
//
//  Created by Evgeny Ivanov on 08/09/2019.
//  Copyright © 2019 xmedia. All rights reserved.
//
import UIKit

struct ImageFillter {
    func monochrome(_ image: UIImage?) -> UIImage? {
        guard let currentCGImage = image?.cgImage else { return nil }

        let currentCIImage = CIImage(cgImage: currentCGImage)
        let filter = CIFilter(name: "CIColorMonochrome")
        filter?.setValue(currentCIImage, forKey: "inputImage")
        // set a gray value for the tint color
        filter?.setValue(CIColor(red: 0.7, green: 0.7, blue: 0.7), forKey: "inputColor")
        filter?.setValue(1.0, forKey: "inputIntensity")

        guard let outputImage = filter?.outputImage else { return nil }

        let context = CIContext()

        if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
            let processedImage = UIImage(cgImage: cgimg)
            return processedImage
        }
        return nil
    }

    func blackAndWhiteControl(_ image: UIImage) -> UIImage? {
        guard let currentCGImage = image.cgImage else { return nil }
        let currentCIImage = CIImage(cgImage: currentCGImage)
        let blackAndWhiteImage = currentCIImage.applyingFilter("CIColorControls", parameters: ["inputSaturation": 0, "inputContrast": 1])
        return UIImage(ciImage: blackAndWhiteImage)
    }
}
