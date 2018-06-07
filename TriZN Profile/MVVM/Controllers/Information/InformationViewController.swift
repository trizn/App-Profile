//
//  InformationViewController.swift
//  TriZN Profile
//
//  Created by Tri ZN on 3/22/18.
//  Copyright © 2018 Tri ZN. All rights reserved.
//

import UIKit

enum NibNameCell: String {
    case InfomationTableViewCell
    case AvatarTableViewCell
}

class InformationViewController: UIViewController {

    // MARK: - Properties
    private var _rectCellAvatar = CGRect()
    
    // MARK: - IB
    @IBOutlet weak var infoTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureSubviews()
        
        self.navigationItem.title = "Infomation"

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        _rectCellAvatar = infoTableView.rectForRow(at: IndexPath.init(row: 0, section: 0))
    }
    
    override func loadView() {
        super.loadView()
        infoTableView.reloadData()
    }

    // MARK: - Configure Subviews
    func configureSubviews() {
        infoTableView.register(UINib(nibName: NibNameCell.InfomationTableViewCell.rawValue, bundle: nil), forCellReuseIdentifier: String(describing: InfomationTableViewCell.self))
        infoTableView.register(UINib(nibName: NibNameCell.AvatarTableViewCell.rawValue, bundle: nil), forCellReuseIdentifier: String(describing: AvatarTableViewCell.self))
        
        infoTableView.estimatedRowHeight = 44
        infoTableView.rowHeight = UITableViewAutomaticDimension
        
        infoTableView.dataSource = self
        infoTableView.delegate = self
    }
    
    func imageTitleInNavigationBar(_ y: Float) {
        if y <= 20 {
            self.navigationItem.titleView = nil
            self.navigationItem.title = "Infomation"
        } else {
            let avatarImage = UIImage(named: Constants.Information.avatar)

            var rectSize = CGRect(x: 0, y: 0, width: 40, height: 40)
            let marginX = ((self.navigationController?.navigationBar.frame.size.width)! - rectSize.width) / 2

            rectSize.origin.x = marginX

            let titleView = UIView(frame: rectSize)
            rectSize.origin.x = 0
            let imageView = UIImageView(frame: rectSize)

            // Corner radius = circle
            imageView.layer.cornerRadius = imageView.bounds.width / 2.0

            imageView.clipsToBounds = true
            imageView.image = avatarImage

            titleView.addSubview(imageView)
            self.navigationItem.titleView = titleView

            self.navigationItem.titleView?.alpha = CGFloat(y) / _rectCellAvatar.height
            
        }
    }
    
    func fadeInImage() {
        
    }
    
}

// MARK: UITableViewDataSource
extension InformationViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var contentCell: Dictionary = [String : Any]()
        if(indexPath.section == 0) {
            let cell: AvatarTableViewCell = tableView.dequeueReusableCell()
            return cell
        }
        
        let cell: InfomationTableViewCell = tableView.dequeueReusableCell()
        
        switch indexPath.row {
        case 0: // Mail
            contentCell["icon"] = UIImage(named: Constants.Information.iconMail)
            contentCell["text"] = Constants.Information.mail
        case 1: // Mobile
            contentCell["icon"] = UIImage(named: Constants.Information.iconMobile)
            contentCell["text"] = Constants.Information.mobile
        case 2: // Chat
            contentCell["icon"] = UIImage(named: Constants.Information.iconChat)
            contentCell["text"] = Constants.Information.chat
        case 3: // Birthday
            contentCell["icon"] = UIImage(named: Constants.Information.iconBirthday)
            contentCell["text"] = Constants.Information.birthday
        case 4: // Address
            contentCell["icon"] = UIImage(named: Constants.Information.iconAddress)
            contentCell["text"] = Constants.Information.address
        default: // Educationn)
            contentCell["icon"] = UIImage(named: Constants.Information.iconEducation)
            contentCell["text"] = Constants.Information.education
        }
        
        cell.setContent(withIcon: contentCell["icon"] as? UIImage, textLabel: contentCell["text"] as? String)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }
    
}

// MARK: - UITableViewDelegate
extension InformationViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 25
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.section == 0) {
            return 150 
        }
        return UITableViewAutomaticDimension
    }
    
}

// MARK: - UIScrollViewDelegate
extension InformationViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Get height cell Avatar
//        let heightCellAvatar = infoTableView.rectForRow(at: IndexPath(row: 0, section: 0))
        
        if scrollView.contentOffset.y <= _rectCellAvatar.height {
             let y = Float(scrollView.contentOffset.y)
            imageTitleInNavigationBar(y)
       
        }
    }
}






