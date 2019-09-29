//
//  ColorGameContainer.swift
//  Teremok-TV
//
//  Created by Evgeny Ivanov on 29/09/2019.
//  Copyright © 2019 xmedia. All rights reserved.
//

import UIKit

class ColorGameContainer: UIView {
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var gradientView: GradientView!

    override func layoutSubviews() {
        super.layoutSubviews()

        gradientView.layer.cornerRadius = 18
    }

    override func awakeFromNib() {
        super.awakeFromNib()

    }

    func setState(_ state: ImageState) {
        imageView.image = state.image
    }

    func setGradient(_ gradient: ColorsMaster.Gradients) {
        gradientView.gradientColors = gradient.value
    }

    enum ImageState {
        case access
        case fail
        case brash

        var image: UIImage? {
            switch self {
                case .access:
                    return UIImage(named: "icMarkColorGame")
                case .fail:
                    return UIImage(named: "icCrossColorGame")
                case .brash:
                    return UIImage(named: "icBrush")
            }
        }
    }
}
