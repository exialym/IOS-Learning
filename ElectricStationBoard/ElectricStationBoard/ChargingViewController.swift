//
//  ChargingViewController.swift
//  ElectricStationBoard
//
//  Created by Galaxy on 16/5/13.
//  Copyright © 2016年 Iris. All rights reserved.
//

import UIKit
import Foundation
import AVFoundation



class ChargingViewController: UIViewController{
    
    

        
        override func viewDidLoad() {
        super.viewDidLoad()
        
        
    
        
        

        
    }
    
 //点击按钮进行扫描
    @IBAction func scanAction(sender: AnyObject) {
        
        let machineCodeVc = MCMachineCodeViewController(lineType: LineType.LineScan, moveType: MoveType.Default)
        self.navigationController?.pushViewController(machineCodeVc, animated: true)
        
        machineCodeVc.didGetMachineCode = { code in
            
            //self.resultLabel.text = code
            let vc = InChargingViewController();
            self.navigationController?.pushViewController(vc, animated: true);
            
        }

        

        
        
    }
    
   
    
    
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
