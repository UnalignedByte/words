//
//  WordsDataSourceTests.swift
//  Words
//
//  Created by Rafal Grodzinski on 01/01/2017.
//  Copyright © 2017 UnalignedByte. All rights reserved.
//

import XCTest
@testable import Words


class WordsDataSourceTests: XCTestCase
{
    func testGetContext()
    {
        let context = WordsDataSource.sharedInstance.context
        XCTAssertNotNil(context)
    }


    func testNewWord()
    {
        let word = WordsDataSource.sharedInstance.newWord(forLanguageCode: "en")
        word.word = "Test English"
        word.translation = "Test Translation"

        XCTAssertEqual(word.word, "Test English")
        XCTAssertEqual(word.translation, "Test Translation")
        XCTAssertEqual(word.languageCode, "en")
    }


    func testAvailableLangageCodes()
    {
        _ = WordsDataSource.sharedInstance.newWord(forLanguageCode: "en")
        _ = WordsDataSource.sharedInstance.newWord(forLanguageCode: "fr")
        _ = WordsDataSource.sharedInstance.newWord(forLanguageCode: "de")
        _ = WordsDataSource.sharedInstance.newWord(forLanguageCode: "de")

        let codes = WordsDataSource.sharedInstance.languageCodes()

        XCTAssertEqual(codes.count, 3)

        var containsEn = false
        var containsFr = false
        var containsDe = false

        for code in codes {
            switch code {
                case "en":
                    containsEn = true
                case "fr":
                    containsFr = true
                case "de":
                    containsDe = true
            default:
                XCTFail()
            }
        }

        XCTAssertTrue(containsEn && containsFr && containsDe)
    }
}
