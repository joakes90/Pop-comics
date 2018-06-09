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
        print("Hello")
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections?[section].letter ?? ""
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
        cell.backgroundColor = UIColor.darkGray
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
