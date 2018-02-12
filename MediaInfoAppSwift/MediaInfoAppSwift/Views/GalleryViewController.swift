//
//  GalleryViewController.swift
//  TestMediaInfoApp
//
//  Created by sargis on 2/11/18.
//  Copyright © 2018 sargis. All rights reserved.
//

import UIKit
import RealmSwift
import Kingfisher

class GalleryViewController: UIViewController {

    lazy var viewModel: GalleryViewModel = {
        return GalleryViewModel()
    }()
    
    fileprivate let CellIInset:CGFloat = 10.0
    fileprivate let CellIdentifiler = "GalleryListViewcellId"
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initVM()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initVM() {
        viewModel.initFetch()
        viewModel.reloadCollectionViewClosure = { [weak self] () in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
    }

}

extension GalleryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfCells
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifiler, for: indexPath) as? GalleryViewCell else {
            fatalError("Cell doesn't exists in storyboard")
        }
        let cellVM = viewModel.getCellViewModel(at: indexPath)
        if cellVM.thumbnailUrl != "" {
            cell.activityIndicator.startAnimating()
            cell.coverImageView?.kf.setImage(with: URL( string: cellVM.thumbnailUrl!), placeholder: nil, options: nil, progressBlock: nil, completionHandler: { [weak cell](image, error, cachType, imageUrl) in
                if error != nil {
                    print(error!)
                }
                cell?.activityIndicator.stopAnimating()
            })
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.imageTapped(at: indexPath)
    }
    
    // show image in full screen mode
    func imageTapped(at indexPath: IndexPath) {
        let cellVM = self.viewModel.cellViewModels[indexPath.row]
        if self.viewModel.galleryType == .image {
            openImageInFullScreen(viewModel: cellVM)
        }
        else {
            openYoutubeVideo(viewModel: cellVM)
        }
        
    }
    
    func openImageInFullScreen(viewModel: GalleryCellViewModel) {
        let newImageView = UIImageView()
        newImageView.frame = UIScreen.main.bounds
        newImageView.backgroundColor = .black
        newImageView.contentMode = .scaleAspectFit
        newImageView.isUserInteractionEnabled = true
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
        activityIndicator.center = newImageView.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        newImageView.addSubview(activityIndicator)
        newImageView.kf.setImage(with: URL( string: viewModel.contentUrl!), placeholder: nil, options: nil, progressBlock: nil, completionHandler: { (image, error, cachType, imageUrl) in
            if error != nil {
                print(error!)
            }
            activityIndicator.stopAnimating()
        })
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage))
        newImageView.addGestureRecognizer(tap)
        self.view.addSubview(newImageView)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func openYoutubeVideo(viewModel: GalleryCellViewModel ) {
        let youtubeId = viewModel.youtubeId!
        if let youtubeURL = URL(string: "youtube://\(youtubeId))"),
            UIApplication.shared.canOpenURL(youtubeURL) {
            // redirect to app
            UIApplication.shared.open(youtubeURL, options: [:], completionHandler: nil)
        } else {
            if let youtubeURL = URL(string: "https://www.youtube.com/watch?v=\(youtubeId))") {
                // redirect through safari
                UIApplication.shared.open(youtubeURL, options: [:], completionHandler: nil)
            }
        }
    }
    
    @objc func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
        sender.view?.removeFromSuperview()
    }
    
}

extension GalleryViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: CellIInset, left: CellIInset, bottom: CellIInset, right: CellIInset)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.cellSizeForThumbnail()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CellIInset
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return CellIInset
    }
    
}


class GalleryViewCell: UICollectionViewCell {
    //@IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var coverImageView: UIImageView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
}
