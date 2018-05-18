//
//  ShowAboutViewController.swift
//  TriZN Profile
//
//  Created by Tri ZN on 5/9/18.
//  Copyright © 2018 Tri ZN. All rights reserved.
//

import UIKit

class ShowAboutViewController: UIViewController {
    private var _color = UIColor()
    let titleLabel = UILabel()
    let lineView = UIView()
    let tableView = UITableView()
    var dataArray = [AboutCellContent]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _color = randomColor()
        
        
    }

    // MARK: - Private methods
    
    /**
    * Function configure tableview
    */
    
    private func configureTableView() {
        tableView.register(UINib(nibName: "AboutCell", bundle: nil), forCellReuseIdentifier: String(describing: AboutCell.self))
    
        tableView.dataSource = self
        tableView.delegate = self
    
        tableView.estimatedRowHeight = 60
        tableView.rowHeight = UITableViewAutomaticDimension
    
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = UIColor.groupTableViewBackground
    
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .none
    }
    
    /**
     * Function get random color for line
     */
    private func randomColor() -> UIColor {
        let hue : CGFloat = CGFloat(arc4random() % 256) / 256 // use 256 to get full range from 0.0 to 1.0
        let saturation : CGFloat = CGFloat(arc4random() % 128) / 256 + 0.5 // from 0.5 to 1.0 to stay away from white
        let brightness : CGFloat = CGFloat(arc4random() % 128) / 256 + 0.5 // from 0.5 to 1.0 to stay away from black
        
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1)
    }
    
    /**
     * Function configure subviews
     */
     private func configureSubviews(title: String, content: [String: Array<String>]) {
        // tableview
        configureTableView()
        
        // Set view to color group table
        self.view.backgroundColor = UIColor.groupTableViewBackground
        
        // Label Title
        var rect = CGRect(x: 0,
                          y: 60,
                          width: DEVICE_WIDTH,
                          height: 30 * DISPLAY_SCALE)
        let titleLabel = UILabel(frame: rect)
        titleLabel.textAlignment = .center
        titleLabel.text = title.uppercased()
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18.0 * DISPLAY_SCALE)
        titleLabel.sizeToFit()
        
        // Update frame title
        titleLabel.frame.origin.x = (DEVICE_WIDTH - titleLabel.frame.width ) / 2
        
        self.view.addSubview(titleLabel)
        
        // Line view
        rect.size.height = 1.0
        rect.size.width = titleLabel.frame.width
        rect.origin.x = (DEVICE_WIDTH - titleLabel.frame.width) / 2
        rect.origin.y = titleLabel.frame.maxY
        
        lineView.frame = rect
        lineView.backgroundColor = _color
        
        self.view.addSubview(lineView)
        
        rect.size.width = DEVICE_WIDTH - 32
        rect.size.height = DEVICE_HEIGHT * 2/3
        rect.origin.x = (DEVICE_WIDTH - rect.size.width) / 2
        rect.origin.y = lineView.frame.maxY + 10
        tableView.frame = rect
        
        view.addSubview(tableView)

        for item in content {
            let heading = item.key
            var body = String()
            for string in item.value {
                body = body + string + "\n"
            }
            dataArray.append(AboutCellContent(heading: heading, body: body, color: _color))
        }

    }
    
    // MARK: - Public methods
 
    /*
     Func parse dictionary from file plist pust to show about vc
    */
    func parseDictionaryToArray(with dictionary: [String:Any]?) {

        if let dict = dictionary {
            var title = String()

            for element in dict {
                title = element.key
                if let content = element.value as? [String: Array<String>] {// Content is Array

                self.configureSubviews(title: title, content: content)
                }
            }
  
        }

    }

}

// MARK: - Extensions UITableViewDataSource
extension ShowAboutViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: AboutCell = tableView.dequeueReusableCell()
        
        dataArray.last?.line = false
        
        cell.set(content: dataArray[indexPath.row])
        
        return cell

    }

}

// MARK: - Extensions UITableViewDelegate
extension ShowAboutViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let content = dataArray[indexPath.row]
        content.expended = !content.expended
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}

