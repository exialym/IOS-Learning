//
//  myGPS.swift
//  Trax
//
//  Created by exialym on 15/8/30.
//  Copyright (c) 2015年 exialym. All rights reserved.
//

import MapKit
class myGPS: NSObject, MKAnnotation{
    //var mainView = ViewController()
    
    
    
    var coordinate: CLLocationCoordinate2D
        {
        didSet{
            save()
        }
    }
    var title: String?
    var subtitle: String?
    var bigImageURL: NSURL?//= NSURL(string: "http://farm1.staticflickr.com/315/20118461406_da4008efa0_c.jpg")
    var smallImageURL: NSURL?//= NSURL(string: "http://farm1.staticflickr.com/493/19958043869_9275b9fa50_c.jpg")
    var name: String
    var path: String = ""
    init(coorX: Double, coorY: Double, initTitle: String, initSubtitle: String, url: NSURL?, initName: String){
        coordinate = CLLocationCoordinate2D(latitude: coorX, longitude: coorY)
        title = initTitle
        subtitle = initSubtitle
        bigImageURL = url
        smallImageURL = url
        name = initName
    }
    func save() {
        let mainView = ViewController()
        mainView.savePoints.updateValue(mainView.change(self), forKey: name)
    }
}
class EditablePoint: myGPS {
    
}
