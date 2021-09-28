//
//  CompositionalLayoutViewController.swift
//  CompositionalLayoutViewController
//
//  Created by Akira Matsuda on 2021/01/23.
//

import UIKit

open class CompositionalLayoutViewController: UICollectionViewController {

    public var highlightedColor: UIColor?
    public var dataSource: UICollectionViewDiffableDataSource<AnyHashable, AnyHashable>!
    public weak var provider: SectionProvider?

    public init() {
        super.init(collectionViewLayout: UICollectionViewLayout())
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.collectionViewLayout = layout(configuration: layoutConfiguration())
        collectionView.delaysContentTouches = false

        dataSource = UICollectionViewDiffableDataSource<AnyHashable, AnyHashable>(
            collectionView: collectionView
        ) { [unowned self] _, indexPath, _ -> UICollectionViewCell? in
            return cell(for: indexPath)
        }
        dataSource.supplementaryViewProvider = { [unowned self] _, kind, indexPath in
            return supplementaryView(for: kind, indexPath: indexPath)
        }
    }

    open func cell(for indexPath: IndexPath) -> UICollectionViewCell? {
        guard let provider = provider else {
            return nil
        }
        let section = provider.section(for: indexPath.section)
        guard let cell = section.cell(collectionView, indexPath: indexPath) else {
            return nil
        }
        configureCell(cell)
        return cell
    }

    open func supplementaryView(for kind: String, indexPath: IndexPath) -> UICollectionReusableView? {
        guard let provider = provider else {
            return nil
        }
        let section = provider.section(for: indexPath.section)
        let view = section.supplementaryView(
            collectionView,
            kind: kind,
            indexPath: indexPath
        )
        if let view = view {
            section.configureSupplementaryView(view, indexPath: indexPath)
            configureSupplementaryView(view, indexPath: indexPath)
        }
        return view
    }

    open func layout(configuration: UICollectionViewCompositionalLayoutConfiguration) -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout(sectionProvider: { [unowned self] sectionIndex, environment -> NSCollectionLayoutSection? in
            guard let provider = provider else {
                return nil
            }
            let section = provider.section(for: sectionIndex)
            let layout = section.layoutSection(collectionView, environment: environment)
            configureSection(section, layout: layout)
            return layout
        }, configuration: configuration)
    }

    open func layoutConfiguration() -> UICollectionViewCompositionalLayoutConfiguration {
        return UICollectionViewCompositionalLayoutConfiguration()
    }

    open func configureCell(_ cell: UICollectionViewCell) {}

    open func configureSection(_ section: CollectionViewSection, layout: NSCollectionLayoutSection) {}

    open func configureSupplementaryView(_ view: UICollectionReusableView, indexPath: IndexPath) {}

    open func registerViews(_ sections: [CollectionViewSection]) {
        for section in sections {
            section.registerCell(collectionView: collectionView)
            section.registerSupplementaryView(collectionView: collectionView)
        }
    }

    open func updateDataSource(_ sections: [CollectionViewSection], animateWhenUpdate: Bool = true) {
        registerViews(sections)
        var snapshot = NSDiffableDataSourceSnapshot<AnyHashable, AnyHashable>()
        for section in sections {
            snapshot.appendSections([section.snapshotSection])
            snapshot.appendItems(section.snapshotItems, toSection: section.snapshotSection)
        }
        dataSource.apply(snapshot, animatingDifferences: animateWhenUpdate)
    }

    open func reloadSections(animateWhenUpdate: Bool = true) {
        guard let provider = provider else {
            return
        }
        updateDataSource(provider.sections, animateWhenUpdate: animateWhenUpdate)
    }

    open func didSelectItem(at indexPath: IndexPath) {
        section(at: indexPath)?.didSelectItem(at: indexPath)
    }
    
    func section(at indexPath: IndexPath) -> CollectionViewSection? {
        guard let provider = provider else { return nil }
        return provider.section(for: indexPath.section)
    }

    // MARK: - UICollectionViewDelegate
    
    public override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didSelectItem(at: indexPath)
    }

    public override func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? HighlightableCell, cell.clvc_isHighlightable {
            cell.contentView.backgroundColor = cell.clvc_highlightedColor
        }
    }

    public override func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? HighlightableCell, cell.clvc_isHighlightable {
            cell.contentView.backgroundColor = nil
        }
    }
    
}
