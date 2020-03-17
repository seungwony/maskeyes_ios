//
//  WebViewWithButtonViewController.swift
//  maskeyes
//
//  Created by SEUNGWON YANG on 2020/03/11.
//  Copyright © 2020 co.giftree. All rights reserved.
//

import UIKit
import WebKit
import PopupDialog

class WebViewWithButtonViewController: UIViewController  , WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler {

    @IBOutlet weak var cofirmButton: UIButton!
    
    var url:String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let webView = WKWebView(frame: CGRect( x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height ), configuration: WKWebViewConfiguration() )
        //        let webView = WKWebView(frame: CGRect( x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height - 64 ), configuration: WKWebViewConfiguration() )
                webView.translatesAutoresizingMaskIntoConstraints = false
        //
                self.view.addSubview(webView)
        //
        //        webView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 64).isActive = true
                webView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
                webView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
                webView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
                webView.bottomAnchor.constraint(equalTo: cofirmButton.topAnchor).isActive = true
        //
                
                
                if let url = self.url, let notice_url = URL (string: url){
                    
                    debugPrint("load \(url)")
                    
                    let url_req = URLRequest(url: notice_url)
                    webView.load(url_req)
                }
    }


    class func create() -> WebViewWithButtonViewController {
          let webViewController = WebViewWithButtonViewController(nibName: "WebViewWithButtonViewController", bundle: nil)
          return webViewController
      }
      
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
           print("didFinish")
       }
       
       func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
           print(error)
       }
    
    
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let otherAction = UIAlertAction(title: "OK", style: .default) { (action) in
            
        }
        alert.addAction(otherAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print(error)
    }
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
    }
    
    
    
    @IBAction func onClickConfirm(_ sender: Any) {
     
        
        dismiss()
//        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    func dismiss(){
        if Constants.initialUser {
          self.showGuidePopup()
          let defaults = UserDefaults.standard
          defaults.set(false, forKey:"initialUser")
          defaults.synchronize()
        }else{
           self.dismiss(animated: true, completion: nil)
        }
    }
    
    fileprivate func showGuidePopup(){
          
          let popupVC = GuideViewController(nibName: "GuideViewController", bundle: nil)
          
          // Create the dialog
          let popup = PopupDialog(viewController: popupVC,
                                  buttonAlignment: .vertical,
                                  transitionStyle: .bounceDown,
                                  tapGestureDismissal: true,
                                  panGestureDismissal: false)
          
       
          // Create second button
          let confirmButton = DefaultButton(title: "확인") {
            
            
              self.dismiss(animated: true, completion: nil)
          }
          
          // Add buttons to dialog
          popup.addButtons([confirmButton])
        
        
          
          
          
          // Present dialog
          present(popup, animated: true, completion: nil)
      }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
