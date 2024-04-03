//
//  BleViewController.swift
//  API_Calls
//
//  Created by Nandini B on 19/03/24.
//

import UIKit
import CoreBluetooth

class BleViewController: NSObject, CBCentralManagerDelegate,  CBPeripheralDelegate{

    var centralManager: CBCentralManager!
    var discoveredPeripheral: CBPeripheral?
    
    override init() {
           super.init()
           centralManager = CBCentralManager(delegate: self, queue: nil)
       }
    
    // MARK: CBCentralManagerDelegate Methods
    
    //checks weather the ble is on/ off
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        print(central.state)
        switch central.state {
          case .poweredOn:
              // If powered on -> scan for peripherals
              centralManager.scanForPeripherals(withServices: nil, options: nil)
              print("Scanning for peripherals...")
          case .poweredOff:
              print("Bluetooth is powered off.")
          case .resetting:
              print("Bluetooth is resetting.")
          case .unauthorized:
              print("Bluetooth is unauthorized.")
          case .unknown:
              print("Bluetooth state is unknown.")
          case .unsupported:
              print("Bluetooth is unsupported.")
          @unknown default:
              print("Unknown Bluetooth state.")
          }
    }
    
    //we discover the peripherals and connect to the peripherals
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        // Print discovered peripheral information
        print("Discovered Peripheral: \(peripheral)")
        print("Advertisement Data: \(advertisementData)")
        print("RSSI: \(RSSI)")
        
        centralManager.stopScan()
        //connect
        centralManager.connect(peripheral, options: nil)
        
    }
    
    //once connection is established discover services of the peripheral
    
    //Services :  functionalities of the devices
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
           centralManager.stopScan()
           print("Connected to peripheral: \(peripheral)")

           peripheral.delegate = self
           peripheral.discoverServices(nil) // we discover all the services that the peripheral offers. passing nil  means -> discover all the services
       }

    // MARK: - CBPeripheralDelegate methods
    // once servives are discoverd we discover the characterstics of each service.
    //characterstics : data [ this data we can read, write, notify, indicate, broadcast ]

    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
           if let error = error {
               print("Error discovering services: \(error.localizedDescription)")
               return
           }
           
           guard let services = peripheral.services else {
               return
           }

           for service in services {
               print("Discovered Service: \(service)")
               peripheral.discoverCharacteristics(nil, for: service)
           }
       }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
            if let error = error {
                print("Error discovering characteristics for service \(service): \(error.localizedDescription)")
                return
            }

            guard let characteristics = service.characteristics else {
                return
            }

            for characteristic in characteristics {
                print("Discovered Characteristic: \(characteristic)")

                // Enable notifications/indications for this characteristic
                
                // Iterate through discovered characteristics
                        for characteristic in characteristics {
                            // Check characteristic properties and handle accordingly
                            if characteristic.properties.contains(.read) {
                                // Read value from characteristic
                                peripheral.readValue(for: characteristic)
                            }

                            if characteristic.properties.contains(.notify) {
                                // Enable notifications for characteristic
                                peripheral.setNotifyValue(true, for: characteristic)
                            }

                            if characteristic.properties.contains(.write) {
                                // Write value to characteristic (example: turning on LED)
                                // Note: Actual implementation may require specific data format
                                let dataToSend = Data([0x01]) // Example data
                                peripheral.writeValue(dataToSend, for: characteristic, type: .withResponse)
                            }

                            if characteristic.properties.contains(.indicate) {
                                // Enable indications for characteristic
                                peripheral.setNotifyValue(true, for: characteristic)
                            }
                        }

//                if characteristic.properties.contains(.notify) || characteristic.properties.contains(.indicate) {
//                    peripheral.setNotifyValue(true, for: characteristic)
//                }
            }
        }
    
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
          if let error = error {
              print("Error updating value for characteristic \(characteristic): \(error.localizedDescription)")
              return
          }

          if let value = characteristic.value {
              print("Updated Value for Characteristic \(characteristic): \(value)")
          }
      }
}
