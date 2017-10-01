//
//  apiConfig.swift
//  JobSpot-iOS
//
//  Created by Marlow Fernandez on 9/30/17.
//  Copyright © 2017 JobSpot. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class ApiConfigTesting {
    let API_KEY = "imXBBrutJKGqrj6NHkLNPA41F8H/dbvQDiYjpaLrQWmYzJb+PNAZ7dg8D6Gv7onpkZl1mccgSRygH+xiE7AZrQ=="
    
    let headers: HTTPHeaders = [
        "Authorization": "Bearer imXBBrutJKGqrj6NHkLNPA41F8H/dbvQDiYjpaLrQWmYzJb+PNAZ7dg8D6Gv7onpkZl1mccgSRygH+xiE7AZrQ==",
        "Content-Type": "application/json"
    ]
    
    func useHeader() -> URL? {
        let request = NSMutableURLRequest(url: URL(string: "https://api.careeronestop.org/v1/jobsearch/TZ1zgEyKTNm69nF/manager/wesley%20chapel%20fl/25/accquisitiondate/desc/0/200/30/")!)
        request.setValue("Bearer \(API_KEY)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json)", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
        
        return request.url! as URL
    }

    
    func createURLWithComponents() -> URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https";
        urlComponents.host = "api.careeronestop.org";
        urlComponents.path = "/v1/jobsearch/TZ1zgEyKTNm69nF/manager/wesley%20chapel%20fl/25/accquisitiondate/desc/0/200/30/";
        
        let request = NSMutableURLRequest(url: URL(string: (urlComponents.url?.absoluteString)!)!)
        request.httpMethod = "GET"
        request.setValue("application/json)", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(API_KEY)", forHTTPHeaderField: "Authorization")
        request.setValue("*/*", forHTTPHeaderField: "Accept")
        request.setValue("gzip, deflate", forHTTPHeaderField: "Accept-Encoding")
        request.setValue("runscope/0.1", forHTTPHeaderField: "User-Agent")
        
        
        debugPrint(request.url!)
        
        return request.url! as URL
        
    }
    
    func getJobs() {
        
        //Version 4
        Alamofire.request("https://api.careeronestop.org/v1/jobsearch/TZ1zgEyKTNm69nF/manager/wesley%20chapel%20fl/25/accquisitiondate/desc/0/200/30/", headers: headers).responseJSON { response in
            debugPrint("Alamofire response: \(response)")
        }
        
        
        guard let url = createURLWithComponents() else {
            print("invalid URL")
            return
        }
        
        let urlRequest = URLRequest(url: url as URL)
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
//version 1
//        NSURLConnection.sendAsynchronousRequest(urlRequest, queue: OperationQueue.main) { (response, data, error) in
//            // handle your data here
//            
////            debugPrint("FINDME2 \(response!)")
//        }
        
//version 2
//        let urlString = "https://api.careeronestop.org/v1/jobsearch/TZ1zgEyKTNm69nF/programmer/orlando%2C%20fl/25/0/0/0/10/60"
//        let session2 = URLSession.shared
//        let url2 = URL(string: urlString)!
//        var request = URLRequest(url: createURLWithComponents()!)
////        request.setValue("application-idValue", forHTTPHeaderField: "application-id")
//        request.setValue(API_KEY, forHTTPHeaderField: "Authorization")
//        session2.dataTask(with: request as URLRequest){(data, response1, error) -> Void in
//            
//            if let responseData = data
//            {
//                do{
//                    let json = try JSONSerialization.jsonObject(with: responseData, options: JSONSerialization.ReadingOptions.allowFragments)
//                    print("json - \(json)")
//                }catch{
//                    print("Could not serialize")
//                    debugPrint("Could not serialize \(responseData)")
//                    debugPrint("Could not serialize \(response1!)")
//                }
//            }
//            
//        }.resume()
        
        //version 3
        let task2 = session.dataTask(with: url) { (data, response, errorNew) in
            debugPrint(data)
        }
        
        
        
        let task = session.dataTask(with: urlRequest, completionHandler: { data, response, errorTop -> Void in
            
            if errorTop != nil {
                debugPrint("error \(errorTop!)")

            } else {
                debugPrint("data \(data!)")
                debugPrint("response \(data!)")
                
                let responseNew = NSString (data: data!, encoding: String.Encoding.utf8.rawValue)
                debugPrint("response new \(responseNew!)")
                
//                if let objectData = try? JSONSerialization.data(withJSONObject: stringNew!, options: JSONSerialization.WritingOptions(rawValue: 0)) {
//                    let objectString = String(data: objectData, encoding: .utf8)
//                    debugPrint("object string: \(objectString!)")
//                }
                
            }
            
            
            
//            do {
//                if let data = data,
//                    let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
//                    let blogs = json["jobs"] as? [[String: Any]] {
//                    debugPrint(blogs)
////                    for blog in blogs {
////                        if let name = blog["name"] as? String {
////                            names.append(name)
////                        }
////                    }
//                }
//            } catch {
//                print("Error deserializing JSON: \(error)")
//            }
            
                
//                let parsedData = try JSONSerialization.jsonObject(with: data!) as! [String:Any]
//                                    debugPrint(parsedData)
//                
            do {
                guard (try JSONSerialization.jsonObject(with: data!, options: []) as? [String: AnyObject]) != nil else {
                    
                        print("error trying to convert data to JSON")
                    
                        return
                }
                    // ...
            } catch  {
                print("error trying to convert data to JSON")
                    return
            }
            
            
            do {
                guard (try JSONSerialization.data(withJSONObject: data!, options: []) as? [String: AnyObject]) != nil else {
                    
                    print("error trying to convert data to JSON")
                    
                    return
                }
                // ...
            } catch  {
                print("error trying to convert data to JSON")
                return
            }
            
        })
        
        task.resume()
    }
    
}
