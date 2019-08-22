//
//  ContainerScreenFactory.swift
//  ReduxNotes
//
//  Created by Dima Osadchy on 12/08/2019.
//  Copyright © 2019 Alexey Demedeckiy. All rights reserved.
//

import UIKit

final class ContainerScreenFactory {
    class func `default`() -> ContainerViewController {
        return ContainerViewController(nibName: nil, bundle: nil)
    }
    
    class func splash() -> UIViewController {
        return SplashViewController()
    }
}
