//
//  NoteDetailsViewController.swift
//  ReduxNotes
//
//  Created by Dima Osadchy on 13/08/2019.
//  Copyright © 2019 Alexey Demedeckiy. All rights reserved.
//

import UIKit

final class NoteDetailsViewController: UIViewController {
    struct Props {
        let title: String
        let text: String
        let edit: Command
        let endObserving: Command
    }
    
    @IBOutlet private var textView: UITextView!
    
    private var props = Props(title: "", text: "", edit: .nop, endObserving: .nop)
    
    deinit {
        props.endObserving.perform()
        print("Deinit \(self)")
    }
    
    func render(props: Props) {
        self.props = props
        view.setNeedsLayout()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Note"
        addBarButtonItems()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        textView.text = props.text
    }
    
    private func addBarButtonItems() {
        navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editTapped)), animated: true)
    }
    
    @objc private func editTapped() {
        props.edit.perform()
    }
}
