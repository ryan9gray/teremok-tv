//
//  AlphaviteMasterModels.swift
//  Teremok-TV
//
//  Created by Evgeny Ivanov on 01/08/2019.
//  Copyright (c) 2019 xmedia. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

enum AlphaviteMaster {
  
    static let DefaultChars = [
        "А",
        "Р",
        "Е"
    ]

    enum PickAnimations: String {
        case start = "start_Pick"
        case end = "end_Pick"
        case happyOne = "happy_Pick_1"
    }

    struct Statistic {
        let char: String
        let seconds: Int
        let isRight: Bool

        func maping() -> AlphaviteStatistic {
            let mapa = AlphaviteStatistic.init(char: char, seconds: seconds, isRight: isRight)
            return mapa
        }
    }

    static let Names = [
        "alphavite_1_word_1": "Аист", "alphavite_1_word_2": "Арбуз",
        "alphavite_2_word_1": "Бобр", "alphavite_2_word_2": "Блин",
        "alphavite_3_word_1": "Ведро", "alphavite_3_word_2": "Ворона",
        "alphavite_4_word_1": "Горы", "alphavite_4_word_2": "Гусь",
        "alphavite_5_word_1": "Дерево", "alphavite_5_word_2": "Динозавр",
        "alphavite_6_word_1": "Единорог", "alphavite_6_word_2": "Енот",
        "alphavite_7_word_1": "Ёжик", "alphavite_7_word_2": "Ёлка",
        "alphavite_8_word_1": "Жёлудь", "alphavite_8_word_2": "Жираф",
        "alphavite_9_word_1": "Земля", "alphavite_9_word_2": "Зонт",
        "alphavite_10_word_1": "Индеец", "alphavite_10_word_2": "Индюк",
        "alphavite_11_word_1": "Йогурт", "alphavite_11_word_2": "Йод",
        "alphavite_12_word_1": "Кисточка", "alphavite_12_word_2": "Краски",
        "alphavite_13_word_1": "Листик", "alphavite_13_word_2": "Лошадка",
        "alphavite_14_word_1": "Морковка", "alphavite_14_word_2": "Мост",
        "alphavite_15_word_1": "Нитки", "alphavite_15_word_2": "Носорог",
        "alphavite_16_word_1": "Орёл", "alphavite_16_word_2": "Орех",
        "alphavite_17_word_1": "Подарок", "alphavite_17_word_2": "Птицы",
        "alphavite_18_word_1": "Рак", "alphavite_18_word_2": "Ручей",
        "alphavite_19_word_1": "Самолёт", "alphavite_19_word_2": "Стул",
        "alphavite_20_word_1": "Таракан", "alphavite_20_word_2": "Трактор",
        "alphavite_21_word_1": "Улитка", "alphavite_21_word_2": "Утка",
        "alphavite_22_word_1": "Фонарь", "alphavite_22_word_2": "Фрукты",
        "alphavite_23_word_1": "Хлеб", "alphavite_23_word_2": "Хорёк",
        "alphavite_24_word_1": "Цветы", "alphavite_24_word_2": "Циплёнок",
        "alphavite_25_word_1": "Черепаха", "alphavite_25_word_2": "Чеснок",
        "alphavite_26_word_1": "Шиповник", "alphavite_26_word_2": "Шишка",
        "alphavite_27_word_1": "Щётка", "alphavite_27_word_2": "Щука",
        "alphavite_28_word_1": "Ъ", "alphavite_28_word_2": "Ъ",
        "alphavite_29_word_1": "Ы", "alphavite_29_word_2": "Ы",
        "alphavite_30_word_1": "Ь", "alphavite_30_word_2": "Ь",
        "alphavite_31_word_1": "Экран", "alphavite_31_word_2": "Эскимо",
        "alphavite_32_word_1": "Юнга", "alphavite_32_word_2": "Юпитер",
        "alphavite_33_word_1": "Яблоко", "alphavite_33_word_2": "Ястреб"
    ]



    static let Char = [
        "А": "alphavite_1",
        "Б": "alphavite_2",
        "В": "alphavite_3",
        "Г": "alphavite_4",
        "Д": "alphavite_5",
        "Е": "alphavite_6",
        "Ё": "alphavite_7",
        "Ж": "alphavite_8",
        "З": "alphavite_9",
        "И": "alphavite_10",
        "Й": "alphavite_11",
        "К": "alphavite_12",
        "Л": "alphavite_13",
        "М": "alphavite_14",
        "Н": "alphavite_15",
        "О": "alphavite_16",
        "П": "alphavite_17",
        "Р": "alphavite_18",
        "С": "alphavite_19",
        "Т": "alphavite_20",
        "У": "alphavite_21",
        "Ф": "alphavite_22",
        "Х": "alphavite_23",
        "Ц": "alphavite_24",
        "Ч": "alphavite_25",
        "Ш": "alphavite_26",
        "Щ": "alphavite_27",
        "Ъ": "alphavite_28",
        "Ы": "alphavite_29",
        "Ь": "alphavite_30",
        "Э": "alphavite_31",
        "Ю": "alphavite_32",
        "Я": "alphavite_33"
    ]

    static let Words = [
        "А": ["alphavite_1_word_1", "alphavite_1_word_2"],
        "Б": ["alphavite_2_word_1", "alphavite_2_word_2"],
        "В": ["alphavite_3_word_1", "alphavite_3_word_2"],
        "Г": ["alphavite_4_word_1", "alphavite_4_word_2"],
        "Д": ["alphavite_5_word_1", "alphavite_5_word_2"],
        "Е": ["alphavite_6_word_1", "alphavite_6_word_2"],
        "Ё": ["alphavite_7_word_1", "alphavite_7_word_2"],
        "Ж": ["alphavite_8_word_1", "alphavite_8_word_2"],
        "З": ["alphavite_9_word_1", "alphavite_9_word_2"],
        "И": ["alphavite_10_word_1", "alphavite_10_word_2"],
        "Й": ["alphavite_11_word_1", "alphavite_11_word_2"],
        "К": ["alphavite_12_word_1", "alphavite_12_word_2"],
        "Л": ["alphavite_13_word_1", "alphavite_13_word_2"],
        "М": ["alphavite_14_word_1", "alphavite_14_word_2"],
        "Н": ["alphavite_15_word_1", "alphavite_15_word_2"],
        "О": ["alphavite_16_word_1", "alphavite_16_word_2"],
        "П": ["alphavite_17_word_1", "alphavite_17_word_2"],
        "Р": ["alphavite_18_word_1", "alphavite_18_word_2"],
        "С": ["alphavite_19_word_1", "alphavite_19_word_2"],
        "Т": ["alphavite_20_word_1", "alphavite_20_word_2"],
        "У": ["alphavite_21_word_1", "alphavite_21_word_2"],
        "Ф": ["alphavite_22_word_1", "alphavite_22_word_2"],
        "Х": ["alphavite_23_word_1", "alphavite_23_word_2"],
        "Ц": ["alphavite_24_word_1", "alphavite_24_word_2"],
        "Ч": ["alphavite_25_word_1", "alphavite_25_word_2"],
        "Ш": ["alphavite_26_word_1", "alphavite_26_word_2"],
        "Щ": ["alphavite_27_word_1", "alphavite_27_word_2"],
        "Ъ": ["alphavite_28_word_1", "alphavite_28_word_2"],
        "Ы": ["alphavite_29_word_1", "alphavite_29_word_2"],
        "Ь": ["alphavite_30_word_1", "alphavite_30_word_2"],
        "Э": ["alphavite_31_word_1", "alphavite_31_word_2"],
        "Ю": ["alphavite_32_word_1", "alphavite_32_word_2"],
        "Я": ["alphavite_33_word_1", "alphavite_33_word_2"]
    ]
}
