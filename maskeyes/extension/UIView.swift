//
//  UIView.swift
//  lutcamera
//
//  Created by SEUNGWON YANG on 2019/11/12.
//  Copyright © 2019 co.giftree. All rights reserved.
//

import UIKit

extension UIView{
  
     func startRotating(duration: CFTimeInterval = 3, repeatCount: Float = Float.infinity, clockwise: Bool = true) {

         if self.layer.animation(forKey: "transform.rotation.z") != nil {
             return
         }

         let animation = CABasicAnimation(keyPath: "transform.rotation.z")
         let direction = clockwise ? 1.0 : -1.0
         animation.toValue = NSNumber(value: .pi * 2 * direction)
         animation.duration = duration
         animation.isCumulative = true
         animation.repeatCount = repeatCount
         self.layer.add(animation, forKey:"transform.rotation.z")
     }

     func stopRotating() {

         self.layer.removeAnimation(forKey: "transform.rotation.z")

     }

    func relativeHeight(ratio:String, fullHeight:CGFloat = UIScreen.main.bounds.height) -> CGFloat {
        let width = self.bounds.width
        
        if ratio != "full"{
           let arr = ratio.components(separatedBy: ":")
           let wdthRto = CGFloat(Double(arr[0]) ?? 0)
           let hghtRto = CGFloat(Double(arr[1]) ?? 0)
       
            
            debugPrint("ratio : \(ratio) cal : \(((width * hghtRto) / wdthRto)) wdthRto :\(wdthRto)  hghtRto:\(hghtRto)")
       
           return ((width * hghtRto) / wdthRto)
        }else{
            return fullHeight
        }
        
       
    }
    
    @IBInspectable var cornerRadius: CGFloat {

      get{
           return layer.cornerRadius
       }
       set {
           layer.cornerRadius = newValue
           layer.masksToBounds = newValue > 0
       }
     }

     @IBInspectable var borderWidth: CGFloat {
       get {
           return layer.borderWidth
       }
       set {
           layer.borderWidth = newValue
       }
     }

     @IBInspectable var borderColor: UIColor? {
       get {
           return UIColor(cgColor: layer.borderColor!)
       }
       set {
           layer.borderColor = borderColor?.cgColor
       }
     }
    
    func topRounded(){
         let maskPath1 = UIBezierPath(roundedRect: bounds,
                                      byRoundingCorners: [.topLeft , .topRight],
             cornerRadii: CGSize(width: 20, height: 20))
         let maskLayer1 = CAShapeLayer()
         maskLayer1.frame = bounds
         maskLayer1.path = maskPath1.cgPath
        layer.masksToBounds = true
         layer.mask = maskLayer1
     }
    
    
    func applyGradient(withColors colors: [UIColor]) {
           if let sublayers = layer.sublayers {
               let _ = sublayers.filter({ $0 is CAGradientLayer }).map({ $0.removeFromSuperlayer() })
           }
           
           let gradientLayer = CAGradientLayer()
           gradientLayer.colors = colors.map({ $0.cgColor })
           
           backgroundColor = .clear
           gradientLayer.frame = bounds
           layer.insertSublayer(gradientLayer, at: 0)
       }
       
       func applyScale(_ scale: CGFloat) {
           layer.transform = CATransform3DScale(CATransform3DIdentity, scale, scale, 1.0)
       }
       
       class func fromNib<T: UIView>() -> T {
           return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)?.first as! T
       }
}
