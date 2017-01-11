//
//  WordsDataSourceTests.swift
//  Words
//
//  Created by Rafal Grodzinski on 01/01/2017.
//  Copyright © 2017 UnalignedByte. All rights reserved.
//

import XCTest
import CoreData
@testable import Words


class WordsDataSourceTests: XCTestCase
{
    override func setUp()
    {
        WordsDataSource.sharedInstance.deleteAllWords()
    }


    func testGetContext()
    {
        let context = WordsDataSource.sharedInstance.context
        XCTAssertNotNil(context)
    }


    func testNewWord()
    {
        let word = WordsDataSource.sharedInstance.newWord(forLanguageCode: "en", group: "Test")
        word.word = "Test English"
        word.translation = "Test Translation"
        WordsDataSource.sharedInstance.saveContext()

        XCTAssertEqual(word.word, "Test English")
        XCTAssertEqual(word.translation, "Test Translation")
        XCTAssertEqual(word.languageCode, "en")
        XCTAssertEqual(word.group, "Test")
    }


    func testFetchLangageCodes()
    {
        _ = WordsDataSource.sharedInstance.newWord(forLanguageCode: "en", group: "Test")
        _ = WordsDataSource.sharedInstance.newWord(forLanguageCode: "fr", group: "Test")
        _ = WordsDataSource.sharedInstance.newWord(forLanguageCode: "de", group: "Test")
        _ = WordsDataSource.sharedInstance.newWord(forLanguageCode: "de", group: "Test")
        WordsDataSource.sharedInstance.saveContext()

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


    func testFetchGroups()
    {
        _ = WordsDataSource.sharedInstance.newWord(forLanguageCode: "en", group: "group1")
        _ = WordsDataSource.sharedInstance.newWord(forLanguageCode: "en", group: "group1")
        _ = WordsDataSource.sharedInstance.newWord(forLanguageCode: "en", group: "group2")
        WordsDataSource.sharedInstance.saveContext()

        let groups = WordsDataSource.sharedInstance.groups(forLanguageCode: "en")
        XCTAssertEqual(groups.count, 2)

        var containsGroup1 = false
        var containsGroup2 = false

        for group in groups {
            switch group {
                case "group1":
                    containsGroup1 = true
                case "group2":
                        containsGroup2 = true
                default:
                    XCTFail()
            }
        }

        XCTAssertTrue(containsGroup1 && containsGroup2)
    }


    func testFetchWords()
    {
        _ = WordsDataSource.sharedInstance.newWord(forLanguageCode: "de", group: "group1")
        _ = WordsDataSource.sharedInstance.newWord(forLanguageCode: "de", group: "group1")
        _ = WordsDataSource.sharedInstance.newWord(forLanguageCode: "de", group: "group2")
        _ = WordsDataSource.sharedInstance.newWord(forLanguageCode: "de", group: "group2")
        _ = WordsDataSource.sharedInstance.newWord(forLanguageCode: "en", group: "group1")
        WordsDataSource.sharedInstance.saveContext()

        let words1 = WordsDataSource.sharedInstance.words(forLanguageCode: "de", group: "group1")
        XCTAssertEqual(words1.count, 2)

        let words2 = WordsDataSource.sharedInstance.words(forLanguageCode: "de", group: "group2")
        XCTAssertEqual(words2.count, 2)

        let words3 = WordsDataSource.sharedInstance.words(forLanguageCode: "en", group: "group1")
        XCTAssertEqual(words3.count, 1)
    }


    func testFetchWordsCount()
    {
        _ = WordsDataSource.sharedInstance.newWord(forLanguageCode: "fr", group: "group1")
        _ = WordsDataSource.sharedInstance.newWord(forLanguageCode: "fr", group: "group1")
        _ = WordsDataSource.sharedInstance.newWord(forLanguageCode: "fr", group: "group1")
        WordsDataSource.sharedInstance.saveContext()

        let wordsCount = WordsDataSource.sharedInstance.wordsCount(forLanguageCode: "fr", group: "group1")
        XCTAssertEqual(wordsCount, 3)
    }


    func testLoadWords()
    {
        WordsDataSource.sharedInstance.loadWords(fromFile: "Test.plist")
        WordsDataSource.sharedInstance.saveContext()

        let languageCodes = WordsDataSource.sharedInstance.languageCodes()
        XCTAssertEqual(languageCodes.count, 1)

        let groups = WordsDataSource.sharedInstance.groups(forLanguageCode: "en")
        XCTAssertEqual(groups.count, 2)

        let wordsCount = WordsDataSource.sharedInstance.wordsCount(forLanguageCode: "en", group: "Test 1")
        XCTAssertEqual(wordsCount, 3)
    }


    func testFetchRequestWordsInGroup()
    {
        _ = WordsDataSource.sharedInstance.newWord(forLanguageCode: "de", group: "group1")
        _ = WordsDataSource.sharedInstance.newWord(forLanguageCode: "de", group: "group1")
        let word1 = WordsDataSource.sharedInstance.newWord(forLanguageCode: "en", group: "group2")
        word1.word = "Word 1"
        let word2 = WordsDataSource.sharedInstance.newWord(forLanguageCode: "en", group: "group2")
        word2.word = "Word 2"
        let word3 = WordsDataSource.sharedInstance.newWord(forLanguageCode: "en", group: "group2")
        word3.word = "Word 3"
        _ = WordsDataSource.sharedInstance.newWord(forLanguageCode: "en", group: "group1")

        let fetchRequest = WordsDataSource.sharedInstance.fetchRequest(forLanguageCode: "en", group: "group2")
        let words = try? WordsDataSource.sharedInstance.context.fetch(fetchRequest)

        XCTAssertNotNil(words)

        XCTAssertEqual(words!.count, 3)
        XCTAssertTrue(words![0].order < words![1].order && words![1].order < words![2].order)
    }


    func testFetchRequestWords()
    {
        _ = WordsDataSource.sharedInstance.newWord(forLanguageCode: "de", group: "group1")
        _ = WordsDataSource.sharedInstance.newWord(forLanguageCode: "de", group: "group1")
        let word1 = WordsDataSource.sharedInstance.newWord(forLanguageCode: "en", group: "group2")
        word1.word = "Word 1"
        let word2 = WordsDataSource.sharedInstance.newWord(forLanguageCode: "en", group: "group2")
        word2.word = "Word 2"
        let word3 = WordsDataSource.sharedInstance.newWord(forLanguageCode: "en", group: "group2")
        word3.word = "Word 3"
        _ = WordsDataSource.sharedInstance.newWord(forLanguageCode: "en", group: "group1")

        let fetchRequest = WordsDataSource.sharedInstance.fetchRequest(forLanguageCode: "en")
        let words = try? WordsDataSource.sharedInstance.context.fetch(fetchRequest)

        XCTAssertNotNil(words)

        XCTAssertEqual(words!.count, 4)
        XCTAssertTrue(words![0].group! < words![1].group!)
        XCTAssertTrue(words![1].order < words![2].order && words![2].order < words![3].order)
    }
}
