//
//  LanguageTests.swift
//  Words
//
//  Created by Rafal Grodzinski on 25/02/2017.
//  Copyright © 2017 UnalignedByte. All rights reserved.
//

import XCTest
@testable import Words


class LanguageTests: XCTestCase
{
    func testLanguageRawValues()
    {
        let langEn1 = Language.en
        XCTAssertEqual(langEn1.rawValue, "en")

        let langCn1 = Language.cn
        XCTAssertEqual(langCn1.rawValue, "cn")

        let langEn2 = Language(rawValue: "en")
        XCTAssertEqual(langEn2, .en)

        let langCn2 = Language(rawValue: "cn")
        XCTAssertEqual(langCn2, .cn)
    }


    func testLangaugeCodes()
    {
        let langEn = Language.en
        XCTAssertEqual(langEn.code, "en")

        let langCn = Language.cn
        XCTAssertEqual(langCn.code, "cn")
    }


    func testLanguageEditWordViewController()
    {
        let langEnController = Language.en.editWordViewController
        XCTAssertTrue(type(of: langEnController) == EditEnglishWordViewController.self)
    }

    func testLanguageWordConfigCellTitles()
    {
        XCTAssertEqual(Language.en.wordConfigCellTitles.count, 3)
        XCTAssertEqual(Language.cn.wordConfigCellTitles.count, 4)
    }
}
