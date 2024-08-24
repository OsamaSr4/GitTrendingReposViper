//
//  RepositoriesCell.swift
//  Trending Repos
//
//  Created by MacBook Pro on 25/08/2024.
//

import UIKit

class RepositoriesCell: UITableViewCell ,IdentifiableCell{
    
    @IBOutlet weak var avatar_image: UIImageView!
    @IBOutlet weak var repo_name: UILabel!
    @IBOutlet weak var user_name: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        avatar_image.setupCircularProgress(trackColor: UIColor(hexString: "#307279"), progressColor: .blue)
        
    }
    
    
    func configure(with repository: Repository) {
        repo_name.text = repository.name
        user_name.text = repository.owner.login // Assuming you want to show the owner's username
        
        if let url = URL(string: repository.owner.avatarUrl) {
            // Load the image asynchronously
            Task {
                let image = await UIImage.load(from: url)
                avatar_image.image = image
                
                // Simulate progress
                avatar_image.simulateImageLoadingProgress()
            }
        }
    }
}
