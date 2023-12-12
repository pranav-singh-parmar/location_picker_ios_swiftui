//
//  Extenstions.swift
//  location-picker-swiftui
//
//  Created by Pranav Singh on 12/12/23.
//

import Foundation
import UIKit

//MARK: - Bundle
extension Bundle {
    var getBundleIdentifier: String? {
        return Bundle.main.bundleIdentifier
        //return Bundle.main.infoDictionary?["CFBundleIdentifier"] as? String
    }
    
    var appCurrentVersion: String? {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    }
    
    var appName: String? {
        return Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String
    }
}

//MARK: - UIApplication
extension UIApplication {
    
    var getKeyWindow: UIWindow? {
        if #available(iOS 15, *) {
            return (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.keyWindow
        } else {
            return UIApplication.shared.windows.first
        }
    }
    
    func getTopViewController(_ baseVC: UIViewController? = UIApplication.shared.getKeyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = baseVC as? UINavigationController {
            return getTopViewController(navigationController.visibleViewController)
        }
        if let tabBarController = baseVC as? UITabBarController {
            return getTopViewController(tabBarController.selectedViewController)
        }
        if let presented = baseVC?.presentedViewController {
            return getTopViewController(presented)
        }
        return baseVC
    }
}

//MARK: - UIAlertController
extension UIAlertController {
    //MARK: - Initializers
    convenience init(ofStyle style: UIAlertController.Style,
                     withTitle title: String?,
                     andMessage message: String?) {
        self.init(title: "", message: "", preferredStyle: style)
        self.setTitle(title)
        self.setMessage(title)
    }
    
    private func setTitle(_ title: String?) {
        guard let title else {
            return
        }
        
        let attributedTitleKey = "attributedTitle"
        
        let titleAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .semibold),
                               NSAttributedString.Key.foregroundColor: UIColor.black]
        let titleString = NSAttributedString(string: title,
                                             attributes: titleAttributes)
        self.setValue(titleString,
                      forKey: attributedTitleKey)
    }
    
    private func setMessage(_ message: String?) {
        guard let message else {
            return
        }
        
        let attributedMessageKey = "attributedMessage"
        let messageAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13, weight: .regular),
                                 NSAttributedString.Key.foregroundColor: UIColor.black]
        let messageString = NSAttributedString(string: message,
                                               attributes: messageAttributes)
        self.setValue(messageString,
                      forKey: attributedMessageKey)
    }
    
    //MARK: - Actions
    func addAction(havingTitle title: String,
                   ofStyle style: UIAlertAction.Style,
                   withAction action: ((UIAlertAction) -> Void)? = nil) {
        self.addAction(UIAlertAction(title: title,
                                     style: style,
                                     handler: action))
    }
    
    func present(_ vc: UIViewController? = nil) {
        (vc ?? UIApplication.shared.getTopViewController())?.present(self, animated: true)
    }
}
