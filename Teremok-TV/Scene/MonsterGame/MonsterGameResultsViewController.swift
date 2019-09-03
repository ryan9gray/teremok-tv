//
//  MonsterGameResultsViewController.swift
//  Teremok-TV
//
//  Created by Дмитрий Грищенко on 30/08/2019.
//  Copyright © 2019 xmedia. All rights reserved.
//

import UIKit
import Spring

class MonsterGameResultsViewController: GameViewController {

    @IBOutlet private var BGImageView: UIImageView!
    @IBOutlet private var titleImageView: UIImageView!
    @IBOutlet private var timeView: DesignableView!
    @IBOutlet private var timeLbl: UILabel!
    @IBOutlet private var nextBtn: KeyButton!
    
    var input: Input!
    var output: Output!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timeLbl.text = "Твое время \(PlayerHelper.stringFromTimeInterval(TimeInterval(input.gameResult.result)))"
        if !input.gameResult.gameWon {
            timeView.borderColor = UIColor.Button.redThree
            timeLbl.textColor = UIColor.Button.redThree
            BGImageView.image = UIImage(named: "gameLostBG")
            titleImageView.image = UIImage(named: "playAgain")
            nextBtn.setImage(UIImage(named: "icAgainYellow"), for: .normal)
            nextBtn.gradientColors = Styles.Gradients.red.value
        }
    }
    
    struct Input {
        var gameResult: MonsterGameFlow.GameResults
    }

    struct Output {
        let openNext: () -> Void
    }
    
    @IBAction func openNextVC(_ sender: Any) {
        output.openNext()
    }
    
}
