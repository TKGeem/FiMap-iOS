//
//  SearchCollectionViewCell.swift
//  FiMap
//
//  Created by AmamiYou on 2018/10/24.
//  Copyright © 2018 ammYou. All rights reserved.
//

import UIKit

internal final class SearchCollectionViewCell: UICollectionViewCell {

    // MARK: - Internal Properties

    internal var searchBar: UISearchBar!

    // MARK: - Object Lifecycle

    internal override init(frame: CGRect) {

        super.init(frame: frame)

        self.searchBar = UISearchBar()

        self.contentView.addSubview(self.searchBar)
    }

    internal required init?(coder aDecoder: NSCoder) {

        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Layout

    internal override func layoutSubviews() {

        super.layoutSubviews()

        self.searchBar.frame = CGRect(origin: CGPoint.zero, size: self.contentView.bounds.size)
    }

    internal override class var requiresConstraintBasedLayout: Bool {

        return false
    }
}
