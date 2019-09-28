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
    @IBOutlet private var titleImageView: UIImageView!
    @IBOutlet private var timeView: DesignableView!
    @IBOutlet private var timeLbl: UILabel!
    @IBOutlet private var nextBtn: KeyButton!
    @IBOutlet private var monstersView: UIImageView!
    
    @IBAction func openNextVC(_ sender: Any) {
        output.openNext()
    }

    struct Input {
        var gameResult: MonsterGameFlow.GameResults
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
            timeView.borderColor = UIColor.Button.redThree
            timeLbl.textColor = UIColor.Button.redThree
            titleImageView.image = UIImage(named: "playAgain")
            nextBtn.setImage(UIImage(named: "icAgainYellow"), for: .normal)
            nextBtn.gradientColors = Style.Gradients.red.value
            nextBtn.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            monstersView.image = UIImage(named: "monstersLose")
        }
        else {
            timeLbl.textColor = UIColor.View.Label.darkBlue
        }
    }
}
