//
//  CategoryListViewController.swift
//  VtronixApp
//
//  Created by samstag on 5.05.2020.
//  Copyright © 2020 Vtronix. All rights reserved.
//

import UIKit


// MARK: - CategoryListViewController

class CategoryListViewController: UIViewController {
    
    @IBOutlet var collectionView: UICollectionView!
    
    var category: Category?
    // Helper computed property for listing sub-cateries
    var categories: [Category] {
        return self.category?.categories ?? [] /* empty array */
    }
    
    private let categoryCellId = "CategoryListCollectionViewCellId"
    private let footerViewId = "CategoryListFooterViewId"
    private let collectionViewVerEdges: CGFloat = 24.0
    private let collectionViewHorEdges: CGFloat = 8.0
    
    private var screenWidth: CGFloat {
        let deviceWidth = UIScreen.main.bounds.width
        if UIDevice.current.userInterfaceIdiom == .pad {
            return deviceWidth * (2/3)
        } else {
            return deviceWidth
        }
    }
    
    private lazy var cellWidth = (self.collectionView.bounds.size.width - (2 * self.collectionViewHorEdges)) / 2
    private lazy var cellHeight: CGFloat = {
        let cellHeights: [CGFloat] = self.categories.map {
            let content = $0.getContentForCell()
            return CategoryListCollectionViewCell.height(forWidth: self.cellWidth, title: content.title, subtitle: content.subtitle)
        }
        return cellHeights.max() ?? .zero
    }()
    
    
    init(category: Category?) {
        
        self.category = category
        
        super.init(nibName: nil, bundle: nil)
        
        self.sharedInit()
    }
    

    required init?(coder: NSCoder) {

        fatalError("This class does not support `init?(coder:)`. Use `init(category:)` instead.")
    }
    
    
    private func sharedInit() {
        
        self.title = self.category?.name
        self.tabBarItem.image = #imageLiteral(resourceName: "tab-products")
    }
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        // Register custom cells
        
        self.collectionView.register(UINib.init(nibName: "CategoryListCollectionViewCell", bundle: nil),
                                     forCellWithReuseIdentifier: self.categoryCellId)
        self.collectionView.register(UINib.init(nibName: "CategoryListFooterView", bundle: nil),
                                     forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                                     withReuseIdentifier: self.footerViewId)
        
        // ---

        self.addCollectionViewHeaderView()
    }
    
    
    private func addCollectionViewHeaderView() {
        
        guard
            let category = self.category,
            category.isRoot,
            let description = category.description,
            let logo = UIImage(named: "Classic-America"),
            let arrNib = Bundle.main.loadNibNamed("CategoryListHeaderView", owner: self, options: nil),
            let headerView = arrNib.first as? CategoryListHeaderView
        else {
            return
        }
        
        let title = RichString(text: description, fontSize: 18.0, textColor: UIColor.vtronixDarkBlue)
        let width = self.screenWidth
        let height = CategoryListHeaderView.estimatedHeight(forMaxWidth: width,
                                                            richString: title,
                                                            isImageViewHidden: false)
        
        headerView.setContent(richString: title, image: logo)

        let containerView = UIView.init(frame: CGRect(x: .zero, y: -height, width: width, height: height))
        headerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(headerView)
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: containerView.topAnchor),
            headerView.rightAnchor.constraint(equalTo: containerView.rightAnchor),
            headerView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            headerView.leftAnchor.constraint(equalTo: containerView.leftAnchor),
        ])
        
        var contentInsets = self.collectionView.contentInset
        contentInsets.top = height
        self.collectionView.contentInset = contentInsets
        self.collectionView.addSubview(containerView)
    }
    
}


// MARK: UICollectionViewDataSource

extension CategoryListViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return self.categories.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell =
            collectionView.dequeueReusableCell(withReuseIdentifier: self.categoryCellId,
                                               for: indexPath) as? CategoryListCollectionViewCell
        else {
            return UICollectionViewCell.init()
        }
        
        let category = self.categories[indexPath.row]
        let content = category.getContentForCell()
        cell.setContent(imageURLOrName: content.imageURLOrName, title: content.title, subtitle: content.subtitle)
        
        return cell
    }
    

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForFooterInSection section: Int)
        -> CGSize
    {
        guard
            let category = self.category,
            !category.isRoot,
            let description = category.description
        else { return .zero }
        
        let content = RichString(text: description, fontSize: 17.0, textColor: UIColor.vtronixDarkBlue)
        let calculatedHeight = CategoryListFooterView.estimatedHeight(forMaxWidth: self.screenWidth,
                                                                      richString: content)
        return CGSize(width: self.screenWidth, height: calculatedHeight)
    }
    

    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView
    {
        guard
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter,
                                                                             withReuseIdentifier: self.footerViewId,
                                                                             for: indexPath) as? CategoryListFooterView
        else {
            return UICollectionReusableView()
        }
        
        let content = RichString(text: self.category?.description ?? "", fontSize: 17.0, textColor: UIColor.vtronixDarkBlue)
        footerView.setContent(richString: content)
        
        return footerView
    }
    
}


// MARK: UICollectionViewDelegate

extension CategoryListViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath)
        -> CGSize
    {
        return CGSize(width: self.cellWidth, height: self.cellHeight)
    }
    
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int)
        -> UIEdgeInsets
    {
        return UIEdgeInsets(top: self.collectionViewVerEdges,
                            left: self.collectionViewHorEdges,
                            bottom: self.collectionViewVerEdges,
                            right: self.collectionViewHorEdges)
    }
    
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int)
        -> CGFloat
    {
        return .zero
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let category = self.categories[indexPath.row]
        if (category.categories ?? []).count > 0
        {
            let vc = CategoryListViewController.init(category: category)
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else
        { // ProductListViewController
            let vc = ProductsViewController.init(category: category)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        
        (collectionView.cellForItem(at: indexPath) as? CategoryListCollectionViewCell)?.setHighlightedState(true)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        
        (collectionView.cellForItem(at: indexPath) as? CategoryListCollectionViewCell)?.setHighlightedState(false)
    }
    
}


// MARK: Category extension for getContentForCell() method

fileprivate extension Category {
    
    func getContentForCell() -> (imageURLOrName: String, title: String, subtitle: String) {
        
        let imageURLOrName = self.image ?? ""
        let title = self.name ?? ""
        let subtitle = self.subtitleForCategoryCell() ?? ""
        return (imageURLOrName: imageURLOrName, title: title, subtitle: subtitle)
    }
    
}
