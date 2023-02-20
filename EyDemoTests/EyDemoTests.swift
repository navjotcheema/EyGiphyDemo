//
//  EyDemoTests.swift
//  EyDemoTests
//
//  Created by Navjot Cheema on 2023-02-15.
//

import XCTest
@testable import EyDemo

final class EyDemoTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSaveGifData() {
        let homeViewModel = HomeViewModel()
        
        // Given
        if let url = URL(string: "https://media3.giphy.com/media/FEyUPEirMqbElMS1Ln/200.gif?cid=7be1530edm3b8qwh7bsgmfajl020k5y8qd3wkglch556jwu0&rid=200.gif&ct=g") {
            let id = "FEyUPEirMqbElMS1Ln"
            homeViewModel.getImageData(imageUrl: url) { [self] image, data in
                if let gifData =  data {                    
                    // When
                    let expectation = XCTestExpectation(description: "Save GIF data")
                    homeViewModel.saveGifData(GifDataModel(data: gifData), gifName: id) { success in
                        // Then
                        XCTAssertTrue(success)
                        let fileManager = FileManager.default
                        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
                        let fileURL = documentsURL?.appendingPathComponent(id)
                        XCTAssertTrue(fileManager.fileExists(atPath: fileURL?.path ?? ""))
                        do {
                            let fileData = try Data(contentsOf: fileURL!)
                            XCTAssertEqual(fileData, gifData)
                            try fileManager.removeItem(at: fileURL!)
                            expectation.fulfill()
                        } catch {
                            XCTFail("Error: \(error.localizedDescription)")
                        }
                    }
                    wait(for: [expectation], timeout: 5.0)
                }
            }
        }
    }
    
    func testGetGifFilesFromFileManager() {
        let homeViewModel = HomeViewModel()

        // Create temporary files in document directory
        let fileManager = FileManager.default
        let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let file1URL = documentDirectory.appendingPathComponent("test1.gif")
        let file2URL = documentDirectory.appendingPathComponent("test2.gif")
        let testData1 = Data(repeating: 0, count: 10)
        let testData2 = Data(repeating: 1, count: 20)
        try! testData1.write(to: file1URL)
        try! testData2.write(to: file2URL)

        // Call the function and check the result
        let files = homeViewModel.getGifFilesFromFileManager()
        XCTAssertEqual(files.count, 2)
        XCTAssertEqual(files[0].id, "test1.gif")
        XCTAssertEqual(files[0].url, file1URL)
        XCTAssertEqual(files[1].id, "test2.gif")
        XCTAssertEqual(files[1].url, file2URL)

        // Clean up temporary files
        try! fileManager.removeItem(at: file1URL)
        try! fileManager.removeItem(at: file2URL)
    }
    
    func testRemoveDataFromFileManager() {
        // Create a temporary file in document directory
        let homeViewModel = HomeViewModel()

        let fileManager = FileManager.default
        let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentDirectory.appendingPathComponent("test.gif")
        let testData = Data(repeating: 0, count: 10)
        try! testData.write(to: fileURL)

        // Call the function and check the result
        XCTAssertTrue(fileManager.fileExists(atPath: fileURL.path))
        homeViewModel.removeDataFromFileManager(filePath: fileURL)
        XCTAssertFalse(fileManager.fileExists(atPath: fileURL.path))
    }
}
