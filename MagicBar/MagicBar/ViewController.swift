//
//  ViewController.swift
//  MagicBar
//
//  Created by 🦁️ on 16/3/30.
//  Copyright © 2016年 exialym. All rights reserved.
//

import UIKit
import CoreBluetooth
class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,CBCentralManagerDelegate,CBPeripheralDelegate {

    @IBOutlet weak var deviceTable: UITableView!
    var centralManager:CBCentralManager?
    var peripheral:CBPeripheral?
    var deviceList = [CBPeripheral]()
    var writeCharacteristic:CBCharacteristic?
    
    @IBAction func searchDevice(sender: UIButton) {
        //centralManager?.scanForPeripheralsWithServices(nil, options: nil)
        performSegueWithIdentifier("showDraw", sender: "繁")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    // MARK: -BluetoothCentralManager
    
    func centralManagerDidUpdateState(central: CBCentralManager) {
        switch central.state {
        case CBCentralManagerState.PoweredOn:
            print("蓝牙打开啦")
            centralManager?.scanForPeripheralsWithServices(nil, options: nil)
        case CBCentralManagerState.Unauthorized:
            print("没有授权")
        case CBCentralManagerState.Unsupported:
            print("不支持")
        case CBCentralManagerState.PoweredOff:
            print("把蓝牙打开了啦")
        default:
            print("meximexi")
        }
    }
    
    func centralManager(central: CBCentralManager, didDiscoverPeripheral peripheral: CBPeripheral, advertisementData: [String : AnyObject], RSSI: NSNumber) {
        if !deviceList.contains(peripheral) {
            deviceList.append(peripheral)
        }
        deviceTable.reloadData()
    }
    
    func centralManager(central: CBCentralManager, didConnectPeripheral peripheral: CBPeripheral) {
        centralManager?.stopScan()
        self.peripheral = peripheral
        self.peripheral?.delegate = self
        self.peripheral?.discoverServices(nil)
        print("连接成功")
    }
    
    func centralManager(central: CBCentralManager, didFailToConnectPeripheral peripheral: CBPeripheral, error: NSError?) {
        print("连接失败＝＝＝\(error)")
    }
    
    // MARK: -BluetoothPeripheral
    
    func peripheral(peripheral: CBPeripheral, didDiscoverServices error: NSError?) {
        if error != nil {
            print("发现服务出现错误")
            return
        }
        for service in peripheral.services! {
            print("服务的UUID\(service.UUID)")
            peripheral.discoverCharacteristics(nil, forService: service)
        }
    }
    
    func peripheral(peripheral: CBPeripheral, didDiscoverCharacteristicsForService service: CBService, error: NSError?) {
        if error != nil {
            print("发现错误特征")
            return
        }
        for characteristic in service.characteristics! {
            print("特征的UUID:\(characteristic.UUID)")
            switch characteristic.UUID.description {
            case "Manufacturer Name String": fallthrough
            case "Battery Level":fallthrough
            case "Model Number String":fallthrough
            case "System ID":fallthrough
            case "Hardware Revision String":fallthrough
            case "Software Revision String":fallthrough
            case "Firmware Revision String":fallthrough
            case "Serial Number String":fallthrough
            case "PnP ID":
                self.peripheral?.readValueForCharacteristic(characteristic)
            //case "FEC8":fallthrough
            //case "FFF2":fallthrough
            //case "FFF1":fallthrough
            //case "FEC7":
            case "FFE1":
                writeCharacteristic = characteristic
                performSegueWithIdentifier("showDraw", sender: "繁")
            default:break
            }
            
        }
    }
    
    func peripheral(peripheral: CBPeripheral, didUpdateValueForCharacteristic characteristic: CBCharacteristic, error: NSError?) {
        if error != nil {
            print("接收特征发来的数据错误，特征UUID：\(characteristic.UUID),错误数据：\(characteristic.value),错误：\(error?.localizedDescription)")
            return
        }
        if let value = characteristic.value {
            if let stringValue = NSString(data: value, encoding: NSUTF8StringEncoding) {
                print("\(characteristic.UUID.description):\(stringValue)")
            }
        }
    }
    
    //用于检测中心向外设写数据是否成功
    func peripheral(peripheral: CBPeripheral, didWriteValueForCharacteristic characteristic: CBCharacteristic, error: NSError?) {
        if(error != nil){
            print("发送数据失败!error信息:\(error)")
        }else{
            print("发送数据成功\(characteristic)")
        }
    }
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return deviceList.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Equipment", forIndexPath: indexPath) as! EquipmentTableViewCell
        let device = deviceList[indexPath.row]
        // Configure the cell...
        cell.name.text = device.name
        cell.info.text = device.identifier.UUIDString
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        centralManager?.connectPeripheral(deviceList[indexPath.row], options: nil)
        //performSegueWithIdentifier("showDraw", sender: indexPath.row)
        print("连接\(deviceList[indexPath.row].name)")
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segue.identifier! {
        case "showDraw":
            if let destination = segue.destinationViewController as? DrawViewController {
                if let data = sender as? String {
                    destination.data = data
                    destination.connectedDevice = self.peripheral
                    destination.writeCharacterisitic = self.writeCharacteristic
                }
        }
        default:break
        }
    }
}

