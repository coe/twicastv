//
//  TwicasApi.swift
//  watchube
//
//  Created by COFFEE on 2016/12/31.
//  Copyright © 2016年 tsuyoshi hyuga. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

let TWICAS_HOST = "apiv2.twitcasting.tv"
let YOUR_CLINET_ID = "YOUR_CLINET_ID"
let YOUR_TWICAS_CLIENT_SECRET = "YOUR_TWICAS_CLIENT_SECRET"

typealias access_tokenResponse = (AccessTokenResponse?,URLResponse?, NSError?) -> Void

struct AccessTokenResponse {
    let token_type:String
    let expires_in:Int
    let access_token:String
}

struct UserObject {
    let id:String
    let screen_id:String
    let name:String
    let image:String
    let profile:String
    let last_movie_id:String?
    let is_live:Bool
    let created:Int

}

struct TwicasMovie {
    let id:String
    let user_id:String
    let title:String
    let subtitle:String
    let link:String
    let is_live:Bool
    let is_recorded:Bool
    let comment_count:Int
    let large_thumbnail:String
    let small_thumbnail:String
    let country:String
    let duration:Int
    let created:Int
    let is_collabo:Bool
    let is_protected:Bool
    let max_view_count:Int
    let current_view_count:Int
    let total_view_count:Int
    let hls_url:String
}

class TwicasApi: NSObject {
    

    static func access_token(code:String,grant_type:String,client_id:String,client_secret:String,redirect_uri:String,callback:@escaping (AccessTokenResponse?, HTTPURLResponse?, Error?) -> Swift.Void){
        print(#file,#function,#line)
        var comp = URLComponents()
        comp.scheme = "https"
        comp.host = TWICAS_HOST
        comp.path = "/oauth2/access_token"
        let url:URL = comp.url!
        let parameter:Parameters = [
            "code":code,
            "grant_type":grant_type,
            "client_id":client_id,
            "client_secret":client_secret,
            "redirect_uri":redirect_uri
        ]
        
        Alamofire.request(url, method: HTTPMethod.post, parameters: parameter, encoding: URLEncoding.default)
            .responseJSON { (response:DataResponse<Any>) in
            var resp:AccessTokenResponse? = nil
            if response.result.isSuccess {
                //まずJSONデータをNSDictionary型に
                let jsonDic = response.result.value as! NSDictionary
                print(#file,#function,#line,"jsonDic \(jsonDic)")
                if jsonDic["error"] == nil {
                    //辞書化したjsonDicからキー値"responseData"を取り出す
                    resp = AccessTokenResponse(token_type: jsonDic["token_type"] as! String, expires_in: jsonDic["expires_in"] as! Int, access_token: jsonDic["access_token"] as! String)
                }
                
                
            }
            callback(resp, response.response, response.result.error)

        }
    }
    
    static func movies(movie_id:String,access_token:String,callback:@escaping (AccessTokenResponse?, HTTPURLResponse?, Error?) -> Swift.Void){
        print(#file,#function,#line)
        var comp = URLComponents()
        comp.scheme = "https"
        comp.host = TWICAS_HOST
        comp.path = "/movies/\(movie_id)"
        let url:URL = comp.url!
        let headers:HTTPHeaders = [
            "X-Api-Version":"2.0",
            "Authorization":"Bearer \(access_token)"
        ]
        Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
            var resp:AccessTokenResponse? = nil
            if response.result.isSuccess {
                //まずJSONデータをNSDictionary型に
                let jsonDic = response.result.value as! NSDictionary
                print(#file,#function,#line,"jsonDic \(jsonDic)")
                if jsonDic["error"] == nil {
                    //辞書化したjsonDicからキー値"responseData"を取り出す
                    resp = AccessTokenResponse(token_type: jsonDic["token_type"] as! String, expires_in: jsonDic["expires_in"] as! Int, access_token: jsonDic["access_token"] as! String)
                }
                
                
            }
            callback(resp, response.response, response.result.error)
        }
        
    }
    
    static func users(user_id:String,access_token:String,callback:@escaping (UserObject?, HTTPURLResponse?, Error?) -> Swift.Void){
        print(#file,#function,#line)
        var comp = URLComponents()
        comp.scheme = "https"
        comp.host = TWICAS_HOST
        comp.path = "/users/\(user_id)"
        let url:URL = comp.url!
        let headers:HTTPHeaders = [
            "X-Api-Version":"2.0",
            "Authorization":"Bearer \(access_token)"
        ]
        Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
            var resp:UserObject? = nil
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                resp = UserObject(id: json["id"].stringValue, screen_id: json["screen_id"].stringValue, name: json["name"].stringValue, image: json["image"].stringValue, profile: json["profile"].stringValue, last_movie_id: json["last_movie_id"].string, is_live: json["is_live"].boolValue, created: json["created"].intValue)
                break
            case .failure(let error):
                break
            }
            
            callback(resp, response.response, response.result.error)
        }
        
    }
    
    static func searchLives(limit:Int?,type:String,context:String?,lang:String,callback:@escaping ([TwicasMovie], HTTPURLResponse?, Error?) -> Swift.Void){
        print(#file,#function,#line)
        var parameter:Parameters = [
            "type":type,
            "lang":lang
        ]
        
        if let limit = limit {
            parameter["limit"] = limit
        }
        
        if let context = context {
            parameter["context"] = context
        }
        
        base(path: "/search/lives", access_token: nil, parameter: parameter) { (response) in

            var resp:[TwicasMovie] = []
            switch response.result {
            case .success(let value):
                let tmpjson = JSON(value)
                let array = tmpjson["movies"].array
                if let jsons = array {
                    for movies in jsons {
                        let json = movies["movie"]
                        let item = TwicasMovie(id: json["id"].stringValue,
                                               user_id: json["user_id"].stringValue,
                                               title: json["title"].stringValue,
                                               subtitle: json["subtitle"].stringValue,
                                               link: json["link"].stringValue,
                                               is_live: json["is_live"].boolValue,
                                               is_recorded: json["is_recorded"].boolValue,
                                               comment_count: json["comment_count"].intValue,
                                               large_thumbnail: json["large_thumbnail"].stringValue,
                                               small_thumbnail: json["small_thumbnail"].stringValue,
                                               country: json["country"].stringValue,
                                               duration: json["duration"].intValue,
                                               created: json["created"].intValue,
                                               is_collabo: json["is_collabo"].boolValue,
                                               is_protected: json["is_protected"].boolValue,
                                               max_view_count: json["max_view_count"].intValue,
                                               current_view_count: json["current_view_count"].intValue,
                                               total_view_count: json["total_view_count"].intValue,
                                               hls_url: json["hls_url"].stringValue)
                        resp.append(item)
                    }
                    
                    
                }
                
                break
            case .failure(let error):
                break
            }
            
            callback(resp, response.response, response.result.error)
        }
        
        
        
    }
    
    static func base(path: String,access_token:String?,parameter:Parameters?,completionHandler: @escaping (DataResponse<Any>) -> Void){
        var comp = URLComponents()
        comp.scheme = "https"
        comp.host = TWICAS_HOST
        comp.path = path
        let url:URL = comp.url!
        var authorization:String
        if let access_token = access_token {
            authorization = "Bearer \(access_token)"
        } else {
            let str = "\(YOUR_CLINET_ID):\(YOUR_TWICAS_CLIENT_SECRET)"
            authorization = "Basic \(Data(str.utf8).base64EncodedString())"
        }

        let headers:HTTPHeaders = [
            "X-Api-Version":"2.0",
            "Authorization":authorization
        ]
        Alamofire.request(url, method: .get, parameters: parameter, encoding: URLEncoding.default, headers: headers).responseJSON(completionHandler: completionHandler)
    }
    
//    static func base(path: String,parameter:Parameters?,completionHandler: @escaping (DataResponse<Any>) -> Void){
//        var comp = URLComponents()
//        comp.scheme = "https"
//        comp.host = TWICAS_HOST
//        comp.path = path
//        let url:URL = comp.url!
//        let str = "\(YOUR_CLINET_ID):\(YOUR_TWICAS_CLIENT_SECRET)"
//        let authorization = "Basic \(Data(str.utf8).base64EncodedString())"
//        
//        let headers:HTTPHeaders = [
//            "X-Api-Version":"2.0",
//            "Authorization":authorization
//        ]
//        Alamofire.request(url, method: .get, parameters: parameter, encoding: URLEncoding.default, headers: headers).responseJSON(completionHandler: completionHandler)
//    }
    
//    static func access_token(callback:@escaping (AccessTokenResponse?, URLResponse?, Error?) -> Swift.Void,delegate:URLSessionDelegate?,code:String,grant_type:String,client_id:String,client_secret:String,redirect_uri:String){
//        print(#file,#function,#line)
//        let method = "POST"
//        var comp = URLComponents()
//        comp.scheme = "https"
//        comp.host = TWICAS_HOST
//        comp.path = "/oauth2/access_token"
//        let url:URL = comp.url!
//        let cachePolicy:URLRequest.CachePolicy = .useProtocolCachePolicy
//        let timeoutInterval:TimeInterval = 10.0
//        var request:URLRequest = URLRequest(url: url, cachePolicy: cachePolicy, timeoutInterval: timeoutInterval)
//        request.httpMethod = method
//        let options:JSONSerialization.WritingOptions = JSONSerialization.WritingOptions.prettyPrinted
//        do {
//            request.httpBody = try JSONSerialization.data(withJSONObject: [
//                "code":code,
//                "grant_type":grant_type,
//                "client_id":client_id,
//                "client_secret":client_secret,
//                "redirect_uri":redirect_uri
//                
//                ], options: options)
//            let delegateQueue:OperationQueue? = nil
//            let session = URLSession(configuration: URLSessionConfiguration.default, delegate: delegate, delegateQueue: delegateQueue)
//            let task = session.dataTask(with: request) { (data:Data?, response:URLResponse?, error:Error?) in
//                print(#file,#function,#line)
//                print(#file,#function,#line,"data \(data)")
//                if let data = data  {
//                    do {
//                        let object:[String:Any] = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)
//                        let resp = AccessTokenResponse(token_type: object["token_type"] as! String, expires_in: object["expires_in"] as! Int, access_token: object["access_token"] as! String)
//                        
//                    } catch {
//                        
//                    }
//                }
//                
//                callback(nil, response, error)
//            }
//            task.resume()
//        } catch {
//            print(error)
//        }
//
//    }
    
}
