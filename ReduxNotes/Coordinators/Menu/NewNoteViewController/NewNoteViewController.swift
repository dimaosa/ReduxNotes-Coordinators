//
//  NewNoteViewController.swift
//  ReduxNotes
//
//  Created by Dima Osadchy on 14/08/2019.
//  Copyright © 2019 Alexey Demedeckiy. All rights reserved.
//

import UIKit

final class NewNoteViewController: UIViewController, UITextViewDelegate {
    struct Props {
        let title: String
        let text: String
        let updateText: CommandWith<String>
        let cancel: Command
        let save: Command?
        let endObserving: Command
    }
    
    var props = Props(
        title: "",
        text: "",
        updateText: .nop,
        cancel: .nop,
        save: nil,
        endObserving: .nop
    )
    
    func render(props: Props) {
        self.props = props
        view.setNeedsLayout()
    }
    
    @IBOutlet private var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.delegate = self
        addBarButtonItems()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        textView.becomeFirstResponder()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        title = props.title
        textView.text = props.text
    }
    
    deinit {
        props.endObserving.perform()
        print("Deinit \(self)")
    }
    
    func textViewDidChange(_ textView: UITextView) {
        props.updateText.perform(with: textView.text)
    }
    
    private func addBarButtonItems() {
        navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveTapped)), animated: true)
        navigationItem.setLeftBarButton(UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelTapped)), animated: true)
    }
    
    @objc private func saveTapped() {
        props.save?.perform()
    }
    
    @objc private func cancelTapped() {
        props.cancel.perform()
    }
}

