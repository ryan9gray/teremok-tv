//
//  GamesListViewController.swift
//  Teremok-TV
//
//  Created by Evgeny Ivanov on 01/08/2019.
//  Copyright © 2019 xmedia. All rights reserved.
//

import UIKit

class GamesListViewController: AbstracViewController {
    var output: Output!

    struct Output {
        var openAnimals: () -> Void
        var openAlphavite: () -> Void
    }

    @IBOutlet private var titleLabel: StrokeLabel!
    @IBOutlet private var homeBtn: KeyButton!

    @IBAction private func homeClick(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func animalsTap(_ sender: Any) {
        self.dismiss(animated: true) {
            self.output.openAnimals()
        }
    }

    @IBAction func alphaviteTap(_ sender: Any) {
        self.dismiss(animated: true) {
            self.output.openAlphavite()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        homeBtn.gradientColors = Styles.Gradients.brown.value
        titleLabel.attributedText = "ВЫБЕРИТЕ ИГРУ:" <~ Styles.TextAttributes.gameList
        titleLabel.textColor = .white
        titleLabel.strokeSize = 12.0
        titleLabel.strokePosition = .center
        titleLabel.gradientColors = Styles.Gradients.blue.value
    }

}
