//
//  DinoGameResultViewController.swift
//  Teremok-TV
//
//  Created by Виктор Пузаков on 06.04.2020.
//  Copyright © 2020 xmedia. All rights reserved.
//

import UIKit
import Spring

class DinoGameResultsViewController: GameViewController {
    @IBOutlet private var titleImageView: UIImageView!
    @IBOutlet private var timeView: DesignableView!
    @IBOutlet private var timeLbl: UILabel!
    @IBOutlet private var nextBtn: KeyButton!
    @IBOutlet private var dinosView: UIImageView!
    
    @IBAction func openNextVC(_ sender: Any) {
        output.openNext()
    }

    struct Input {
        var gameResult: DinoGameFlow.GameResults
    }

    struct Output {
        let openNext: () -> Void
    }
    var input: Input!
    var output: Output!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timeLbl.text = "Твое время \(PlayerHelper.stringFromTimeInterval(TimeInterval(input.gameResult.result)))"
        if !input.gameResult.gameWon {
            timeView.borderColor = UIColor.Button.orangeOne
            timeLbl.textColor = UIColor.Button.orangeOne
            titleImageView.image = UIImage(named: "dinoGameRepeatGame")
            nextBtn.setImage(UIImage(named: "icRepeatGame"), for: .normal)
            nextBtn.gradientColors = Style.Gradients.DinoGame.redReverse.value
            nextBtn.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            dinosView.image = UIImage(named: "ic-dinoGameLoseBack")
        }
        else {
            timeView.borderColor = UIColor.DinoGame.lightBlueTwo
            timeLbl.textColor = UIColor.DinoGame.lightBlueTwo
            nextBtn.gradientColors = Style.Gradients.lightOrange.value
        }
    }
}
