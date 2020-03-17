//
//  SearchAddressViewController.swift
//  maskeyes
//
//  Created by SEUNGWON YANG on 2020/03/13.
//  Copyright © 2020 co.giftree. All rights reserved.
//
import Alamofire
import SwiftyJSON
import UIKit

class SearchAddressViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var items:[AddressInfo] = []
    var delegate: MoveCameraDelegate?
    
    @IBOutlet weak var addressTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
         tableView.delegate = self
         tableView.dataSource = self
             tableView.tableFooterView = UIView()
//        tableView.tableFooterView = UIView()
        // Do any additional setup after loading the view.
        addressTextField.becomeFirstResponder()
        
        
    }
    

    @IBAction func onClickBackButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onEditingChanged(_ sender: UITextField) {
        debugPrint(sender.text!)
        let address = sender.text!
        searchAddress(address: address)
    }
    
    
    class func create() -> SearchAddressViewController {
           let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
           return mainStoryboard.instantiateViewController(withIdentifier: String(describing: self)) as! SearchAddressViewController
       }
       
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
    func searchAddress(address:String){
                
        
        Alamofire.request(KakaoRouter.searchAddress(query: address))
                       .responseJSON { response in
                           
                           
                           
                       switch response.result {
                       case .success:
                        
                            var tmpAddress : [AddressInfo] = []
                            
                           if let data = response.result.value as? [String: Any] {
                               
                               let json = JSON(data)
                        debugPrint(json.debugDescription)
                               if let documents = json["documents"].array {

                              
                                
                                
                                    for document in documents{

                                    
                                        let address_name = document["address_name"].easyString
                                        let x = document["x"].easyStringNumber
                                        let y = document["y"].easyStringNumber
                                     
                                        
                                        
                                        
                                        let address = AddressInfo(lat: Double(y) ?? 0.0, lng: Double(x) ?? 0.0, address: address_name)
                                        
                                     
                                        tmpAddress.append(address)
                                        
        //                                        self.items.append(filterPack)
                                      
                                        
                                    }
                                
                                
                                
                                
                               
                                }
                            
                            self.items.removeAll()
                            for ad in tmpAddress{
                                self.items.append(ad)
                            }
                            
                            self.tableView.reloadData()
                            
                            
                           }
                           
                        break
                                           
                                       
                       case .failure(let error):
                                           
                        print("error : \(error)")
                        self.items.removeAll()
                                                   
                        self.tableView.reloadData()
                        
                                       
                    }
                }
            }
    
    
}


extension SearchAddressViewController :  UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddressTableViewCell", for: indexPath) as! AddressTableViewCell
        
        
        let item = items[indexPath.row]
        
        
        cell.addressLabel.text = item.address
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let delegate = self.delegate{
            delegate.moveToPosition(x: item.lat, y: item.lng)
            
            navigationController?.popViewController(animated: true)
        }
      
    }
    
    
    
}

