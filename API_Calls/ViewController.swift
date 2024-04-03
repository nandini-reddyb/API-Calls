//
//  ViewController.swift
//  API_Calls
//
//  Created by Nandini B on 19/03/24.
//

import UIKit

class ViewController: UIViewController {
    var bluetoothManager: BleViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bluetoothManager = BleViewController()
    //     getListOfData()
    }

    func getListOfData() {
        let apiString = "https://reqres.in/api/users?page=2"
    
        guard let listUrl = URL(string: apiString) else {
            return
        }
        
        //create a url request
        let urlRequest = URLRequest(url: listUrl)
        
        //give url request to the data task , this data task contains 3 params in completion handler
        URLSession.shared.dataTask(with: urlRequest) { responseData, urlResponse, apiError in
            print(responseData ?? "responseData" , urlResponse ?? "urlResponse" , apiError ?? "error")
            
            if let error = apiError {
                print("API Error:", apiError ?? "error")
            } else {
                guard let apiResponse = urlResponse as? HTTPURLResponse else {
                    return
                }
                
                if apiResponse.statusCode == 200 {
                    
                    guard let responseData = responseData else {
                        return
                    }
                    
                    //convert data (in bytes) to english -> decoding
                    let decoder = JSONDecoder()
                    
                    do {
                        let decodeData = try decoder.decode(userListModel.self, from: responseData )
                        print("decoded data : ", decodeData)
                    } catch {
                        print("Erro", apiError ?? "error")
                    }
                    
                }
            }
            
        }.resume()
    }
}

