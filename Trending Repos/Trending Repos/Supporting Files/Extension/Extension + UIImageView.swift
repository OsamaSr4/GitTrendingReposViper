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
            print("Failed to load image with error: \(error)")
            return nil
        }
    }
}




private var progressLayerKey: Void?
private var trackLayerKey: Void?

extension UIImageView {

    private var progressLayer: CAShapeLayer? {
        get {
            return objc_getAssociatedObject(self, &progressLayerKey) as? CAShapeLayer
        }
        set {
            objc_setAssociatedObject(self, &progressLayerKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    private var trackLayer: CAShapeLayer? {
        get {
            return objc_getAssociatedObject(self, &trackLayerKey) as? CAShapeLayer
        }
        set {
            objc_setAssociatedObject(self, &trackLayerKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func setupCircularProgress(trackColor: UIColor = .lightGray, progressColor: UIColor = .blue, lineWidth: CGFloat = 10) {
        // Remove existing layers if any
        trackLayer?.removeFromSuperlayer()
        progressLayer?.removeFromSuperlayer()
        
        let radius = bounds.size.width / 2
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: radius, y: radius),
                                      radius: radius - lineWidth / 2,
                                      startAngle: -.pi / 2,
                                      endAngle: 2 * .pi - .pi / 2,
                                      clockwise: true)
        
        // Track layer
        let trackLayer = CAShapeLayer()
        trackLayer.path = circlePath.cgPath
        trackLayer.strokeColor = trackColor.cgColor
        trackLayer.lineWidth = lineWidth
        trackLayer.fillColor = UIColor.clear.cgColor
        layer.addSublayer(trackLayer)
        self.trackLayer = trackLayer
        
        // Progress layer
        let progressLayer = CAShapeLayer()
        progressLayer.path = circlePath.cgPath
        progressLayer.strokeColor = progressColor.cgColor
        progressLayer.lineWidth = lineWidth
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.strokeEnd = 0
        layer.addSublayer(progressLayer)
        self.progressLayer = progressLayer
    }
    
    func setProgress(_ progress: CGFloat) {
        progressLayer?.strokeEnd = progress
    }
    
    func simulateImageLoadingProgress() {
        for i in stride(from: 0.0, to: 1.1, by: 0.1) {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i)) {
                self.setProgress(CGFloat(i))
            }
        }
    }
}
