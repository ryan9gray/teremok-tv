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
        }

        enum Prefetch: String {
            case alphabetSounds = "AlphabetSounds"
            case alphabetImages = "AlphabetImages"
            case animalsImage = "AnimalsImage"
            case animalsSounds = "AnimalsSounds"
            case monstersImage = "MonstersImage"
        }
        enum Initial: String {
            case onBoarding = "OnBoarding"
        }
    }

    lazy private var bundleResourceRequest = NSBundleResourceRequest(tags: Set(getTags + introducongGames))

    private var getTags: [String] {
        return Tags.Prefetch.allValues().map { $0.rawValue }
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

    func createRequest(tags: [String]) -> NSBundleResourceRequest {
        let bundleResourceRequest = NSBundleResourceRequest(tags: Set(tags))
        
        return bundleResourceRequest
    }

    private var introducongGames: [String] {
        var files: [String] = []
        if !LocalStore.alphaviteIntroduce {
            files.append(Tags.OnDemand.introduceAlphabet.rawValue)
        }
        if !LocalStore.monsterIntroduce {
            files.append(Tags.OnDemand.introduceMonsters.rawValue)
        }
        if !LocalStore.secondAnimalsIntroduce, !LocalStore.firstAnimalsIntroduce {
            files.append(Tags.OnDemand.introduceAnimals.rawValue)
        }
        if !LocalStore.onBoarding {
            files.append(Tags.Initial.onBoarding.rawValue)
        }
        return files
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
