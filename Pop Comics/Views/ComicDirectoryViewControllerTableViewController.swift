//
//  ComicDirectoryViewControllerTableViewController.swift
//  Pop Comics
//
//  Created by Justin Oakes on 12/5/18.
//  Copyright © 2018 Oklasoft LLC. All rights reserved.
//

import UIKit

class ComicDirectoryViewControllerTableViewController: UITableViewController {
    
    var sections: [ComicSecton]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let backButton = UIBarButtonItem(title: nil, style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backButton
        sections = FileController.shared.comicPathsBySection()
        refreshControl = UIRefreshControl()
        refreshControl?.tintColor = UIColor.yellow
        refreshControl?.addTarget(self,
                                  action: #selector(refresh),
                                  for: .valueChanged)
    }
    
    @objc func refresh() {
        sections = FileController.shared.comicPathsBySection()
        tableView.reloadData()
        refreshControl?.endRefreshing()
    }

    func displayFirstRunLabel() {
        let onboardLabel = UILabel()
        onboardLabel.font = UIFont(name: "Comic Panels", size: 18)
        onboardLabel.text = "Upload CBZ and CBR files from iTunes or copy into Pop Comics from the Files app to get started"
        onboardLabel.textColor = .yellow
        onboardLabel.numberOfLines = 0
        onboardLabel.textAlignment = .center
        tableView.backgroundView = onboardLabel
        tableView.separatorStyle = .none
    }
    
    func removeFirstRunLabel() {
        tableView.separatorStyle = .singleLine
        tableView.backgroundView = nil
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        let sectionCount = sections?.count ?? 0
        if sectionCount <= 0 {
            displayFirstRunLabel()
            return sectionCount
        }
        removeFirstRunLabel()
        return sectionCount
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionTitle = sections?[section].letter ?? ""
        let label = UILabel(frame: CGRect(x: 10.0,
                                          y: 8.0,
                                          width: 320.0,
                                          height: 20.0))
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor.yellow
        label.font = UIFont(name: "BadaBoom BB", size: 24.0)
        label.text = sectionTitle
        let view = UIView(frame: CGRect(x: 0.0,
                                        y: 0.0,
                                        width: 320.0,
                                        height: 20.0))
        view.addSubview(label)
        return view
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = sections?[section]
        return section?.comicPaths.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sections?[indexPath.section]
        let comicPath = section?.comicPaths[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: tableViewCellIdentifers.comicPathIdentifier.rawValue, for: indexPath)
        cell.textLabel?.text = comicPath?.name ?? ""
        cell.textLabel?.font = UIFont(name: "Comic Panels", size: 14) ?? UIFont.systemFont(ofSize: 14)
        cell.textLabel?.textColor = UIColor.yellow
        cell.backgroundColor = #colorLiteral(red: 0.4705882353, green: 0.1647058824, blue: 0.5058823529, alpha: 1)
        return cell
    }

    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        var titles = [String]()
        sections?.forEach({ (section) in
            titles.append(section.letter)
        })
        return titles
    }
    
    override func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return sections?.index(where: { $0.letter == title }) ?? 0
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? BrowserViewController {
            let selectedIndexPath = tableView.indexPathForSelectedRow
            guard let selectedPath = sections?[(selectedIndexPath?.section) ?? 0].comicPaths[selectedIndexPath?.row ?? 0] else {
                return
            }
            destination.title = selectedPath.name
            destination.updateOpenPath(comicPath: selectedPath)
        }
    }

}

enum tableViewCellIdentifers: String {
    case comicPathIdentifier = "comicPathIdentifier"
}
