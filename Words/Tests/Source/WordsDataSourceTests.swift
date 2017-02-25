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
        WordsDataSource.sharedInstance.deleteAllGroups(forLanguageCode: "en")
        WordsDataSource.sharedInstance.deleteAllGroups(forLanguageCode: "de")
        WordsDataSource.sharedInstance.deleteAllGroups(forLanguageCode: "fr")
    }


    func testGetContext()
    {
        let context = WordsDataSource.sharedInstance.context
        XCTAssertNotNil(context)
    }


    // MARK: - Groups
    func testNewGroup()
    {
        let group = WordsDataSource.sharedInstance.newGroup(forLanguageCode: "en")
        group.name = "Test Group"
        WordsDataSource.sharedInstance.saveContext()

        XCTAssertEqual(group.name, "Test Group")
        XCTAssertEqual(group.languageCode, "en")
        XCTAssertEqual(group.words!.count, 0)
    }


    func testDeleteGroup()
    {
        let groupA = WordsDataSource.sharedInstance.newGroup(forLanguageCode: "en")
        _ = WordsDataSource.sharedInstance.newGroup(forLanguageCode: "en")
        WordsDataSource.sharedInstance.delete(group: groupA)
        WordsDataSource.sharedInstance.saveContext()

        let count = WordsDataSource.sharedInstance.groupsCount(forLanguageCode: "en")
        XCTAssertEqual(count, 1)
    }


    func testFetchGroups()
    {
        let group1 = WordsDataSource.sharedInstance.newGroup(forLanguageCode: "en")
        group1.name = "group1"
        let group2 = WordsDataSource.sharedInstance.newGroup(forLanguageCode: "en")
        group2.name = "group2"
        WordsDataSource.sharedInstance.saveContext()

        let groups = WordsDataSource.sharedInstance.groups(forLanguageCode: "en")
        XCTAssertEqual(groups.count, 2)

        var containsGroup1 = false
        var containsGroup2 = false

        for group in groups {
            switch group.name! {
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


    func testGroupsCount()
    {
        _ = WordsDataSource.sharedInstance.newGroup(forLanguageCode: "de")
        _ = WordsDataSource.sharedInstance.newGroup(forLanguageCode: "de")
        _ = WordsDataSource.sharedInstance.newGroup(forLanguageCode: "en")
        WordsDataSource.sharedInstance.saveContext()

        let countDe = WordsDataSource.sharedInstance.groupsCount(forLanguageCode: "de")
        XCTAssertEqual(countDe, 2)

        let countEn = WordsDataSource.sharedInstance.groupsCount(forLanguageCode: "en")
        XCTAssertEqual(countEn, 1)
    }


    // MARK: - Words
    func testNewWord()
    {
        let group = WordsDataSource.sharedInstance.newGroup(forLanguageCode: "en")
        let word = WordsDataSource.sharedInstance.newWord(forGroup: group)
        word.word = "Test English"
        word.translation = "Test Translation"
        WordsDataSource.sharedInstance.saveContext()

        XCTAssertEqual(word.word, "Test English")
        XCTAssertEqual(word.translation, "Test Translation")
    }


    func testFetchWords()
    {
        let groupDe1 = WordsDataSource.sharedInstance.newGroup(forLanguageCode: "de")
        groupDe1.name = "group1"

        let groupDe2 = WordsDataSource.sharedInstance.newGroup(forLanguageCode: "de")
        groupDe2.name = "group2"

        let groupEn = WordsDataSource.sharedInstance.newGroup(forLanguageCode: "en")
        groupEn.name = "group1"

        _ = WordsDataSource.sharedInstance.newWord(forGroup: groupDe1)
        _ = WordsDataSource.sharedInstance.newWord(forGroup: groupDe1)
        _ = WordsDataSource.sharedInstance.newWord(forGroup: groupDe2)
        _ = WordsDataSource.sharedInstance.newWord(forGroup: groupDe2)
        _ = WordsDataSource.sharedInstance.newWord(forGroup: groupEn)
        WordsDataSource.sharedInstance.saveContext()

        let words1 = WordsDataSource.sharedInstance.words(forLanguageCode: "de")
        XCTAssertEqual(words1.count, 4)

        let words2 = WordsDataSource.sharedInstance.words(forLanguageCode: "en")
        XCTAssertEqual(words2.count, 1)

        let words3 = WordsDataSource.sharedInstance.groups(forLanguageCode: "de").first!.words!
        XCTAssertEqual(words3.count, 2)
    }


    func testFetchWordsCount()
    {
        let group = WordsDataSource.sharedInstance.newGroup(forLanguageCode: "fr")

        _ = WordsDataSource.sharedInstance.newWord(forGroup: group)
        _ = WordsDataSource.sharedInstance.newWord(forGroup: group)
        _ = WordsDataSource.sharedInstance.newWord(forGroup: group)
        WordsDataSource.sharedInstance.saveContext()

        let wordsCount = WordsDataSource.sharedInstance.wordsCount(forLanguageCode: "fr")
        XCTAssertEqual(wordsCount, 3)
    }


    // MARK: - Language Codes
    func testFetchLangageCodes()
    {
        _ = WordsDataSource.sharedInstance.newGroup(forLanguageCode: "en")
        _ = WordsDataSource.sharedInstance.newGroup(forLanguageCode: "fr")
        _ = WordsDataSource.sharedInstance.newGroup(forLanguageCode: "de")
        _ = WordsDataSource.sharedInstance.newGroup(forLanguageCode: "de")
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


    func testLanguageCodesCount()
    {
        _ = WordsDataSource.sharedInstance.newGroup(forLanguageCode: "en")
        _ = WordsDataSource.sharedInstance.newGroup(forLanguageCode: "fr")
        _ = WordsDataSource.sharedInstance.newGroup(forLanguageCode: "de")
        _ = WordsDataSource.sharedInstance.newGroup(forLanguageCode: "de")
        WordsDataSource.sharedInstance.saveContext()

        let count = WordsDataSource.sharedInstance.languageCodesCount()
        XCTAssertEqual(count, 3)
    }


    func testLoadBundledWords()
    {
        WordsDataSource.sharedInstance.loadWords(fromBundledFile: "Test.plist")
        WordsDataSource.sharedInstance.saveContext()

        let languageCodes = WordsDataSource.sharedInstance.languageCodes()
        XCTAssertEqual(languageCodes.count, 1)

        let groups = WordsDataSource.sharedInstance.groups(forLanguageCode: "en")
        XCTAssertEqual(groups.count, 2)

        let wordsCount = WordsDataSource.sharedInstance.wordsCount(forLanguageCode: "en")
        XCTAssertEqual(wordsCount, 4)
    }


    func testFetchRequestWordsInGroup()
    {
        let groupDe = WordsDataSource.sharedInstance.newGroup(forLanguageCode: "de")
        groupDe.name = "group1"

        let groupEn1 = WordsDataSource.sharedInstance.newGroup(forLanguageCode: "en")
        groupEn1.name = "group1"

        let groupEn2 = WordsDataSource.sharedInstance.newGroup(forLanguageCode: "en")
        groupEn2.name = "group2"

        _ = WordsDataSource.sharedInstance.newWord(forGroup: groupDe)
        _ = WordsDataSource.sharedInstance.newWord(forGroup: groupDe)
        _ = WordsDataSource.sharedInstance.newWord(forGroup: groupEn1)

        let word1 = WordsDataSource.sharedInstance.newWord(forGroup: groupEn2)
        word1.word = "Word 1"
        let word2 = WordsDataSource.sharedInstance.newWord(forGroup: groupEn2)
        word2.word = "Word 2"
        let word3 = WordsDataSource.sharedInstance.newWord(forGroup: groupEn2)
        word3.word = "Word 3"

        let fetchRequest = WordsDataSource.sharedInstance.fetchRequestWords(forGroup: groupEn2)
        let words = try? WordsDataSource.sharedInstance.context.fetch(fetchRequest)

        XCTAssertNotNil(words)

        XCTAssertEqual(words!.count, 3)
        XCTAssertTrue(words![0].order < words![1].order && words![1].order < words![2].order)
    }


    func testFetchRequestWords()
    {
        let groupDe = WordsDataSource.sharedInstance.newGroup(forLanguageCode: "de")
        groupDe.name = "group1"

        let groupEn1 = WordsDataSource.sharedInstance.newGroup(forLanguageCode: "en")
        groupEn1.name = "group1"

        let groupEn2 = WordsDataSource.sharedInstance.newGroup(forLanguageCode: "en")
        groupEn2.name = "group2"

        _ = WordsDataSource.sharedInstance.newWord(forGroup: groupDe)
        _ = WordsDataSource.sharedInstance.newWord(forGroup: groupDe)
        _ = WordsDataSource.sharedInstance.newWord(forGroup: groupEn1)

        let word1 = WordsDataSource.sharedInstance.newWord(forGroup: groupEn2)
        word1.word = "Word 1"
        let word2 = WordsDataSource.sharedInstance.newWord(forGroup: groupEn2)
        word2.word = "Word 2"
        let word3 = WordsDataSource.sharedInstance.newWord(forGroup: groupEn2)
        word3.word = "Word 3"

        let fetchRequest = WordsDataSource.sharedInstance.fetchRequestWords(forLanguageCode: "en")
        let words = try? WordsDataSource.sharedInstance.context.fetch(fetchRequest)

        XCTAssertNotNil(words)

        XCTAssertEqual(words!.count, 4)
        XCTAssertTrue(words![0].group!.name! < words![1].group!.name!)
        XCTAssertTrue(words![1].order < words![2].order && words![2].order < words![3].order)
    }
}
