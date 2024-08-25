//
//  RepositoriesCell.swift
//  Trending Repos
//
//  Created by MacBook Pro on 25/08/2024.
//

import UIKit
import SkeletonView

class RepositoriesCell: UITableViewCell ,IdentifiableCell{
    
    @IBOutlet weak var avatar_background_view: UIView!
    @IBOutlet weak var avatar_image: UIImageView!
    @IBOutlet weak var repo_name: UILabel!
    @IBOutlet weak var user_name: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupCell()
    }
    
   private func setupCell(){
       self.avatar_image.layer.cornerRadius = self.avatar_image.bounds.height / 2
       self.avatar_background_view.layer.cornerRadius = self.avatar_background_view.bounds.height / 2
    }
    
    func configure(with repository: Repository) {
        repo_name.text = repository.name
        user_name.text = repository.owner.login // Assuming you want to show the owner's username
        
        if let url = URL(string: repository.owner.avatarUrl) {
            // Load the image asynchronously
            Task {
                let image = await UIImage.load(from: url)
                avatar_image.image = image
            }
        }
    }
}
