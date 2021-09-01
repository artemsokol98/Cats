//
//  SingleImageVC.swift
//  Cats
//
//  Created by Артем Соколовский on 22.08.2021.
//

import UIKit

class SingleImageVC: UIViewController {
    
    var imageScroolView: ImageScrollView!
    
    var imageIndex: Int!
    override func viewDidLoad() {
        super.viewDidLoad()

        imageScroolView = ImageScrollView(frame: view.bounds)
        view.addSubview(imageScroolView)
        setupImageScrollView()
        let image = DataManager.shared.singleImages[imageIndex]
        self.imageScroolView.set(image: image!)
    }
    
    func setupImageScrollView() {
        imageScroolView.translatesAutoresizingMaskIntoConstraints = false
        imageScroolView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        imageScroolView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        imageScroolView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        imageScroolView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    }

}
