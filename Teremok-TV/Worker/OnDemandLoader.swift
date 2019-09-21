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
            case onBoarding = "OnBoarding"
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


    func getTags() -> [String] {
        return Tags.Prefetch.allValues().map { $0.rawValue }
            + Tags.Initial.allValues().map { $0.rawValue }
    }

    func loadOnDemandAssets() {
        let tags = getTags() + introducongGames()
        let bundleResourceRequest = NSBundleResourceRequest(tags: Set(tags))
        bundleResourceRequest.conditionallyBeginAccessingResources { available in
            if available {
                //self.loadOnboardingAssets()
            } else {
                bundleResourceRequest.beginAccessingResources { error in
                    guard error == nil else { return }
                    
                    print("OnDemand Error: \(error.debugDescription)")
                }
            }
        }
    }

    private func introducongGames() -> [String] {
        var files: [Tags.OnDemand] = []
        if !LocalStore.alphaviteIntroduce {
            files.append(.introduceAlphabet)
        }
        if !LocalStore.monsterIntroduce {
            files.append(.introduceMonsters)
        }
        if !LocalStore.secondAnimalsIntroduce, !LocalStore.firstAnimalsIntroduce {
            files.append(.introduceAnimals)
        }
        if !LocalStore.onBoarding {
            files.append(.onBoarding)
        }
        return files.map { $0.rawValue }
    }

    static func discardIntroducing(_ file: Tags.OnDemand) {
        NSBundleResourceRequest(tags: Set([file.rawValue])).endAccessingResources()
    }
}
