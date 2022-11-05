//
//  CollectionViewSection.swift
//  CompositionalLayoutViewController
//
//  Created by Akira Matsuda on 2021/01/03.
//

import UIKit

public struct Context {
    public let collectionView: UICollectionView
    public let root: CompositionalLayoutViewController
}

public protocol CollectionViewSection {
    var snapshotItems: [AnyHashable] { get }
    var snapshotSection: AnyHashable { get }
    
    func register(in collectionView: UICollectionView)
    func layoutSection(_ collectionView: UICollectionView, environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection
    func cell(_ collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell?
    func didSelectItem(at indexPath: IndexPath, in context: UIViewController)
    func supplementaryView(_ collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView?
    func configureSupplementaryView(_ view: UICollectionReusableView, indexPath: IndexPath)
    
    #if os(iOS)
    func contextMenuConfiguration(_ context: Context, forItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration?
    func previewForHighlightingContextMenu(_ context: Context, withConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview?
    func previewForDismissingContextMenu(_ context: Context, withConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview?
    func willPerformPreviewAction(_ context: Context, forMenuWith configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionCommitAnimating)
    @available(iOS 13.2, *)
    func willDisplayContextMenu(_ context: Context, configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionAnimating?)
    @available(iOS 13.2, *)
    func willEndContextMenuInteraction(_ context: Context, configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionAnimating?)
    #endif
}

public extension CollectionViewSection {
    var snapshotSection: AnyHashable {
        var hasher = Hasher()
        snapshotItems.forEach {
            hasher.combine($0)
        }
        return hasher.finalize()
    }
    
    #if os(iOS)
    func contextMenuConfiguration(_ context: Context, forItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? { nil }
    func previewForHighlightingContextMenu(_ context: Context, withConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? { nil }
    func previewForDismissingContextMenu(_ context: Context, withConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? { nil }
    func willPerformPreviewAction(_ context: Context, forMenuWith configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionCommitAnimating) {}
    @available(iOS 13.2, *)
    func willDisplayContextMenu(_ context: Context, configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionAnimating?) {}
    @available(iOS 13.2, *)
    func willEndContextMenuInteraction(_ context: Context, configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionAnimating?) {}
    #endif
}
