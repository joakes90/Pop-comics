//
//  BookViewController.swift
//  Pop Comics
//
//  Created by justin on 6/2/18.
//  Copyright © 2018 Oklasoft LLC. All rights reserved.
//

import UIKit

class BookViewController: UIPageViewController, UIPageViewControllerDataSource {
  
    var comicMetadata: Metadata?
    var book: Book?
    var bookViewControllers: [BookPageViewController]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        ProgressView.show()
        guard let path = URL(string: (comicMetadata?.url) ?? "")?.path else {
            dismiss(animated: true, completion: nil)
            return
        }
        book = ComicManager.openComic(at: path)
        bookViewControllers = ComicManager.pageViewControllers(for: book ?? Book())
        if let firstViewController = bookViewControllers?.first {
            setViewControllers([firstViewController],
                               direction: UIPageViewControllerNavigationDirection.forward,
                               animated: true,
                               completion: nil)
        }
        reloadInputViews()
        ProgressView.hide()
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return bookViewControllers?.count ?? 0
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let currentIndex = bookViewControllers?.index(of: viewController as? BookPageViewController ?? BookPageViewController()) ?? 0
        if currentIndex <= 0 {
            return nil
        }
        return bookViewControllers?[currentIndex - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let currentIndex = bookViewControllers?.index(of: viewController as? BookPageViewController ?? BookPageViewController()) ?? 0
        if currentIndex >= (bookViewControllers?.count ?? 0) - 1 {
            return nil
        }
        return bookViewControllers?[currentIndex + 1]
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
