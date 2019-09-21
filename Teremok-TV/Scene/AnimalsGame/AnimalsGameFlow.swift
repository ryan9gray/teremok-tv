//
//  AnimalsGameFlow.swift
//  Teremok-TV
//
//  Created by Evgeny Ivanov on 02/06/2019.
//  Copyright © 2019 xmedia. All rights reserved.
//

import UIKit

class AnimalsGameFlow  {
    weak var master: AnimalsMasterViewController? = nil
    init(master: AnimalsMasterViewController) {
        self.master = master
        isHard = LocalStore.animalsIsHard
    }

    let service: AnimalsGameProtocol = AnimalsGameService()

    private var isHard: Bool = false
    var game: Game!
    var pack: Pack!
    var checkIntro: Bool = true

    func startFlow(_ number: Int) {
        showPack(idx: number)
    }



    private func showPack(idx: Int) {
        if checkIntro, !LocalStore.secondAnimalsIntroduce {
            checkIntro = false
            showWithIntroducePack(idx: idx)
            return
        }
        game = Game(pack: idx)
        generateAnimals()
        presentWords()
    }

    private func startRound() {
        guard game.round != 0 else {
            finishPack()
            return
        }
        presentRound(game.round)
    }

    private func sameRound() {
        presentRound(game.round)
    }

    private func presentRound(_ number: Int) {
        let controller = RoundPresentViewController.instantiate(fromStoryboard: .animals)
        controller.round = number
        master?.router?.introduceController(viewController: controller, completion: { finish in
            LocalStore.secondAnimalsIntroduce = finish
            if finish {
                OnDemandLoader.discardIntroducing(.introduceAnimals)
            }
            self.startChoice()
        })
    }

    private func presentWords() {
        let animals = generateRound()

        guard !animals.isEmpty else {
            finishPack()
            return
        }

        let controller = AnimalsWordsViewController.instantiate(fromStoryboard: .animals)
        controller.input = AnimalsWordsViewController.Input(animals:  animals)
        controller.output = AnimalsWordsViewController.Output(
            startChoice: startRound
        )
        master?.router?.presentModalChild(viewController: controller)
    }

    private func startChoice() {
        guard pack.roundAnimals.count > 0 else {
            finishRound()
            return
        }
        createChoice()
    }

    private func nextChoice(answer: Bool, time: Int) {
        game.answers.append(answer)
        game.roundTime += time
        startChoice()
    }

    private func createChoice() {
        let animal = randomChoice()
        if let image = randomAnimal(from: animal).image {
            presentChoice(animals: animal, image: image)
        }
    }

    private func randomAnimal(from: AnimalsGame.Animal) -> AnimalsGame.Animal {
        let index = Int.random(in: 0..<pack.allAnimals.count)
        if pack.allAnimals[index] == from {
            let newIndex = index < 47 ?  index + 1 : index - 1
            return pack.allAnimals[newIndex]
        } else {
            return pack.allAnimals[index]
        }
    }

    private func randomChoice() -> AnimalsGame.Animal {
        let index = Int.random(in: 0..<pack.roundAnimals.count)
        let animal = pack.roundAnimals[index]
        pack.roundAnimals.remove(at: index)
        return animal
    }

    private func presentChoice(animals: AnimalsGame.Animal, image: UIImage) {
        let controller = ChoiceAnimalViewController.instantiate(fromStoryboard: .animals)
        let points = game.answers.filter{$0}.count
        controller.input = ChoiceAnimalViewController.Input(animal: animals, wrongImage: image, isHard: isHard, points: points)
        controller.output = ChoiceAnimalViewController.Output(
            nextChoice: nextChoice
        )
        master?.router?.presentModalChild(viewController: controller)
    }

    private func presentResume(answers: [Bool]) {
        let controller = ResumeRoundViewController.instantiate(fromStoryboard: .animals)
        controller.input = ResumeRoundViewController.Input(answers: answers)
        controller.output = ResumeRoundViewController.Output(
            next: {
                guard let profile = Profile.current else {
                    self.authAlert()
                    return
                }
                guard profile.premiumGame else {
                    self.buyAlert()
                    return
                }
                self.game.nextRound()
                self.presentWords()
            },
            resume: sameRound
        )
        master?.router?.presentModalChild(viewController: controller)
    }

    private func finishRound() {
        service.sendStat(
            difficulty: isHard ? 1 : 0,
            pack: game.pack,
            duration: game.roundTime,
            correctCount: game.answers.filter{$0}.count,
            totalCount: game.answers.count,
            round: game.round
        ) { _ in }
        presentResume(answers: game.answers)
        game.reset()
    }

    private func finishPack() {
        master?.router?.popChild()
    }

    private func showWithIntroducePack(idx: Int) {
        let controller = IntroduceVideoViewController.instantiate(fromStoryboard: .common)
        controller.video = .start
        master?.router?.introduceController(viewController: controller, completion: { finish in
            LocalStore.secondAnimalsIntroduce = finish
            self.showPack(idx: idx)
        })
    }

    private func buyAlert() {
        let vc = CloudAlertViewController.instantiate(fromStoryboard: .alerts)
        let text = Main.Messages.buyGames
        vc.model = AlertModel(title: "", subtitle: text, buttonTitle: "В настройки")
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        vc.complition = { [weak self] in
            self?.master?.openSettings()
        }
        master?.presentAlertModally(alertController: vc)
    }

    private func authAlert() {
        master?.presentCloud(title: "", subtitle: Main.Messages.auth, button: "Зарегистрироваться") { [weak self] in
            self?.master?.openAutorization()
        }
    }

    // MARK: Logic

    func generateAnimals() {
        if game.pack == 1 {
            defaultPack()
        } else {
            localPack()
        }
    }

    func defaultPack() {
        let names = Array(AnimalsGame.firstPack.keys)
        var animals: [AnimalsGame.Animal] = []
        let urls = getSounds(roundNamesAnimals: names)
        let images = getImages(roundNamesAnimals: names)
        for i in 0..<names.count {
            animals.append(AnimalsGame.Animal(name: AnimalsGame.firstPack[names[i]] ?? "", image: images[i], sound: urls[i]))
        }
        pack = Pack(animals: animals, kind: .bundle)
    }

    func localPack() {
        let localAnimals = AppCacher.mappable.getArray(of: AnimalsGame.AnimalLocal.self, withId: "Pack_\(game.pack.stringValue)").array

        let fileManager = FileManager.default
        guard var documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Animals") else { return }
        do {
            documentsURL.appendPathComponent(game.pack.stringValue)
            let fileURLs = try fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
            print(fileURLs.debugDescription)
            let soundUrls = fileURLs.filter({$0.pathExtension == "mp3"}).sorted { $0.lastPathComponent < $1.lastPathComponent }
            let imageUrls = fileURLs.filter({$0.pathExtension == "png"}).sorted { $0.lastPathComponent < $1.lastPathComponent }
            var animals: [AnimalsGame.Animal] = []
            for animal in localAnimals {
                guard
                    let pngUrl = imageUrls.filter({$0.lastPathComponent == animal.image}).first,
                    let soundUrl = soundUrls.filter({$0.lastPathComponent == animal.sound}).first,
                    let image = UIImage(contentsOfFile: pngUrl.path)
                else { return }

                animals.append(AnimalsGame.Animal(name: animal.name, image: image, sound: soundUrl))
            }

            pack = Pack(animals: animals, kind: .local)
        } catch {
            print("Error while enumerating files \(documentsURL.path): \(error.localizedDescription)")
        }
    }

    func generateRound() -> [AnimalsGame.Animal] {
        let isFirst = game.pack == 1 && game.round == 1
        if isFirst, (!Profile.isAuthorized || !(Profile.current?.premiumGame ?? false)) {
            let first = pack.allAnimals.filter { AnimalsGame.firstRound.contains($0.name) } //prefix(8)
            first.forEach { pack.currentAnimals.remove($0) }
            pack.roundAnimals = Array(first)
            return pack.roundAnimals
        }
        var animals: [AnimalsGame.Animal] = []
        let limit = game.round == 1 ? 8 : 10
        for _ in 0..<limit {
            guard let animal = pack.currentAnimals.randomElement() else {
                return animals
            }
            pack.currentAnimals.remove(animal)
            animals.append(animal)
        }
        pack.roundAnimals = animals
        return pack.roundAnimals
    }

    func getImages(roundNamesAnimals: [String]) -> [UIImage] {
        var images: [UIImage] = []
        for name in roundNamesAnimals {
            images.append(UIImage(named: name)!)
        }
        return images
    }

    func getSounds(roundNamesAnimals: [String]) -> [URL] {
        var urls: [URL] = []
        for animal in roundNamesAnimals {
            let path = Bundle.main.path(forResource: animal, ofType: "mp3")!
            let url = URL(fileURLWithPath: path)
            urls.append(url)
        }
        return urls
    }

    deinit {
        print("Logger: GameFlow deinit")
    }

    class Game {
        let pack: Int
        var round = 1
        var answers: [Bool] = []
        var roundTime: Int = 0

        init(pack: Int) {
            self.pack = pack
        }

        func reset() {
            answers = []
            roundTime = 0
        }

        @discardableResult
        func nextRound() -> Int {
            if round < 5 {
                round += 1
            } else {
                round = 0
            }
            return round
        }
    }

    struct Pack {
        let allAnimals: [AnimalsGame.Animal]
        var kind: Kind
        var currentAnimals: Set<AnimalsGame.Animal>
        var roundAnimals: [AnimalsGame.Animal] = []

        init(animals: [AnimalsGame.Animal], kind: Kind) {
            self.kind = kind
            allAnimals = animals
            currentAnimals = Set(animals)
        }
        enum Kind {
            case local
            case bundle
        }
    }
}
