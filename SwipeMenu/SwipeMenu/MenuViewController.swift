//
//  MenuViewController.swift
//  SwipeMenu
//
//  Created by David Martinez on 27/07/2017.
//  Copyright © 2017 atenea. All rights reserved.
//

import UIKit

protocol MenuViewControllerOutput {
    
    typealias Completion = () -> ()
    
    func closeMenu(completion: Completion?)
    
}

class MenuViewController: UIViewController {

    fileprivate var output: MenuViewControllerOutput?
    
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMenuBackground()
        
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 2.0
        imageView.layer.cornerRadius = imageView.frame.size.width / 2.0
        imageView.clipsToBounds = true
        
    }

    private func setupMenuBackground() {
        
        for view in gradientView.subviews {
            view.layer.cornerRadius = view.frame.width / 2.0
        }
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        let startColor = UIColor(red: 13.0/255.0, green: 26.0/255.0, blue: 68.0/255.0, alpha: 1.0)
        let endColor = UIColor(red: 5.0/255.0, green: 10.0/255.0, blue: 18.0/255.0, alpha: 1.0)
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        gradientView.layer.insertSublayer(gradientLayer, at: 0)
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = gradientView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        gradientView.addSubview(blurEffectView)
        gradientView.bringSubview(toFront: blurEffectView)
    }
    
    func setOutput(output: MenuViewControllerOutput) {
        self.output = output
    }
}

extension SwipeZoomMenuViewController: MenuViewControllerOutput {}

extension MenuViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if let cell = cell as? MenuCell {
            cell.show(type: MenuCell.MenuCellType(rawValue: indexPath.row)!)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64.0
    }
    
}

extension MenuViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        output?.closeMenu(completion: {
            print("My close action")
            // perform navigation to
        })
    }
    
}

class MenuCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    
    enum MenuCellType: Int {
        case home
        case lightning
        case friends
        case compass
    }
    
    func show(type: MenuCellType) {
        let image: UIImage!
        let title: String!
        switch type {
        case .home:
            image = #imageLiteral(resourceName: "home")
            title = "Feed"
        case .lightning:
            image = #imageLiteral(resourceName: "flash")
            title = "Notification"
        case .friends:
            image = #imageLiteral(resourceName: "account-multiple-plus")
            title = "Find Friends"
        case .compass:
            image = #imageLiteral(resourceName: "compass")
            title = "Explore"
        }
        
        titleLabel.text = title
        iconImageView.image = image
    }
}
