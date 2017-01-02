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
    func testNewWord()
    {
        let word = WordsDataSource.sharedInstance.newWord(languageCode: "en")
        word.word = "Test English"
        word.translation = "Test Translation"

        XCTAssertEqual(word.word, "Test English")
        XCTAssertEqual(word.translation, "Test Translation")
        XCTAssertEqual(word.languageCode, "en")
    }
}
