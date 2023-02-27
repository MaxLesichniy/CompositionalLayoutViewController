//
//  UIContextMenuConfiguration+Extensions.swift
//  CompositionalLayoutViewController
//
//  Created by Max Lesichniy on 25.02.2023.
//

#if os(iOS)
import UIKit

private var sectionKey: Int = 0

extension UIContextMenuConfiguration {
    
    var section: CollectionViewSection? {
        set { objc_setAssociatedObject(self, &sectionKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
        get { objc_getAssociatedObject(self, &sectionKey) as? CollectionViewSection }
    }
    
}
#endif
