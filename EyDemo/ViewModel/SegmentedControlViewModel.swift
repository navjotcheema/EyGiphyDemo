//
//  SegmentedControlViewModel.swift
//  EyDemo
//
//  Created by Navjot Cheema on 2023-02-17.
//

import UIKit

class SegmentedControlViewModel: ObservableObject {
    var selectedSegmentIndex = 0
    
    let segmentTitles: [String]
    
    init(segmentTitles: [String]) {
        self.segmentTitles = segmentTitles
    }
    
    func selectSegment(at index: Int) {
        selectedSegmentIndex = index
    }
}
