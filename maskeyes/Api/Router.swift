//
//  Router.swift
//  maskeyes
//
//  Created by SEUNGWON YANG on 2020/03/12.
//  Copyright © 2020 co.giftree. All rights reserved.
//


import Foundation
import UIKit
import Alamofire
enum Router: URLRequestConvertible {
    case storesByGeo(lat:Double, lng:Double, m:Int)
 
    
    var method: HTTPMethod {
         switch self {
         case .storesByGeo:
            return .get
 
     
        }
    }
      
      

      func asURLRequest() throws -> URLRequest {
          let result: (path: String, parameters: Parameters) = {
              switch self {
                
              case let .storesByGeo(lat, lng, m) :
                return ("/corona19-masks/v1/storesByGeo/json", ["lat":lat, "lng":lng, "m":m])
            

            }
                           
           }()
           
           let url = try ApiManager.REST_SERVER_URL.asURL()
           let urlRequest = try! URLRequest(url: url.appendingPathComponent(result.path), method : method,  headers: ApiManager.getHeader())
           
           
           return try URLEncoding.default.encode(urlRequest, with: result.parameters)
       }
}
