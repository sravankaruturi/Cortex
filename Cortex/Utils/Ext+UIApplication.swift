//
//  Ext+UIApplication.swift
//  Cortex
//
//  Created by Sravan Karuturi on 5/28/24.
//

import Foundation
import UIKit

extension UIApplication {
    
    @MainActor
    class func topViewController(_ controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(presented)
        }
        return controller
    }
    
}
