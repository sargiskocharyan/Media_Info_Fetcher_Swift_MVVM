//
//  MediaDetailViewController.swift
//  TestMediaInfoApp
//
//  Created by sargis on 2/9/18.
//  Copyright © 2018 sargis. All rights reserved.
//

import UIKit
import Kingfisher
import RealmSwift

class MediaDetailViewController: UIViewController {

    var mediaIndex: Int?
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var coverImageView: UIImageView!
    
    @IBOutlet weak var categoryLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var galleryButton: UIButton!
    
    @IBOutlet weak var videoButton: UIButton!
    
    @IBAction func galleryIsTapped(_ sender: Any) {
    }
    
    @IBAction func videoIsTapped(_ sender: Any) {
    }
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var bodyTextView: UITextView!
    
    
    lazy var viewModel: MediaDetailViewModel = {
        return MediaDetailViewModel()
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.initVM()
        self.initView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initVM() {
        if mediaIndex != nil {
            viewModel.initFetchMedia(mediaIndex:self.mediaIndex!)
        }
    }
    
    func initView(){
        
        guard mediaIndex != nil else {
            return
        }
        
        titleLabel.text = viewModel.titleText
        categoryLabel.text = viewModel.categoryText
        dateLabel.text = viewModel.dateText
        if viewModel.coverPhotoUrl != nil {
            self.activityIndicator.startAnimating()
            coverImageView?.kf.setImage(with: URL( string: (viewModel.coverPhotoUrl)!)!, placeholder: nil, options: nil, progressBlock: nil, completionHandler: { [weak self](image, error, cachType, imageUrl) in
                
                self?.activityIndicator.stopAnimating()
            })
        }
        self.bodyTextView.text = viewModel.bodyText
        if viewModel.video != nil, (viewModel.video?.count)! > 0 {
            videoButton.isHidden = false
        }
        if viewModel.gallery != nil, (viewModel.gallery?.count)! > 0 {
            galleryButton.isHidden = false
        }
        
        self.viewModel.markMediaAsSeen()
    }
    

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let identifier = segue.identifier!
        switch identifier {
        case "GallerySegueId":
            if let vc = segue.destination as? GalleryViewController {
                vc.viewModel.selectedMediaIndex = mediaIndex
                vc.viewModel.galleryType = .image
            }
        case "VideoSegueId":
            if let vc = segue.destination as? GalleryViewController {
                vc.viewModel.selectedMediaIndex = mediaIndex
                vc.viewModel.galleryType = .video
            }
            break
        default:
            break
        }

    }
}

enum GalleryType {
    case video
    case image
}
