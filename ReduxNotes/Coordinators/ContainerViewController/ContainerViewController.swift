//
//  ContainerViewController.swift
//  ReduxNotes
//
//  Created by Dima Osadchy on 13/08/2019.
//  Copyright © 2019 Alexey Demedeckiy. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController {
    @IBOutlet private weak var containerView: UIView!
    private weak var contentController: UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override var childForStatusBarStyle: UIViewController? {
        return contentController
    }
    
    override var prefersStatusBarHidden: Bool {
        return contentController?.prefersStatusBarHidden ?? false
    }
    
    func displayContentController(_ contentController: UIViewController?) {
        removeContentController()
        
        guard let contentController = contentController else { return }
        
        addChild(contentController)
        contentController.view.frame = containerView.frame
        containerView.addSubview(contentController.view)
        contentController.didMove(toParent: self)
        self.contentController = contentController
        setNeedsStatusBarAppearanceUpdate()
    }

    func removeContentController() {
        contentController?.dismiss(animated: false)
        contentController?.willMove(toParent: nil)
        contentController?.view.removeFromSuperview()
        contentController?.removeFromParent()
        contentController = nil
    }
}
