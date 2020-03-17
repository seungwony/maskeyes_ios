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
enum KakaoRouter: URLRequestConvertible {
    case searchAddress(query:String)
 
    
    var method: HTTPMethod {
         switch self {
         case .searchAddress:
            return .get
 
     
        }
    }
      
      

      func asURLRequest() throws -> URLRequest {
          let result: (path: String, parameters: Parameters) = {
              switch self {
                
              case let .searchAddress(query) :
                return ("/v2/local/search/address.json", ["query":query])
            

            }
                           
           }()
           
           let url = try ApiManager.REST_SERVER_URL_KAKAO.asURL()
           let urlRequest = try! URLRequest(url: url.appendingPathComponent(result.path), method : method,  headers: ApiManager.getKakaoHeader())
           return try URLEncoding.default.encode(urlRequest, with: result.parameters)
       }
}
