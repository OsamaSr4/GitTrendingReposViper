//
//  Extension + UIImageView.swift
//  Trending Repos
//
//  Created by MacBook Pro on 25/08/2024.
//

import Foundation
import UIKit
import ObjectiveC

extension UIImage {
    static func load(from url: URL) async -> UIImage? {
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            return UIImage(data: data)
        } catch {
            return UIImage(named: "ic_profile_placeholder")
        }
    }
}
