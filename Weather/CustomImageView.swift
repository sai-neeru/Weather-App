//
//  CustomImageView.swift
//  Weather
//
//  Created by Sai Pavan Neerukonda on 6/5/23.
//  Copyright © 2023 Sai Pavan Neerukonda. All rights reserved.
//

import Foundation
import UIKit

var imageCache = NSCache<AnyObject, AnyObject>()

class CustomImageView: UIImageView {
    
    var defaultImage: UIImage?
    
    fileprivate let activityIndicator = UIActivityIndicatorView.init(activityIndicatorStyle: .medium)
    fileprivate var downloadTask: URLSessionDataTask?
    
    var urlString: String? {
        didSet {
            loadImage(urlString: urlString ?? "")
        }
    }

    fileprivate func setImage(_ imageToSet: UIImage?) {
        DispatchQueue.main.async {[weak self] in
            self?.image = imageToSet
        }
    }
    
    func addLoader() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        activityIndicator.hidesWhenStopped = true
    }
    
    fileprivate func startLoading() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {[weak self] in
            self?.activityIndicator.startAnimating()
        }
    }
    fileprivate func stopLoadingAndSetImage(_ imageToSet: UIImage?) {
        DispatchQueue.main.async {[weak self] in
            guard let weakSelf = self else {return}
            self?.activityIndicator.stopAnimating()
            weakSelf.image = imageToSet
        }
    }
    private func loadImage(urlString: String) {
        addLoader()
        // setting image from cache if its available...
        if let cacheImage = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            setImage(cacheImage)
            return
        }
        // If Url is wrong, setting default image if available...
        guard let url = URL(string: urlString) else {
            setImage(defaultImage)
            return
        }
        // startLoading view on the imageView, in our case shimmer effect...
        startLoading()
        // Downloaging the image from the url...
        downloadTask = URLSession.shared.dataTask(with: url) {[weak self] (data, response, error) in
            guard error == nil, let data = data, let image = UIImage(data: data), let responseURL = response?.url?.absoluteString else {
                // Some error occured, hence going back to default image...
                
//                if urlString == response?.url?.absoluteString {
                    self?.stopLoadingAndSetImage(self?.defaultImage)
//                }
                return
            }
            // Saving the image cache, maping image with its url...
            imageCache.setObject(image, forKey: responseURL as AnyObject)
            // Finally setting the image if urlString is same as what we asked to download. In case urlString is changed, we dont need to set it(eg: in case of cells getting scrolled).
            
//            if urlString == response?.url?.absoluteString {
                self?.stopLoadingAndSetImage(image)
//            }
        }
        downloadTask?.resume()
    }
}
