//
//  ApiManager.swift
//  maskeyes
//
//  Created by SEUNGWON YANG on 2020/03/12.
//  Copyright © 2020 co.giftree. All rights reserved.
//


import Alamofire

class ApiManager {
    
 
    
    static let REST_SERVER_URL = "https://8oi9s0nnth.apigw.ntruss.com"
    
    static let REST_SERVER_URL_KAKAO = "https://dapi.kakao.com"
    
    public static func getHeader() -> HTTPHeaders{
        let headers: HTTPHeaders = [
                     "Content-Type": "application/x-www-form-urlencoded"
                 ]
                 
         
        return headers
        
    }
    
   
    public static func getKakaoHeader() -> HTTPHeaders{
          let headers: HTTPHeaders = [
             "Authorization": "KakaoAK 0fede97417a99808a41a466fc84a9bbe",
             "Content-Type": "application/x-www-form-urlencoded"
        ]
        return headers
     }
}
