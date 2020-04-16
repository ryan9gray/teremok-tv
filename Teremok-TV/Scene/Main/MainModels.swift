//
//  MainModels.swift
//  Teremok-TV
//
//  Created by R9G on 22.08.2018.
//  Copyright (c) 2018 xmedia. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

enum Main {
    struct RazdelItem {
        var title: String
        var link: String
        //TO DO:
        var topImagesURLs: [String]
    }

    enum Messages {
        static let accessPremium = "Для просмотра необходимо оформить «Дети+» " + resetSub
        static let accessMusic = "Для прослушивания необходимо оформить «Дети Супер +» " + resetSub
        static let resetSub = "Если у вас уже есть подписка, вам необходимо в настройках нажать на «Восстановить подписку»"
        static let buyIntelect = "Для полного доступа к игре необходимо оформить подписку «Интеллектум». Ежемесячно коллекция будет пополняться на 50 новых зверушек. Кроме этого вы получите доступ к музыкальному сервису и возможность загружать мультфильмы для просмотра их без интернета."
        static let auth = "Уважаемый пользователь, успеваемость в обучающих играх, скачивание музыки и мультфильмов возможно только после регистрации в приложении «Теремок-ТВ». Пройдите, пожалуйста, регистрацию (в разделе - «Настройки»)! Спасибо"
        static let buyGames = "Для полного доступа ко всем развивающим играм необходимо оформить подписку «Интеллектум». Кроме этого вы получите доступ к музыкальному сервису и возможность загружать мультфильмы для просмотра их без интернета."
    }
}

extension Main.RazdelItem: Hashable {

}
