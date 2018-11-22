//
//  SearchViewController.swift
//  FiMap
//
//  Created by AmamiYou on 2018/10/21.
//  Copyright © 2018 ammYou. All rights reserved.
//

import UIKit


class SearchViewController: UIViewController {
    // MARK: - Private Properties
    public var collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: RSKCollectionViewRetractableFirstItemLayout())

    fileprivate var dataSource = [
        CategoryDataItem(name: "Wi-Fi", color: Constants.Color.LIGHT_GARY),
        CategoryDataItem(name: "トイレ", color: Constants.Color.LIGHT_GARY),
        CategoryDataItem(name: "公園", color: Constants.Color.LIGHT_GARY),
        CategoryDataItem(name: "ホテル", color: Constants.Color.LIGHT_GARY),
        CategoryDataItem(name: "銀行", color: Constants.Color.LIGHT_GARY),
        CategoryDataItem(name: "バス停", color: Constants.Color.LIGHT_GARY),
    ]

    fileprivate var readyForPresentation = false

    fileprivate var cellSizeWidth = 100
    fileprivate var cellSileHeight = 100

    // MARK: - Object Lifecycle

    override func viewDidLoad() {

        super.viewDidLoad()
//        self.filteredNames = self.names
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
//        self.collectionView.isPrefetchingEnabled = true
        self.collectionView.backgroundColor = Constants.Color.LIGHT_GARY

        self.view.addSubview(self.collectionView)
        self.collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }

        self.collectionView.register(TextHeadCollectionViewCell.self, forCellWithReuseIdentifier: TextHeadCollectionViewCell.className)
        self.collectionView.register(ResultCollectionViewCell.self, forCellWithReuseIdentifier: ResultCollectionViewCell.className)

        if let collectionViewLayout = self.collectionView.collectionViewLayout as? RSKCollectionViewRetractableFirstItemLayout {

            collectionViewLayout.firstItemRetractableAreaInset = UIEdgeInsets(top: 10.0, left: 0.0, bottom: 10.0, right: 0.0)
        }
    }

    // MARK: - Layout
    override func viewDidLayoutSubviews() {

        super.viewDidLayoutSubviews()

//        guard self.readyForPresentation == false else {
//
//            return
//        }
//
//        self.readyForPresentation = true
//
//        let searchItemIndexPath = IndexPath(item: 0, section: 0)
//        self.collectionView.contentOffset = CGPoint(x: 0.0, y: self.collectionView(self.collectionView, layout: self.collectionView.collectionViewLayout, sizeForItemAt: searchItemIndexPath).height)
    }
}


// MARK: - Extension
extension SearchViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {

        guard scrollView === self.collectionView else {

            return
        }

        let indexPath = IndexPath(item: 0, section: 0)
        guard let cell = self.collectionView.cellForItem(at: indexPath) as? TextHeadCollectionViewCell else {
            return
        }
    }
}

extension SearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    }

}

extension SearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        switch indexPath.section {

        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TextHeadCollectionViewCell.className, for: indexPath) as! TextHeadCollectionViewCell
            cell.setCell(text: R.string.localized.home_reccomend())
            return cell

        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ResultCollectionViewCell.className, for: indexPath) as! ResultCollectionViewCell

            cell.colorView.backgroundColor = Constants.Color.FIMAP_THEME//self.colors[name]
            cell.label.text = self.dataSource[indexPath.item].name

            cell.colorView.layer.cornerRadius = 10.0
//            cell.addShadow(direction: .bottom)
            return cell

        default:
            assert(false)
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        switch section {

        case 0:
            return 1

        case 1:
            return self.dataSource.count

        default:
            assert(false)
        }
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {

        return 2
    }
}

extension SearchViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {

        switch section {

        case 0:
            return UIEdgeInsets.zero

        case 1:
            return UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)

        default:
            assert(false)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {

        return 10.0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {

        return 10.0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        switch indexPath.section {

        case 0:
            let itemWidth = collectionView.frame.width
            let itemHeight: CGFloat = 44.0

            return CGSize(width: itemWidth, height: itemHeight)

        case 1:
            let numberOfItemsInLine: CGFloat = 2

            let inset = self.collectionView(collectionView, layout: collectionViewLayout, insetForSectionAt: indexPath.section)
            let minimumInteritemSpacing = self.collectionView(collectionView, layout: collectionViewLayout, minimumInteritemSpacingForSectionAt: indexPath.section)

            let itemWidth = (collectionView.frame.width - inset.left - inset.right - minimumInteritemSpacing * (numberOfItemsInLine - 1)) / numberOfItemsInLine
            let itemHeight = itemWidth * 0.7

            return CGSize(width: itemWidth, height: itemHeight)

        default:
            assert(false)
        }
    }
}

extension SearchViewController: UISearchBarDelegate {
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//
//        let oldFilteredNames = self.filteredNames!
//
//        if searchText.isEmpty {
//
//            self.filteredNames = self.names
//        }
//        else {
//
//            self.filteredNames = self.names.filter({ (name) -> Bool in
//
//                return name.hasPrefix(searchText)
//            })
//        }
//
//        self.collectionView.performBatchUpdates({
//
//            for (oldIndex, oldName) in oldFilteredNames.enumerated() {
//
//                if self.filteredNames.contains(oldName) == false {
//
//                    let indexPath = IndexPath(item: oldIndex, section: 1)
//                    self.collectionView.deleteItems(at: [indexPath])
//                }
//            }
//
//            for (index, name) in self.filteredNames.enumerated() {
//
//                if oldFilteredNames.contains(name) == false {
//
//                    let indexPath = IndexPath(item: index, section: 1)
//                    self.collectionView.insertItems(at: [indexPath])
//                }
//            }
//
//        }, completion: nil)
//    }
}
