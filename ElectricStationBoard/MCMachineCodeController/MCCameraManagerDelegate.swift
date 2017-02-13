//
//  MCCameraManagerDelegate.swift
//  MCMachineCodeDemo
//
//  Created by 马超 on 16/5/26.
//  Copyright © 2016年 qq 714080794. All rights reserved.
//

import UIKit

protocol MCCameraManagerDelegate : NSObjectProtocol {
    
    func deviceConfigurationFailedWithError(_ error: NSError?)
    func mediaCaptureFailedWithError(_ error: NSError?)
    func assetLibraryWriteFailedWithError(_ error: NSError?)
   
}
