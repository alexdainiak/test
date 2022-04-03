//
//  PhotoCell.swift
//  AM-Exercise
//
//  Created by Michael Mavris on 20/07/2021.
//  Copyright © 2021 Michael Mavris. All rights reserved.
//

import Foundation
import UIKit

final class PhotoCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView! {
        didSet {
            imageView.layer.cornerRadius = 6
            imageView.clipsToBounds = true
            imageView.contentMode = .scaleAspectFill
        }
    }
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    private var task: URLSessionDataTask?
    private var imageUrl: String?
    var networkClient: NetworkClientProtocol?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.networkClient = NetworkClient()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        task?.cancel()
        task = nil
        imageView.image = nil
    }
    
    func fillData(photo: Photo) {
        imageUrl = photo.previewURL ?? photo.largeImageURL
        label.text = "Author: \n\(photo.user)"
        descriptionLabel.text = "Photo ID:\n\(photo.id)"
    }
    
    func setImage(on urlString: String) {
        if task == nil {
            task = networkClient?.fetchImage(on: urlString) { [weak self] result in
                guard
                    let self = self,
                    self.imageUrl == urlString
                else { return }
                
                switch result {
                case .success(let image):
                    DispatchQueue.main.async {
                        //print("fetched \(urlString)")
                        self.imageView.image = image
                    }
                case .failure:
                    DispatchQueue.main.async {
                        self.imageView.image = nil
                    }
                }
            }
        }
    }
}
