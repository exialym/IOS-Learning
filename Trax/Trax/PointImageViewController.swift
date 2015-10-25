//
//  PointImageViewController.swift
//  Trax
//
//  Created by exialym on 15/9/1.
//  Copyright (c) 2015年 exialym. All rights reserved.
//

import UIKit

class PointImageViewController: ImageViewController {

    var GPSPoint: myGPS? {
        didSet {
            imageURL = GPSPoint?.bigImageURL
            title = GPSPoint?.title
            updateEmbeddedMap()
        }
    }
    
    func updateEmbeddedMap() {
        if let mapView = smvc?.mapView {
            mapView.mapType = .Hybrid
            mapView.removeAnnotations(mapView.annotations)
            mapView.addAnnotation(GPSPoint!)
            mapView.showAnnotations(mapView.annotations, animated: true)
        }
    }
    
    var smvc: SimpleMapViewController?
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Embed Map" {
            smvc = segue.destinationViewController as? SimpleMapViewController
        }
    }

}
