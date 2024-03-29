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

        enum OnDemand: String, CaseIterable {
            case introduceAlphabet = "IntroduceAlphabet"
            case introduceAnimals = "IntroduceAnimals"
            case introduceMonsters = "IntroduceMonsters"
            case introduceColorsGame = "IntroduceColorsGame"
        }

        enum Prefetch: String, CaseIterable {
            case alphabetSounds = "AlphabetSounds"
            case alphabetImages = "AlphabetImages"
            case animalsImage = "AnimalsImage"
            case animalsSounds = "AnimalsSounds"
            case monstersImage = "MonstersImage"
            case dinoImage = "DinosImage"
            case colorsGameImage = "ColorsGameImage"
            case colorsGameSounds = "ColorsGameSounds"
        }

		enum Puzzle: String, CaseIterable {
			case puzzleGameImages = "PuzzleGameImages"
		}
//        enum Initial: String, CaseIterable {
//            case onBoarding = "OnBoarding"
//        }
    }

    lazy private var bundleResourceRequest = NSBundleResourceRequest(tags: Set(getTags + introducongGames + [Tags.Puzzle.puzzleGameImages.rawValue]))

    private var getTags: [String] {
        return Tags.Prefetch.allCases.map { $0.rawValue }
    }

	var bundleResourceRequestPuzzles: NSBundleResourceRequest {
		let bundleResourceRequestPuzzles = NSBundleResourceRequest(tags: Set([Tags.Puzzle.puzzleGameImages.rawValue]))
		bundleResourceRequestPuzzles.loadingPriority = NSBundleResourceRequestLoadingPriorityUrgent
		return bundleResourceRequestPuzzles
	}

	func loadOnDemandPuzzleAssets(completion: @escaping (Bool) -> Void) {
		bundleResourceRequestPuzzles.conditionallyBeginAccessingResources { available in
			if available {
				completion(true)
			}
			else {
				self.beginAccessingResourcesPuzzle(completion: completion)
			}
		}
	}

	func beginAccessingResourcesPuzzle(completion: @escaping (Bool) -> Void) {
		self.bundleResourceRequestPuzzles.beginAccessingResources { error in
			if error != nil  {
				completion(false)
			} else {
				completion(true)
			}
		}
	}

    func loadOnDemandAssets(completion: @escaping (Result<Bool>) -> Void) {
        bundleResourceRequest.endAccessingResources()
        bundleResourceRequest.loadingPriority = NSBundleResourceRequestLoadingPriorityUrgent
        //Bundle.main.setPreservationPriority(0.8, forTags: Set(getTags))
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
        if !LocalStore.colorsGameIntroduce {
              files.append(Tags.OnDemand.introduceColorsGame.rawValue)
          }
        if !LocalStore.firstAnimalsIntroduce {
            files.append(Tags.OnDemand.introduceAnimals.rawValue)
        }
        if !LocalStore.secondAnimalsIntroduce {
            files.append(Tags.OnDemand.introduceAnimals.rawValue)
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
