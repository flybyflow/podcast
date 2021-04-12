//
//  UIApplication.swift
//  Podcast
//
//  Created by Mo on 2021-04-10.
//

import Foundation
import UIKit

extension UIApplication {
    static func mainTabBarController() -> MainTabBarController? {
        return shared.keyWindow?.rootViewController as? MainTabBarController
    }
}
