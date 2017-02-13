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
    
    @IBAction func searchDevice(_ sender: UIButton) {
        //centralManager?.scanForPeripheralsWithServices(nil, options: nil)
        performSegue(withIdentifier: "showDraw", sender: "繁")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    // MARK: -BluetoothCentralManager
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case CBManagerState.poweredOn:
            print("蓝牙打开啦")
            centralManager?.scanForPeripherals(withServices: nil, options: nil)
        case CBManagerState.unauthorized:
            print("没有授权")
        case CBManagerState.unsupported:
            print("不支持")
        case CBManagerState.poweredOff:
            print("把蓝牙打开了啦")
        default:
            print("meximexi")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if !deviceList.contains(peripheral) {
            deviceList.append(peripheral)
        }
        deviceTable.reloadData()
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        centralManager?.stopScan()
        self.peripheral = peripheral
        self.peripheral?.delegate = self
        self.peripheral?.discoverServices(nil)
        print("连接成功")
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("连接失败＝＝＝\(error)")
    }
    
    // MARK: -BluetoothPeripheral
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if error != nil {
            print("发现服务出现错误")
            return
        }
        for service in peripheral.services! {
            print("服务的UUID\(service.uuid)")
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if error != nil {
            print("发现错误特征")
            return
        }
        for characteristic in service.characteristics! {
            print("特征的UUID:\(characteristic.uuid)")
            switch characteristic.uuid.description {
            case "Manufacturer Name String": fallthrough
            case "Battery Level":fallthrough
            case "Model Number String":fallthrough
            case "System ID":fallthrough
            case "Hardware Revision String":fallthrough
            case "Software Revision String":fallthrough
            case "Firmware Revision String":fallthrough
            case "Serial Number String":fallthrough
            case "PnP ID":
                self.peripheral?.readValue(for: characteristic)
            //case "FEC8":fallthrough
            //case "FFF2":fallthrough
            //case "FFF1":fallthrough
            //case "FEC7":
            case "FFE1":
                writeCharacteristic = characteristic
                performSegue(withIdentifier: "showDraw", sender: "繁")
            default:break
            }
            
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if error != nil {
            print("接收特征发来的数据错误，特征UUID：\(characteristic.uuid),错误数据：\(characteristic.value),错误：\(error?.localizedDescription)")
            return
        }
        if let value = characteristic.value {
            if let stringValue = NSString(data: value, encoding: String.Encoding.utf8.rawValue) {
                print("\(characteristic.uuid.description):\(stringValue)")
            }
        }
    }
    
    //用于检测中心向外设写数据是否成功
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        if(error != nil){
            print("发送数据失败!error信息:\(error)")
        }else{
            print("发送数据成功\(characteristic)")
        }
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return deviceList.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Equipment", for: indexPath) as! EquipmentTableViewCell
        let device = deviceList[(indexPath as NSIndexPath).row]
        // Configure the cell...
        cell.name.text = device.name
        cell.info.text = device.identifier.uuidString
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        centralManager?.connect(deviceList[(indexPath as NSIndexPath).row], options: nil)
        //performSegueWithIdentifier("showDraw", sender: indexPath.row)
        print("连接\(deviceList[(indexPath as NSIndexPath).row].name)")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier! {
        case "showDraw":
            if let destination = segue.destination as? DrawViewController {
                if let data = sender as? String {
                    destination.data = data
                    destination.connectedDevice = self.peripheral
                    destination.centralManager = self.centralManager
                    destination.writeCharacterisitic = self.writeCharacteristic
                }
        }
        default:break
        }
    }
}

