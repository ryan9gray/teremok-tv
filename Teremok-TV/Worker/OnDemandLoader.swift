//
//  OnDemandLoader.swift
//  Teremok-TV
//
//  Created by Eugene Ivanov on 18/09/2019.
//  Copyright © 2019 xmedia. All rights reserved.
//
import Foundation

class OnDemandLoader {

    enum Tags {
        enum OnDemand: String {
            case introduceAlphabet = "IntroduceAlphabet"
            case introduceAnimals = "IntroduceAnimals"
            case introduceMonsters = "IntroduceMonsters"

        }
        enum Prefetch: String {
            case alphabetSounds = "AlphabetSounds"
        }
        enum Initial: String {
            case alphabetImages = "AlphabetImages"
            case animalsImage = "AnimalsImage"
            case animalsSounds = "AnimalsSounds"
            case monstersImage = "MonstersImage"
        }
    }

    private lazy var bundleResourceRequest = NSBundleResourceRequest(tags: Set(getTags()))

    func getTags() -> [String] {
        return Tags.Prefetch.allValues().map { $0.rawValue }
            + Tags.Initial.allValues().map { $0.rawValue }
            + Tags.OnDemand.allValues().map { $0.rawValue }
    }

    func loadOnDemandAssets() {
        introducongGames()
        bundleResourceRequest.conditionallyBeginAccessingResources { [unowned self] (available) in
            if available {
                //self.loadOnboardingAssets()
            } else {
                self.bundleResourceRequest.beginAccessingResources { (error) in
                    guard error == nil else { return }
                    //self.loadOnboardingAssets()
                }
            }
        }
    }

    private func introducongGames() {
        if !LocalStore.alphaviteIntroduce {
            getAccess(.introduceAlphabet)
        }
        if !LocalStore.monsterIntroduce {
            getAccess(.introduceMonsters)
        }
        if !LocalStore.secondAnimalsIntroduce, !LocalStore.firstAnimalsIntroduce {
            getAccess(.introduceAnimals)
        }
    }

    func getAccess(_ file: Tags.OnDemand) {
        NSBundleResourceRequest(tags: Set([file.rawValue])).conditionallyBeginAccessingResources { [unowned self] available in
            if available {
                //self.loadOnboardingAssets()
            } else {
                self.bundleResourceRequest.beginAccessingResources { (error) in
                    guard error == nil else { return }
                    //self.loadOnboardingAssets()
                }
            }
        }
    }

    static func discardIntroducing(_ file: Tags.OnDemand) {
        NSBundleResourceRequest(tags: Set([file.rawValue])).endAccessingResources()
    }

    private func discardOnDemandAssets() {
        bundleResourceRequest.endAccessingResources()
    }
}
