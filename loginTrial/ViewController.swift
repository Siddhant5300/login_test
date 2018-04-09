//
//  ViewController.swift
//  loginTrial
//
//  Created by Gupta on 4/8/18.
//  Copyright © 2018 Gupta. All rights reserved.
//

import UIKit
import Alamofire
class ViewController: UIViewController {
    var userType  = "Professional"
    var token :String! = "Bearer"
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getLogindetails()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func getLogindetails(){
        let url = "https://idem.earth/signin"
        let parameters = [
            "email": "anton.simonov212@gmail.com",
            "password": "one"
        ]
        
        Alamofire.request(url, method:.post, parameters:parameters,encoding: JSONEncoding.default).responseJSON { response in
            switch response.result {
            case .success:
                print(response)
                if let userJSON = response.result.value{
                    let userInfoObject : Dictionary = userJSON as! Dictionary < String,Any>
                    let professionalObject = userInfoObject["professional"] as! Int//as! Dictionary< String,Any>
                    let tokenObject = userInfoObject["token" ] as! String
                    self.token = self.token + " "  + tokenObject
                  //  print ("BPI object")
                    if (professionalObject == 1)
                    {
                        self.userType = "Professional"
                        print ("professional")
                         print (professionalObject)
                        print (self.token)
                    }
                    else{
                        print ("client")
                        self.userType = "Client"
                    }
                   
                    //                        let USDObject :Dictionary = bpiObject["USD"] as! Dictionary<String,Any>
                    //                        print ("USD object")
                    //                        print (USDObject)
                    //                        print (USDObject["rate"] as! String)
                    //print (bitcoinObject)
                }
            case .failure(let error):
                print()//failure(0,"Error")
            }
        }
    }

    @IBAction func btnClick(_ sender: Any) {
     

        var bTask = DispatchQueue.global(qos: DispatchQoS.QoSClass.background)
        let workQueue = DispatchQueue.global(qos: DispatchQoS.QoSClass.background)
        workQueue.async {
            var bTask : UIBackgroundTaskIdentifier = UIBackgroundTaskInvalid
            bTask = UIApplication.shared.beginBackgroundTask(expirationHandler: {
                ()-> Void in
                UIApplication.shared.endBackgroundTask(bTask)
                bTask = UIBackgroundTaskInvalid
            })
            
              if (self.userType == "Professional")
              {
                let headers : [String:String] = [
                    "Content-Type": "application/json",
                    "Authorization": self.token
                ]
                print (headers)
                let checkURL = "https://idem.earth/api/v1/appt/professional"
                Alamofire.request(checkURL, method: .get, parameters: ["":""], encoding: URLEncoding.default, headers: headers).responseJSON{ response in
                    print (response)
                }
                
        }
            else if (self.userType == "Client")
          {
                    let headers : [String:String] = [
                        "Content-Type": "application/json",
                        "Authorization": self.token
                    ]
                    print (headers)
                    let checkURL = "https://idem.earth/api/v1/appt/client"
                    Alamofire.request(checkURL, method: .get, parameters: ["":""], encoding: URLEncoding.default, headers: headers).responseJSON{ response in
                        print (response)
                    }

            }
        
    }
    
}
}

