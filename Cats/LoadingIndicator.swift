//
//  LoadingIndicator.swift
//  Cats
//
//  Created by Артем Соколовский on 09.07.2021.
//

import UIKit

class LoadingIndicator: UIView {

    static let shared = LoadingIndicator()
    
    func showLoading(in view: UIView) -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.startAnimating()
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
        return activityIndicator
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
