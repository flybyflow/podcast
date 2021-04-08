//
//  NetworkManager.swift
//  Podcast
//
//  Created by Mo on 2021-03-01.
//

import Foundation
import Alamofire

class NetworkManager {

    //Credit: GitHub - Fix for NetworkReachability Bugs
//shared instance
static let shared = NetworkManager()

let reachabilityManager = Alamofire.NetworkReachabilityManager(host: "www.google.com")

func startNetworkReachabilityObserver() {

    self.reachabilityManager?.startListening(onUpdatePerforming: {networkStatusListener in

           print("Network Status Changed:", networkStatusListener)

              switch networkStatusListener {
              case .notReachable:
                          print("The network is not reachable.")
                  case .unknown :
                          print("It is unknown whether the network is reachable.")
                  case .reachable(.ethernetOrWiFi):
                          print("The network is reachable over the WiFi connection")

                  case .reachable(.cellular):
                          print("The network is reachable over the WWAN connection")
           }

       })
}
}
