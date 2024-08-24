//
//  Extension + UIViewcontroller.swift
//  Trending Repos
//
//  Created by MacBook Pro on 25/08/2024.
//

import Foundation
import UIKit

extension UIViewController {
    
    class var storyboardID : String {
        return "\(self)"
    }
    
    static func instantiate(fromStoryBoards storyboard: StoryBoards) -> Self {
        return storyboard.viewController(viewControllerClass: self)
    }
}
