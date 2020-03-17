//
//  StoreListViewController.swift
//  maskeyes
//
//  Created by SEUNGWON YANG on 2020/03/13.
//  Copyright © 2020 co.giftree. All rights reserved.
//

import UIKit

class StoreListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var items:[Store] = []
    
    var delegate:MoveCameraDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        
        tableView.reloadData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false  //Hide
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true  //Show
    }
    
    func setStoreItems(stores:[Store]){
        let temps = stores.sorted(by: { $0.distance ?? 0 < $1.distance ?? 0 })
        
        for store in temps {
            items.append(store)
        }
               
    }
    
    class func create() -> StoreListViewController {
           let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
           return mainStoryboard.instantiateViewController(withIdentifier: String(describing: self)) as! StoreListViewController
       }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func showToast(message : String) {

          let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-100, width: 180, height: 35))
          toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
          toastLabel.textColor = UIColor.white
          toastLabel.textAlignment = .center
          toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
          toastLabel.text = message
          toastLabel.alpha = 1.0
          toastLabel.layer.cornerRadius = 10
          toastLabel.clipsToBounds  =  true
          self.view.addSubview(toastLabel)
          UIView.animate(withDuration: 1.0, delay: 0.6, options: .curveEaseOut, animations: {
              toastLabel.alpha = 0.0
          }, completion: {(isCompleted) in
              toastLabel.removeFromSuperview()
          })
      }
}


extension StoreListViewController :  UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StoreTableViewCell", for: indexPath) as! StoreTableViewCell
        
        
        let item = items[indexPath.row]
        
        
        cell.typeIcon.image = DataHelper.typeIcon(type: item.type)
        
        cell.nameLabel.text = item.name
        cell.remainStatLabel.textColor = DataHelper.convertColorRemainStat(stat: item.remain_stat)
        cell.remainStatLabel.text = "마스크 : \(DataHelper.convertReadableRemainStat(stat: item.remain_stat))"
        cell.addressLabel.text =  item.addr
        cell.stockAtLabel.text = item.stock_at == "" ? "입고시간 없음" : "입고시간 : \(item.stock_at)"
        if let dis = item.distance, let disStr = item.disStr {
            if dis > 10000 {
                cell.distanceLabel.isHidden = true
            }else{
                cell.distanceLabel.isHidden = false
                
                cell.distanceLabel.text = "현재 위치와의 거리 : \(disStr)"
            }
        }else{
           cell.distanceLabel.isHidden = true
        }
        cell.addressButton.tag = indexPath.row
        cell.addressButton.addTarget(self, action: #selector(copyAddress), for: .touchUpInside)

        cell.moveToLocationButton.tag = indexPath.row
           cell.moveToLocationButton.addTarget(self, action: #selector(moveLocation), for: .touchUpInside)
        
        return cell
    }
    
    @objc func copyAddress(sender: UIButton){
       
        let index = sender.tag
        let item = items[index]
        
        UIPasteboard.general.string = item.addr

              
             
        showToast(message: "주소를 복사했습니다.")
    }
    
    @objc func moveLocation(sender: UIButton){
           let index = sender.tag
           let item = items[index]
        
        if let delegate = self.delegate{
            delegate.moveToPosition(x: Double(item.lat), y: Double(item.lng))
            
            navigationController?.popViewController(animated: true)
        }
       
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let item = items[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
      
    }
}
