//
//  CollectionViewSection.swift
//  CompositionalLayoutViewController
//
//  Created by Akira Matsuda on 2021/01/03.
//

import UIKit

public protocol CollectionViewSection {
    var snapshotItems: [AnyHashable] { get }
    var snapshotSection: AnyHashable { get }
    
    func registerCell(collectionView: UICollectionView)
    func registerSupplementaryView(collectionView: UICollectionView)
    func layoutSection(_ collectionView: UICollectionView, environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection
    func cell(_ collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell?
    func didSelectItem(at indexPath: IndexPath)
    func supplementaryView(_ collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView?
    func configureSupplementaryView(_ view: UICollectionReusableView, indexPath: IndexPath)
    
//    func contextMenuConfiguration(_ collectionView: UICollectionView, forItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration?
//    func previewForHighlightingContextMenu(_ collectionView: UICollectionView, withConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview?
//    func previewForDismissingContextMenu(_ collectionView: UICollectionView, withConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview?
//    func willPerformPreviewAction(_ collectionView: UICollectionView, forMenuWith configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionCommitAnimating)
//    @available(iOS 13.2, *)
//    func willDisplayContextMenu(_ collectionView: UICollectionView, configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionAnimating?)
//    @available(iOS 13.2, *)
//    func willEndContextMenuInteraction(_ collectionView: UICollectionView, configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionAnimating?)
}

public extension CollectionViewSection {
    var snapshotSection: AnyHashable {
        var hasher = Hasher()
        snapshotItems.forEach {
            hasher.combine($0)
        }
        return hasher.finalize()
    }
    
//    func contextMenuConfiguration(_ collectionView: UICollectionView, forItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? { nil }
//    func previewForHighlightingContextMenu(_ collectionView: UICollectionView, withConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? { nil }
//    func previewForDismissingContextMenu(_ collectionView: UICollectionView, withConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? { nil }
//    func willPerformPreviewAction(_ collectionView: UICollectionView, forMenuWith configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionCommitAnimating) {}
//    @available(iOS 13.2, *)
//    func willDisplayContextMenu(_ collectionView: UICollectionView, configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionAnimating?) {}
//    @available(iOS 13.2, *)
//    func willEndContextMenuInteraction(_ collectionView: UICollectionView, configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionAnimating?) {}
}
