//
//  SplashViewController.swift
//  ReduxNotes
//
//  Created by Dima Osadchy on 12/08/2019.
//  Copyright © 2019 Alexey Demedeckiy. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
    }
    
    private func configureView() {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 150, height: 50))
        label.center = self.view.center
        label.text = "Loading content..."
        label.textColor = .black
        view.addSubview(label)
        
        view.backgroundColor = .white
    }
}
