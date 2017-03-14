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
        let langEn1 = Language.gn
        XCTAssertEqual(langEn1.rawValue, "gn")

        let langCn1 = Language.cn
        XCTAssertEqual(langCn1.rawValue, "cn")

        let langEn2 = Language(rawValue: "gn")
        XCTAssertEqual(langEn2, .gn)

        let langCn2 = Language(rawValue: "cn")
        XCTAssertEqual(langCn2, .cn)
    }


    func testLangaugeCodes()
    {
        let langEn = Language.gn
        XCTAssertEqual(langEn.code, "gn")

        let langCn = Language.cn
        XCTAssertEqual(langCn.code, "cn")
    }


    func testLanguageEditWordViewController()
    {
        let langEnController = Language.gn.editWordControlsViewController
        XCTAssertTrue(type(of: langEnController) == EditGenericWordViewController.self)
    }

    func testLanguageWordConfigCellTitles()
    {
        XCTAssertEqual(Language.gn.wordConfigCellTitles.count, 3)
        XCTAssertEqual(Language.cn.wordConfigCellTitles.count, 4)
    }
}
