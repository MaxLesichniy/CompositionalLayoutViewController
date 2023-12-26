//
//  CompositionalLayoutViewController.swift
//  CompositionalLayoutViewController
//
//  Created by Akira Matsuda on 2021/01/23.
//

import UIKit

open class CompositionalLayoutViewController: UICollectionViewController {

    public var highlightedColor: UIColor?
    public var collectionViewDataSource: UICollectionViewDiffableDataSource<AnyHashable, AnyHashable>!
    public weak var provider: SectionProvider?

    // MARK: - Init
    
    public init() {
        super.init(collectionViewLayout: UICollectionViewLayout())
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Life Cycle
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.collectionViewLayout = layout(configuration: layoutConfiguration())
        collectionView.delaysContentTouches = false

        collectionViewDataSource = UICollectionViewDiffableDataSource(collectionView: collectionView) { [unowned self] _, indexPath, _ in
            return cell(for: indexPath)
        }
        collectionViewDataSource.supplementaryViewProvider = { [unowned self] _, kind, indexPath in
            return supplementaryView(for: kind, indexPath: indexPath)
        }
    }

    open func cell(for indexPath: IndexPath) -> UICollectionViewCell? {
        guard let provider = provider else { return nil }
        let section = provider.section(for: indexPath.section)
        guard let cell = section.cell(collectionView, indexPath: indexPath) else { return nil }
        configureCell(cell)
        return cell
    }

    open func supplementaryView(for kind: String, indexPath: IndexPath) -> UICollectionReusableView? {
        guard let provider = provider else { return nil }
        let section = provider.section(for: indexPath.section)
        let view = section.supplementaryView(collectionView, kind: kind, indexPath: indexPath)
        if let view = view {
            section.configureSupplementaryView(view, indexPath: indexPath)
            configureSupplementaryView(view, indexPath: indexPath)
        }
        return view
    }

    open func layout(configuration: UICollectionViewCompositionalLayoutConfiguration) -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout(sectionProvider: { [weak self] (sectionIndex, environment) in
            guard let `self` = self, let provider = self.provider else { return nil }
            let section = provider.section(for: sectionIndex)
            let layout = section.layoutSection(self.collectionView, environment: environment)
            self.configureSection(section, layout: layout)
            return layout
        }, configuration: configuration)
    }

    open func layoutConfiguration() -> UICollectionViewCompositionalLayoutConfiguration {
        return UICollectionViewCompositionalLayoutConfiguration()
    }

    open func configureCell(_ cell: UICollectionViewCell) {
        
    }

    open func configureSection(_ section: CollectionViewSection, layout: NSCollectionLayoutSection) {
        
    }

    open func configureSupplementaryView(_ view: UICollectionReusableView, indexPath: IndexPath) {
        
    }

    open func registerSections(_ sections: [CollectionViewSection]) {
        for section in sections {
            section.register(in: collectionView)
        }
    }

    open func updateDataSource(_ sections: [CollectionViewSection], animateWhenUpdate: Bool = true, completion: (() -> Void)? = nil) {
        registerSections(sections)
        var snapshot = NSDiffableDataSourceSnapshot<AnyHashable, AnyHashable>()
        for section in sections {
            snapshot.appendSections([section.snapshotSection])
            snapshot.appendItems(section.snapshotItems, toSection: section.snapshotSection)
        }
        collectionViewDataSource.apply(snapshot, animatingDifferences: animateWhenUpdate, completion: completion)
    }
    
    open func updateSections(animateWhenUpdate: Bool = true, completion: (() -> Void)? = nil) {
        guard let provider else { return }
        updateDataSource(provider.sections, animateWhenUpdate: animateWhenUpdate, completion: completion)
    }

    open func reloadSections(animateWhenUpdate: Bool = true, completion: (() -> Void)? = nil) {
        updateSections(animateWhenUpdate: animateWhenUpdate, completion: completion)
    }

    open func didSelectItem(at indexPath: IndexPath) {
        section(at: indexPath)?.didSelectItem(at: indexPath, in: self)
    }
    
    // MARK: -
    
    func section(at indexPath: IndexPath) -> CollectionViewSection? {
        guard let provider = provider else { return nil }
        return provider.section(for: indexPath.section)
    }
    
    func makeContext() -> Context {
        Context(collectionView: collectionView, root: self)
    }

    // MARK: - UICollectionViewDelegate
    
    open override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    open override func collectionView(_ collectionView: UICollectionView, shouldDeselectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    open override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didSelectItem(at: indexPath)
    }
    
    open override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }

    open override func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? HighlightableCell, cell.clvc_isHighlightable {
            cell.contentView.backgroundColor = cell.clvc_highlightedColor
        }
    }

    open override func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? HighlightableCell, cell.clvc_isHighlightable {
            cell.contentView.backgroundColor = nil
        }
    }
    
    // Context Menu
    #if os(iOS)
    open override func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let section = section(at: indexPath)
        let configuration = section?.contextMenuConfiguration(makeContext(), forItemAt: indexPath, point: point)
        configuration?.section = section
        return configuration
    }
    
    open override func collectionView(_ collectionView: UICollectionView, previewForHighlightingContextMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        configuration.section?.previewForHighlightingContextMenu(makeContext(), withConfiguration: configuration)
    }
    
    open override func collectionView(_ collectionView: UICollectionView, previewForDismissingContextMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        configuration.section?.previewForDismissingContextMenu(makeContext(), withConfiguration: configuration)
    }
    
    open override func collectionView(_ collectionView: UICollectionView, willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionCommitAnimating) {
        configuration.section?.willPerformPreviewAction(makeContext(), forMenuWith: configuration, animator: animator)
    }
    
    @available(iOS 13.2, *)
    open override func collectionView(_ collectionView: UICollectionView, willDisplayContextMenu configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionAnimating?) {
        configuration.section?.willDisplayContextMenu(makeContext(), configuration: configuration, animator: animator)
    }
    
    @available(iOS 13.2, *)
    open override func collectionView(_ collectionView: UICollectionView, willEndContextMenuInteraction configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionAnimating?) {
        configuration.section?.willEndContextMenuInteraction(makeContext(), configuration: configuration, animator: animator)
    }
    #endif
    
}
