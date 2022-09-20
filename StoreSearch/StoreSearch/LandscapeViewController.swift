//
//  LandscapeViewController.swift
//  StoreSearch
//
//  Created by Olexsii Levchenko on 9/20/22.
//

import UIKit

class LandscapeViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var searchResults = [SearchResult]()
    
    private var firstTime = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Remove constraints from main view
        view.removeConstraints(view.constraints)
        view.translatesAutoresizingMaskIntoConstraints = true
        
        //Remove constraints for page control
        pageControl.removeConstraints(pageControl.constraints)
        pageControl.translatesAutoresizingMaskIntoConstraints = true
        
        // Remove constraints for scroll view
        scrollView.removeConstraints(pageControl.constraints)
        scrollView.translatesAutoresizingMaskIntoConstraints = true
        
        scrollView.backgroundColor = .systemYellow
        
        view.backgroundColor = UIColor(patternImage: UIImage(named: "LandscapeBackground")!)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let safeFrame = view.safeAreaLayoutGuide.layoutFrame
        scrollView.frame = safeFrame
        pageControl.frame = CGRect(x: safeFrame.origin.x, y: safeFrame.size.height - pageControl.frame.height, width: safeFrame.size.width, height: pageControl.frame.size.height)
        
        if firstTime {
            firstTime = false
            tileButton(searchResults)
        }
    }
   
    
    private func tileButton(_ searchResults: [SearchResult]) {
        let itemWidth: CGFloat = 94
        let itemHeight: CGFloat = 88
        var columnsPerPage = 0
        var rowsPerPage = 0
        var marginX: CGFloat = 0
        var marginY: CGFloat = 0
        let viewWidth = scrollView.bounds.size.width
        let viewHeight = scrollView.bounds.size.height
        
        columnsPerPage = Int(viewWidth / itemWidth)
        rowsPerPage = Int(viewHeight / itemHeight)
        
        marginX = (viewWidth - (CGFloat(columnsPerPage) * itemWidth)) * 0.5
        marginY = (viewHeight - (CGFloat(rowsPerPage) * itemHeight)) * 0.5
        
        //Button Size
        let buttonWidth: CGFloat = 82
        let buttonHeight: CGFloat = 82
        let paddingHorz = (itemWidth - buttonWidth) / 2
        let paddingVert = (itemHeight - buttonHeight) / 2
        
        //Add the button
        var row = 0
        var colum = 0
        var x = marginX
        for (index, result) in searchResults.enumerated() {
            let button = UIButton(type: .system)
            button.backgroundColor = .white
            button.setTitle("\(index)", for: .normal)
            
            button.frame = CGRect(x: x + paddingHorz, y: marginY + CGFloat(row) * itemHeight + paddingVert, width: buttonWidth, height: buttonHeight)
            
            scrollView.addSubview(button)
            
            row += 1
             
            if row == rowsPerPage {
                row = 0; x += itemWidth; colum += 1
                if colum == columnsPerPage {
                    colum = 0; x += marginX * 2
                }
            }
        }
        
        // Set scroll view content size
        let buttonsPerPage = columnsPerPage * rowsPerPage
        let numPeges = 1 + (searchResults.count - 1) / buttonsPerPage
        scrollView.contentSize = CGSize(width: CGFloat(numPeges) * viewWidth, height: scrollView.bounds.size.height)
    }
}
