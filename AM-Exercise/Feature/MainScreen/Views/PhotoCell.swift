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
    
    private var viewModel: PhotoCellViewModel?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        viewModel?.cancelTask()
        imageView.image = nil
    }
    
    func fillData(photo: Photo) {
        viewModel = PhotoCellViewModel(photo: photo, networkClient: NetworkClient())
        
        label.text = viewModel?.labelText
        descriptionLabel.text = viewModel?.descriptionText
    }
    
    func setImage(on urlString: String) {
        viewModel?.setImage(on: urlString) { [weak self] image in
            DispatchQueue.main.async {
                self?.imageView.image = image
            }
        }
    }
}
