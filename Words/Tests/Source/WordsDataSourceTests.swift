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
        WordsDataSource.sharedInstance.deleteGroups(forLanguage: Language.cn)
        WordsDataSource.sharedInstance.deleteGroups(forLanguage: Language.gn)
    }


    func testGetContext()
    {
        let context = WordsDataSource.sharedInstance.context
        XCTAssertNotNil(context)
    }


    // MARK: - Groups
    func testNewGroup()
    {
        let group = WordsDataSource.sharedInstance.newGroup(forLanguage: Language.gn)
        group.name = "Test Group"
        //WordsDataSource.sharedInstance.saveContext()

        XCTAssertEqual(group.name, "Test Group")
        XCTAssertEqual(group.languageCode, "gn")
        XCTAssertEqual(group.words.count, 0)
    }


    func testDeleteGroup()
    {
        let groupA = WordsDataSource.sharedInstance.newGroup(forLanguage: Language.gn)
        _ = WordsDataSource.sharedInstance.newGroup(forLanguage: Language.gn)
        WordsDataSource.sharedInstance.delete(group: groupA)
        //WordsDataSource.sharedInstance.saveContext()

        let count = WordsDataSource.sharedInstance.groupsCount(forLanguage: Language.gn)
        XCTAssertEqual(count, 1)
    }


    func testFetchGroups()
    {
        let group1 = WordsDataSource.sharedInstance.newGroup(forLanguage: Language.gn)
        group1.name = "group1"
        let group2 = WordsDataSource.sharedInstance.newGroup(forLanguage: Language.gn)
        group2.name = "group2"
        //WordsDataSource.sharedInstance.saveContext()

        let groups = WordsDataSource.sharedInstance.groups(forLanguage: Language.gn)
        XCTAssertEqual(groups.count, 2)

        var containsGroup1 = false
        var containsGroup2 = false

        for group in groups {
            switch group.name {
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
        _ = WordsDataSource.sharedInstance.newGroup(forLanguage: Language.cn)
        _ = WordsDataSource.sharedInstance.newGroup(forLanguage: Language.cn)
        _ = WordsDataSource.sharedInstance.newGroup(forLanguage: Language.gn)
        //WordsDataSource.sharedInstance.saveContext()

        let countDe = WordsDataSource.sharedInstance.groupsCount(forLanguage: Language.cn)
        XCTAssertEqual(countDe, 2)

        let countEn = WordsDataSource.sharedInstance.groupsCount(forLanguage: Language.gn)
        XCTAssertEqual(countEn, 1)
    }


    // MARK: - Words
    func testNewWord()
    {
        let group = WordsDataSource.sharedInstance.newGroup(forLanguage: Language.gn)
        let word = WordsDataSource.sharedInstance.newWord(forGroup: group)
        word.word = "Test English"
        word.translation = "Test Translation"
        //WordsDataSource.sharedInstance.saveContext()

        XCTAssertEqual(word.word, "Test English")
        XCTAssertEqual(word.translation, "Test Translation")
    }


    func testFetchWords()
    {
        let groupDe1 = WordsDataSource.sharedInstance.newGroup(forLanguage: Language.cn)
        groupDe1.name = "group1"

        let groupDe2 = WordsDataSource.sharedInstance.newGroup(forLanguage: Language.cn)
        groupDe2.name = "group2"

        let groupEn = WordsDataSource.sharedInstance.newGroup(forLanguage: Language.gn)
        groupEn.name = "group1"

        _ = WordsDataSource.sharedInstance.newWord(forGroup: groupDe1)
        _ = WordsDataSource.sharedInstance.newWord(forGroup: groupDe1)
        _ = WordsDataSource.sharedInstance.newWord(forGroup: groupDe2)
        _ = WordsDataSource.sharedInstance.newWord(forGroup: groupDe2)
        _ = WordsDataSource.sharedInstance.newWord(forGroup: groupEn)
        //WordsDataSource.sharedInstance.saveContext()

        let words1 = WordsDataSource.sharedInstance.words(forLanguage: Language.cn)
        XCTAssertEqual(words1.count, 4)

        let words2 = WordsDataSource.sharedInstance.words(forLanguage: Language.gn)
        XCTAssertEqual(words2.count, 1)

        let words3 = WordsDataSource.sharedInstance.groups(forLanguage: Language.cn).first!.words
        XCTAssertEqual(words3.count, 2)
    }


    func testFetchWordsCount()
    {
        let group = WordsDataSource.sharedInstance.newGroup(forLanguage: Language.cn)

        _ = WordsDataSource.sharedInstance.newWord(forGroup: group)
        _ = WordsDataSource.sharedInstance.newWord(forGroup: group)
        _ = WordsDataSource.sharedInstance.newWord(forGroup: group)
        //WordsDataSource.sharedInstance.saveContext()

        let wordsCount = WordsDataSource.sharedInstance.wordsCount(forLanguage: Language.cn)
        XCTAssertEqual(wordsCount, 3)
    }


    // MARK: - Language Codes
    func testFetchLangageCodes()
    {
        let langGn = Language(rawValue: "gn")
        let langCn = Language(rawValue: "cn")

        guard langGn != nil else {
            XCTFail()
            return
        }

        guard langCn != nil else {
            XCTFail()
            return
        }

        XCTAssertEqual(langGn!.code, "gn")
        XCTAssertEqual(langCn!.code, "cn")
    }


    func testLanguageCodesCount()
    {
        XCTAssertEqual(Language.allCases.count, 3)
    }


    func testLoadBundledWords()
    {
        WordsDataSource.sharedInstance.loadWords(fromBundledFile: "Test.plist")
        //WordsDataSource.sharedInstance.saveContext()

        let groups = WordsDataSource.sharedInstance.groups(forLanguage: Language.gn)
        XCTAssertEqual(groups.count, 2)

        let wordsCount = WordsDataSource.sharedInstance.wordsCount(forLanguage: Language.gn)
        XCTAssertEqual(wordsCount, 4)
    }


    func testFetchRequestWordsInGroup()
    {
        let groupCn = WordsDataSource.sharedInstance.newGroup(forLanguage: Language.cn)
        groupCn.name = "group1"

        let groupGn1 = WordsDataSource.sharedInstance.newGroup(forLanguage: Language.gn)
        groupGn1.name = "group1"

        let groupGn2 = WordsDataSource.sharedInstance.newGroup(forLanguage: Language.gn)
        groupGn2.name = "group2"

        _ = WordsDataSource.sharedInstance.newWord(forGroup: groupCn)
        _ = WordsDataSource.sharedInstance.newWord(forGroup: groupCn)
        _ = WordsDataSource.sharedInstance.newWord(forGroup: groupGn1)

        let word1 = WordsDataSource.sharedInstance.newWord(forGroup: groupGn2)
        word1.word = "Word 1"
        try! WordsDataSource.sharedInstance.context.save()

        let word2 = WordsDataSource.sharedInstance.newWord(forGroup: groupGn2)
        word2.word = "Word 2"
        try! WordsDataSource.sharedInstance.context.save()

        let word3 = WordsDataSource.sharedInstance.newWord(forGroup: groupGn2)
        word3.word = "Word 3"
        try! WordsDataSource.sharedInstance.context.save()

        let fetchRequest = WordsDataSource.sharedInstance.fetchRequestWords(forGroup: groupGn2)
        let words = try? WordsDataSource.sharedInstance.context.fetch(fetchRequest)

        XCTAssertNotNil(words)

        XCTAssertEqual(words!.count, 3)
        XCTAssertTrue(words![0].order < words![1].order && words![1].order < words![2].order)
    }


    func testFetchRequestWords()
    {
        let groupCn = WordsDataSource.sharedInstance.newGroup(forLanguage: Language.cn)
        groupCn.name = "group1"

        let groupGn1 = WordsDataSource.sharedInstance.newGroup(forLanguage: Language.gn)
        groupGn1.name = "group1"

        let groupGn2 = WordsDataSource.sharedInstance.newGroup(forLanguage: Language.gn)
        groupGn2.name = "group2"

        _ = WordsDataSource.sharedInstance.newWord(forGroup: groupCn)
        _ = WordsDataSource.sharedInstance.newWord(forGroup: groupCn)
        _ = WordsDataSource.sharedInstance.newWord(forGroup: groupGn1)

        let word1 = WordsDataSource.sharedInstance.newWord(forGroup: groupGn2)
        word1.word = "Word 1"
        try! WordsDataSource.sharedInstance.context.save()

        let word2 = WordsDataSource.sharedInstance.newWord(forGroup: groupGn2)
        word2.word = "Word 2"
        try! WordsDataSource.sharedInstance.context.save()

        let word3 = WordsDataSource.sharedInstance.newWord(forGroup: groupGn2)
        word3.word = "Word 3"
        try! WordsDataSource.sharedInstance.context.save()

        let fetchRequest = WordsDataSource.sharedInstance.fetchRequestWords(forLanguage: Language.gn)
        let words = try? WordsDataSource.sharedInstance.context.fetch(fetchRequest)

        XCTAssertNotNil(words)

        XCTAssertEqual(words!.count, 4)
        XCTAssertTrue(words![0].group.name <= words![1].group.name && words![1].group.name <= words![2].group.name &&
                      words![2].group.name <= words![3].group.name)
        XCTAssertTrue(words![1].order <= words![2].order && words![2].order <= words![3].order)
    }
}
