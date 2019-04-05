//
//  BookViewController.swift
//  Pop Comics
//
//  Created by justin on 6/2/18.
//  Copyright © 2018 Oklasoft LLC. All rights reserved.
//

import UIKit

class BookViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
  
    var comicMetadata: Metadata?
    var book: Book?
    var bookViewControllers: [BookPageViewController]?
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if bookViewControllers == nil {
            setUp()
        }
    }
    
    private func setUp() {
        guard let path = URL(string: (comicMetadata?.url) ?? "")?.path else {
            dismiss(animated: true, completion: nil)
            return
        }
        book = ComicManager.openComic(at: path)
        bookViewControllers = ComicManager.pageViewControllers(for: book ?? Book())
        bookViewControllers?.forEach({ (viewController) in
            viewController.delegate = self
            let currentIndex = bookViewControllers?.firstIndex(of: viewController)
            viewController.pageNumber = (currentIndex ?? 0) + 1
            viewController.totalPages = bookViewControllers?.count
            viewController.bookViewController = self
        })
        if let viewControllers = bookViewControllers,
            let metadata = comicMetadata {
            let index = Int(metadata.openPage)
            openTo(page: index, in: viewControllers)
            reloadInputViews()
            comicMetadata?.read = true
            ProgressView.hide()
        }
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return bookViewControllers?.count ?? 0
    }
    
    private func openTo(page: Int, in viewControllers: [BookPageViewController]) {
        let openPage = viewControllers[page]
        comicMetadata?.openPage = Int16(page)
        setViewControllers([openPage],
                           direction: .forward,
                           animated: false,
                           completion: nil)
        }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let currentIndex = bookViewControllers?.firstIndex(of: viewController as? BookPageViewController ?? BookPageViewController()) ?? 0
        if currentIndex >= (bookViewControllers?.count ?? 999) - 1 {
            return nil
        }
        return bookViewControllers?[currentIndex + 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let currentIndex = bookViewControllers?.firstIndex(of: viewController as? BookPageViewController ?? BookPageViewController()) ?? 0
        if currentIndex <= 0 {
            return nil
        }
        return bookViewControllers?[currentIndex - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let viewController = pageViewController.viewControllers?.first as? BookPageViewController
        comicMetadata?.openPage = Int16(viewController?.index ?? 0)
    }
    
}

extension BookViewController: BookViewDismissProtocol {
    
    func dismissPageView() {
        
        ComicManager.saveCDStack()
        dismiss(animated: true) {
            self.comicMetadata = nil
            self.book = nil
            self.bookViewControllers = nil
        }
    }
}

extension BookViewController: skipPageManagment {
    
    func skipTo(page: Int) {
        openTo(page: page, in: bookViewControllers ?? [])
    }
    
}

protocol BookViewDismissProtocol {
    
    func dismissPageView()
}
