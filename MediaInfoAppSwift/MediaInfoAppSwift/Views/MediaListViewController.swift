//
//  MediaListViewController.swift
//  TestMediaInfoApp
//
//  Created by sargis on 2/9/18.
//  Copyright © 2018 sargis All rights reserved.
//

import UIKit
import Kingfisher


class MediaListViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    fileprivate let CellIdentifiler = "MediaListViewcellId"
    fileprivate let CellIInset:CGFloat = 10.0
    
    lazy var viewModel: MediaListViewModel = {
        return MediaListViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Init view
        initView()
        
        // init view model
        initVM()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel.syncDataWithDB()
    }
    
    func initView() {
        self.navigationItem.title = "Media List"
    }
    
    func initVM() {
        
        viewModel.updateLoadingStatus = { [weak self] () in
            DispatchQueue.main.async {
                let isLoading = self?.viewModel.isLoading ?? false
                if isLoading {
                    self?.activityIndicator.startAnimating()
                    UIView.animate(withDuration: 0.2, animations: {
                        self?.collectionView.alpha = 0.0
                    })
                }else {
                    self?.activityIndicator.stopAnimating()
                    UIView.animate(withDuration: 0.2, animations: {
                        self?.collectionView.alpha = 1.0
                    })
                }
            }
        }
        
        viewModel.reloadCollectionViewClosure = { [weak self] () in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
        
        viewModel.initFetch()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension MediaListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfCells
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifiler, for: indexPath) as? MediaListCollectionViewCell else {
             fatalError("Cell doesn't exists in storyboard")
        }
        let cellVM = viewModel.getCellViewModel(at: indexPath)
        cell.titleLabel.text = cellVM.titleText
        cell.categoryLabel.text = cellVM.categoryText

        if cellVM.coverPhotoUrl != "" {
            cell.activityIndicator.startAnimating()
            cell.coverImageView?.kf.setImage(with: URL( string: cellVM.coverPhotoUrl!), placeholder: nil, options: nil, progressBlock: nil, completionHandler: { [weak cell](image, error, cachType, imageUrl) in
                if error != nil {
                    print(error!)
                }
                cell?.activityIndicator.stopAnimating()
            })
        }
        cell.selectedView.backgroundColor = (cellVM.isReviewed)! ? (UIColor.init(red: 170/255, green: 170/255, blue: 170/255, alpha: 70/100)) : .clear
        cell.dateLabel.text = cellVM.dateText
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.viewModel.userPressed(at: indexPath)
        performSegue(withIdentifier: "showDetailSegue", sender: self)
    }
    
}

extension MediaListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: CellIInset, left: CellIInset, bottom: CellIInset, right: CellIInset)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.cellSize()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CellIInset
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return CellIInset
    }
    
}

extension MediaListViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? MediaDetailViewController {
            vc.mediaIndex = viewModel.selectedIndex
        }
    }
}

class MediaListCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var selectedView: UIView!
    
    
}
