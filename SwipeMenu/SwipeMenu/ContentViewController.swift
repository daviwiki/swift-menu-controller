//
//  ContentViewController.swift
//  SwipeMenu
//
//  Created by David Martinez on 27/07/2017.
//  Copyright © 2017 atenea. All rights reserved.
//

import UIKit

protocol ContentViewControllerOutput: NSObjectProtocol {
    func openMenu()
}

class ContentViewController: UIViewController {

    private weak var output: ContentViewControllerOutput?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(openMenu))
        view.addGestureRecognizer(gesture)
    }

    func setOutput(output: ContentViewControllerOutput) {
        self.output = output
    }
    
    @objc private func openMenu() {
        output?.openMenu()
    }
    
}

/**
 SwipeZoomMenuViewController extension. This extension allow sync the
 input method 'openMenu' of SwipeZoomMenuViewController with the 'openMenu'
 output of this class
 */
extension SwipeZoomMenuViewController: ContentViewControllerOutput {}
