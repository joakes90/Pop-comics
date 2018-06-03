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
        dataSource = self
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
        bookViewControllers?.forEach( { $0.delegate = self })
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
        if currentIndex >= (bookViewControllers?.count ?? 999) - 1 {
            return nil
        }
        return bookViewControllers?[currentIndex + 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let currentIndex = bookViewControllers?.index(of: viewController as? BookPageViewController ?? BookPageViewController()) ?? 0
        if currentIndex <= 0 {
            return nil
        }
        return bookViewControllers?[currentIndex - 1]
    }
    
}

extension BookViewController: BookViewDismissProtocol {
    
    func dismissPageView() {
        dismiss(animated: true) {
            self.comicMetadata = nil
            self.book = nil
            self.bookViewControllers = nil
        }
    }
}

protocol BookViewDismissProtocol {
    
    func dismissPageView()
}
