//
//  SectionProvider.swift
//  CompositionalLayoutViewController
//
//  Created by Akira Matsuda on 2021/05/22.
//

import Foundation

@MainActor
public protocol SectionProvider: AnyObject {
    var sections: [CollectionViewSection] { get }

    func section(for sectionIndex: Int) -> CollectionViewSection
}

public extension SectionProvider {
    func section(for sectionIndex: Int) -> CollectionViewSection {
        return sections[sectionIndex]
    }
    
    func sectionIndex(for section: CollectionViewSection) -> Int? {
        return sections.firstIndex(where: { $0.snapshotSection == section.snapshotSection })
    }
}
