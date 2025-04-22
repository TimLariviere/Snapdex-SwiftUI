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

    func makeUIView(context: Context) -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true

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
                    images.append(UIImage(cgImage: cgImage))
                }
            }

            imageView.animationImages = images
            imageView.animationDuration = duration
            imageView.startAnimating()
        }

        return imageView
    }

    func updateUIView(_ uiView: UIImageView, context: Context) {}

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
