//
//  MenuTabBarViewController.swift
//  ReduxNotes
//
//  Created by Dima Osadchy on 12/08/2019.
//  Copyright © 2019 Alexey Demedeckiy. All rights reserved.
//

import UIKit

private enum TabBarItem {
    case personalNotes
    case commonNotes
    
    var tag: Int {
        switch self {
        case .personalNotes:
            return 1
        case .commonNotes:
            return 2
        }
    }
    
    var ui: UITabBarItem {
        switch self {
        case .personalNotes:
            return UITabBarItem(title: "Personal Notes", image: nil, tag: tag)
        case .commonNotes:
            return UITabBarItem(title: "Common Notes", image: nil, tag: tag)
        }
    }
    
    init?(tag: Int) {
        switch tag {
        case TabBarItem.personalNotes.tag:
            self = .personalNotes
        case TabBarItem.commonNotes.tag:
            self = .commonNotes
        default:
            return nil
        }
    }
}

class MenuTabBarViewController: UITabBarController {
    struct Props {
        let personalNote: Command
        let commonNotes: Command
        let endObserving: Command
    }
    
    private var props = Props(personalNote: .nop, commonNotes: .nop, endObserving: .nop)
    
    deinit {
        props.endObserving.perform()
        print("Deinit Successfully")
    }
    
    func render(props: Props) {
        self.props = props
        view.setNeedsLayout()
    }

    func configureTabBar(personalNotes: UINavigationController, commonNotes: UINavigationController) {
        personalNotes.tabBarItem = TabBarItem.personalNotes.ui
        commonNotes.tabBarItem = TabBarItem.commonNotes.ui
        setViewControllers([personalNotes, commonNotes], animated: false)
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard let tabBarItem = TabBarItem(tag: item.tag) else {
            return
        }
        
        switch tabBarItem {
        case .commonNotes:
            props.commonNotes.perform()
        case .personalNotes:
            props.personalNote.perform()
        }
    }
}
