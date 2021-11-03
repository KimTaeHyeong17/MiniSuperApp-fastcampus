//
//  UIViewController+Utils.swift
//  MiniSuperApp
//
//  Created by TaeHyeong Kim on 2021/11/02.
//

import UIKit

extension UIViewController {
  func setupNavigationItem(target: Any?, action: Selector?) {
    return navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark", withConfiguration: UIImage.SymbolConfiguration(pointSize: 18, weight: .semibold)), style: .plain, target: target, action: action)
  }
}
