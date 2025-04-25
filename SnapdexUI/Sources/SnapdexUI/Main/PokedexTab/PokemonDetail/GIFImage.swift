//
//  GIFImage.swift
//  SnapdexUI
//
//  Created by Timothé Larivière on 22/04/2025.
//


import SwiftUI
import SnapdexDesignSystem
import SnapdexDomain
import SwiftUI
import UIKit

struct GIFImage: UIViewRepresentable {
    let gifName: String
    let bundle: Bundle
    
    init(gifName: String, bundle: Bundle = .main) {
        self.gifName = gifName
        self.bundle = bundle
    }
    
    func makeUIView(context: Context) -> UIView {
        // Create a container view
        let containerView = UIView()
        
        // Create the image view for the GIF
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        
        // Improve rendering for upscaling
        imageView.layer.magnificationFilter = .nearest
        imageView.layer.minificationFilter = .trilinear
        imageView.layer.shouldRasterize = false
        
        // Add imageView to container with proper constraints
        containerView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
        
        // Load and display the GIF
        if let path = bundle.path(forResource: gifName, ofType: "gif"),
           let data = try? Data(contentsOf: URL(fileURLWithPath: path)),
           let source = CGImageSourceCreateWithData(data as CFData, nil) {
            
            var images: [UIImage] = []
            var duration: Double = 0
            
            let count = CGImageSourceGetCount(source)
            for i in 0..<count {
                if let cgImage = CGImageSourceCreateImageAtIndex(source, i, nil) {
                    let frameDuration = GIFImage.frameDuration(at: i, source: source)
                    duration += frameDuration
                    
                    // Create UIImage with better rendering options
                    let uiImage = UIImage(cgImage: cgImage, scale: 1.0, orientation: .up)
                    images.append(uiImage)
                }
            }
            
            imageView.animationImages = images
            imageView.animationDuration = duration
            imageView.startAnimating()
            
            // Set the intrinsic content size to match the GIF's actual size
            if let firstImage = images.first {
                let originalSize = firstImage.size
                let aspectRatio = originalSize.width / originalSize.height
                
                // Set a constraint to maintain the original aspect ratio
                let aspectConstraint = NSLayoutConstraint(
                    item: imageView,
                    attribute: .width,
                    relatedBy: .equal,
                    toItem: imageView,
                    attribute: .height,
                    multiplier: aspectRatio,
                    constant: 0
                )
                aspectConstraint.priority = .defaultHigh
                containerView.addConstraint(aspectConstraint)
            }
        }
        
        return containerView
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
    
    static func frameDuration(at index: Int, source: CGImageSource) -> Double {
        let defaultFrameDuration = 0.1
        guard let properties = CGImageSourceCopyPropertiesAtIndex(source, index, nil) as? [CFString: Any],
              let gifProperties = properties[kCGImagePropertyGIFDictionary] as? [CFString: Any],
              let delayTime = gifProperties[kCGImagePropertyGIFUnclampedDelayTime] as? Double ?? gifProperties[kCGImagePropertyGIFDelayTime] as? Double
        else {
            return defaultFrameDuration
        }
        return delayTime > 0.011 ? delayTime : defaultFrameDuration
    }
}
