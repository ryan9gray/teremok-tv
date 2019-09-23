//
//  OnDemandLoader.swift
//  Teremok-TV
//
//  Created by Eugene Ivanov on 18/09/2019.
//  Copyright © 2019 xmedia. All rights reserved.
//
import Foundation

class OnDemandLoader {

    static let share = OnDemandLoader()

    enum Tags {

        enum OnDemand: String {
            case introduceAlphabet = "IntroduceAlphabet"
            case introduceAnimals = "IntroduceAnimals"
            case introduceMonsters = "IntroduceMonsters"
            //case onBoarding = "OnBoarding"
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

    lazy private var bundleResourceRequest = NSBundleResourceRequest(tags: Set(getTags + introducongGames))

    private var getTags: [String] {
        return Tags.Initial.allValues().map { $0.rawValue }
            + Tags.Prefetch.allValues().map { $0.rawValue }
    }

    func loadOnDemandAssets(completion: @escaping (Result<Bool>) -> Void) {
        bundleResourceRequest.endAccessingResources()
        bundleResourceRequest.conditionallyBeginAccessingResources { [unowned self] available in
            if available {
                completion(.success(true))
            } else {
                self.bundleResourceRequest.beginAccessingResources { error in
                    guard let error = error else { return }

                    completion(.failure(error))
                }
            }
        }
    }

    private var introducongGames: [String] {
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
        return files.map { $0.rawValue }
    }

    func getAccess(_ file: Tags.OnDemand, completion: @escaping (Result<Bool>) -> Void) {
        getAccess(file.rawValue, completion: completion)
    }

    func getAccess(_ file: String, completion: @escaping (Result<Bool>) -> Void) {
        NSBundleResourceRequest(tags: Set([file])).conditionallyBeginAccessingResources { [unowned self] available in
            if available {
                completion(.success(true))
            } else {
                self.bundleResourceRequest.beginAccessingResources { error in
                    guard let error = error else { return }

                    completion(.failure(error))
                }
            }
        }
    }


}
