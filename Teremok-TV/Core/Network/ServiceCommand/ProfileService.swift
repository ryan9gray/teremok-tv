//
//  ProfileService.swift
//  Teremok-TV
//
//  Created by R9G on 14/09/2018.
//  Copyright © 2018 xmedia. All rights reserved.
//

protocol ProfileProtocol {
    func getProfile(isNewSession: Bool, completion: @escaping (Result<GetProfileResponse>) -> Void)
    func getProfile(completion: @escaping (Result<GetProfileResponse>) -> Void)
    func switchChild(with id: String, completion: @escaping (Result<GetProfileResponse>) -> Void)
    func getAchievements(completion: @escaping (Result<[AchievementsResponse]>) -> Void)
}

struct ProfileService: ProfileProtocol {
    
    func getProfile(completion: @escaping (Result<GetProfileResponse>) -> Void) {
        GetProfileCommand().execute(success: { (responseObject) in
            completion(.success(responseObject))
        }) { (com, response) in
            if let error = response.error {
                completion(.failure(error))
            }
        }
    }

    func getProfile(isNewSession: Bool, completion: @escaping (Result<GetProfileResponse>) -> Void) {
        GetProfileCommand(isNewSession: isNewSession).execute(success: { (responseObject) in
            completion(.success(responseObject))
        }) { (com, response) in
            if let error = response.error {
                completion(.failure(error))
            }
        }
    }

    func switchChild(with id: String, completion: @escaping (Result<GetProfileResponse>) -> Void) {
        
        SwitchChildCommand(childId: id).execute(success: { (responseObject) in
            completion(.success(responseObject))
        }) { (com, response) in
            if let error = response.error {
                completion(.failure(error))
            }
        }
    }

    func getAchievements(completion: @escaping (Result<[AchievementsResponse]>) -> Void){

        GetAchievementsCommand().execute(success: { (responseObject) in
            completion(.success(responseObject))
        }) { (com, response) in
            if let error = response.error {
                completion(.failure(error))
            }
        }
    }
}
