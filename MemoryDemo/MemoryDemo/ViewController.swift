//
//  ViewController.swift
//  MemoryDemo
//
//  Created by 🦁️ on 15/12/3.
//  Copyright © 2015年 exialym. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var imagesContainer: UIScrollView!
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imagesContainer.delegate = self
        let pageCount = 10000
        self.updatePages()
//        for i in 1...pageCount {
//            self.loadPageWithNumber(i)
//        }
        var contentSize = CGSize()
        contentSize.height = self.imagesContainer.bounds.size.height
        contentSize.width = self.imagesContainer.bounds.size.width * CGFloat(pageCount)
        self.imagesContainer.contentSize = contentSize
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func updatePages(){
        let pageNumber = Int(imagesContainer.contentOffset.x / imagesContainer.bounds.size.width + 1)
        self.loadPageWithNumber(pageNumber - 1)
        self.loadPageWithNumber(pageNumber)
        self.loadPageWithNumber(pageNumber + 1)
        for imageView in imagesContainer.subviews {
            if imageView.tag < pageNumber - 1 || imageView.tag > pageNumber + 1 {
                imageView.removeFromSuperview()
            }
        }
    }
    func scrollViewDidScroll(scrollView: UIScrollView) {
        self.updatePages()
    }
    func loadPageWithNumber(number: NSInteger){
        if self.imagesContainer.viewWithTag(number) != nil {
            return
        }
        let image = self.imageWithNumber(number)
        let imageView = UIImageView(image: image)
        var imageViewFrame = self.imagesContainer.bounds
        imageViewFrame.origin.x = imageViewFrame.size.width * CGFloat(number - 1)
        imageView.frame = imageViewFrame
        
        self.imagesContainer.addSubview(imageView)
        
        imageView.tag = number
    }
    func imageWithNumber(number: Int) -> UIImage{
        var imageRect = self.imagesContainer.frame
        imageRect.insetInPlace(dx: 20, dy: 20)
        UIGraphicsBeginImageContext(imageRect.size)
        let path = UIBezierPath(roundedRect: imageRect, cornerRadius: 10)
        path.lineWidth = 20
        UIColor.darkGrayColor().setStroke()
        UIColor.lightGrayColor().setFill()
        path.fill()
        path.stroke()
        
        let label = "\(number)"
        let font = UIFont.systemFontOfSize(50)
        let labelPoint = CGPoint(x: 50, y: 50)
        UIColor.whiteColor().setFill()
        let labelAttributes = [NSFontAttributeName:font]
        label.drawAtPoint(labelPoint, withAttributes: labelAttributes)
        let returnedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return returnedImage
    }

}

