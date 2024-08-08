//
//  AkWebServiceCall.swift
//  AkWebServiceCall
//
//  Created by  on 25/07/18.
//  Copyright © 2018 . All rights reserved.
//

import UIKit

let webServiceURL = strWebServiceURL

class AkWebServiceCall: NSObject {
    
    typealias responseSucces = (_ responseObject: NSDictionary, _ success: Bool) -> Void
    
    func CallApiWithPath(path:String, input:NSDictionary, showLoader:Bool, view:UIView, isGetMethod:Bool, isGetWithParameter:Bool, isPostWithGetParameters:Bool, success:@escaping (responseSucces), failure:@escaping (responseSucces)) -> URLSession {
        if showLoader
        {
            view.squareLoading.start(delay: 0.0)
        }
        
        let requestURL : String = self.generateQueryForInputDictionary(input: input, path: path, isGetMethod: isGetMethod, isGetWithParameter: isGetWithParameter, isPostWithGetParameters: isPostWithGetParameters)
        
        let request : URLRequest = self.generateWebServiceRequestURL(url: requestURL, input: input, isGetMethod: isGetMethod, isGetWithParameter: isGetWithParameter, isPostWithGetParameters: isPostWithGetParameters)
        
        let session : URLSession = URLSession.shared
        /*
        print("URL:- \(requestURL)")
        print("PARAM:- \(input)")
        */
        let task = session.dataTask(with: request, completionHandler: {(data, response, error) in
            
            let tmpDic = NSMutableDictionary()
            tmpDic.setValue("1", forKey: "code")
            
            guard Global.is_Reachablity().isNetwork else {
                DispatchQueue.main.async {
                    if showLoader
                    {
                        view.squareLoading.stop(delay: 0.0)
                    }
                    tmpDic.setValue("No Internet Available", forKey: "message")
                    failure(tmpDic, false)
                }
                return
            }
            
            guard let _: Data = data, let _: URLResponse = response, error == nil else {
                print(error as Any)
                DispatchQueue.main.async {
                    if showLoader
                    {
                        view.squareLoading.stop(delay: 0.0)
                    }
                    tmpDic.setValue("Something went wrong", forKey: "message")
                    failure(tmpDic, false)
                }
                return
            }
            
            //print(response as Any)
            //let dataString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            //print("*****This is the data 4: \(dataString ?? "No Response")") //JSONSerialization
            
            if error == nil
            {
                let httpResp : HTTPURLResponse = response as! HTTPURLResponse
                
                if httpResp.statusCode == 200
                {
                    do
                    {
                        if let responseDic = try JSONSerialization.jsonObject(with: data!, options : .mutableContainers) as? NSDictionary
                        {
                            DispatchQueue.main.async {
                                
                                if showLoader
                                {
                                    view.squareLoading.stop(delay: 0.0)
                                }
                                success(responseDic, true)
                            }
                        }
                        else
                        {
                            DispatchQueue.main.async {
                                
                                if showLoader
                                {
                                    view.squareLoading.stop(delay: 0.0)
                                }
                                tmpDic.setValue("Something went wrong", forKey: "message")
                                failure(tmpDic, false)
                            }
                        }
                    }
                    catch let error as NSError
                    {
                        print(error)
                        DispatchQueue.main.async {
                            
                            if showLoader
                            {
                                view.squareLoading.stop(delay: 0.0)
                            }
                            tmpDic.setValue("Something went wrong", forKey: "message")
                            failure(tmpDic, false)
                            
                        }
                    }
                }
                else
                {
                    DispatchQueue.main.async {
                        
                        if showLoader
                        {
                            view.squareLoading.stop(delay: 0.0)
                        }
                        tmpDic.setValue("Something went wrong", forKey: "message")
                        failure(tmpDic, false)
                        
                    }
                }
            }
            else
            {
                DispatchQueue.main.async {
                    
                    if showLoader
                    {
                        view.squareLoading.stop(delay: 0.0)
                    }
                    tmpDic.setValue("Something went wrong", forKey: "message")
                    failure(tmpDic, false)
                    
                }
            }
            
        });
        task.resume()
        return session
    }
    
    
    func generateQueryForInputDictionary(input: NSDictionary, path: String, isGetMethod: Bool, isGetWithParameter: Bool, isPostWithGetParameters: Bool) -> String {
        
        var requestURL:String = webServiceURL
        
        requestURL = requestURL.appending(path)
        
        if isGetWithParameter || isPostWithGetParameters
        {
            requestURL = requestURL.appending("?")
            
            for x in 0 ..< input.allKeys.count
            {
                let key:String = input.allKeys[x] as! String
                
                let value:String = input.allValues[x] as! String
                
                requestURL = requestURL.appending("\(key)=\(value)")
                
                if (x != input.allKeys.count - 1)
                {
                    requestURL = requestURL.appending("&")
                }
            }
        }
        
        return self.urlEnocodeString(str: requestURL)
    }
    
    
    func urlEnocodeString(str:String) -> String
    {
        return str.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
    }
    
    
    func generateWebServiceRequestURL(url:String, input:Any, isGetMethod: Bool, isGetWithParameter: Bool, isPostWithGetParameters: Bool) -> URLRequest
    {
        var request : URLRequest = URLRequest.init(url: URL.init(string: url)!)
        
        //request.url = URL.init(string: url)
        
        if isGetMethod || isGetWithParameter
        {
            request.httpMethod = "GET"
        }
        else
        {
            request.httpMethod = "POST"
            
            if !isPostWithGetParameters
            {
                let InputString : String = self.JSONDataString(json: input)
                
                let postLength : String = "\(InputString.count)"
                
                request.setValue(postLength, forHTTPHeaderField: "Content-Length")
                
                request.httpBody = InputString.data(using: .utf8)
            }
            //NSLog(@"SIZE OF Upload: %f Mb", [postLength floatValue]/1024/1024);
        }
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.setValue(strApiKey, forHTTPHeaderField: "api_key")
        
        return request;
    }
    
    
    func JSONDataString(json: Any) -> String
    {
        var options: JSONSerialization.WritingOptions = []
        
        options = JSONSerialization.WritingOptions.prettyPrinted
        
        do
        {
            let data = try JSONSerialization.data(withJSONObject: json, options: options)
            
            if let string = String(data: data, encoding: String.Encoding.utf8)
            {
                return string
            }
        }
        catch
        {
            print(error)
        }
        return ""
    }
    
}

