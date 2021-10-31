//
//  AdaptivePresentationControllerDelegate.swift
//  MiniSuperApp
//
//  Created by TaeHyeong Kim on 2021/10/31.
//

import Foundation
import UIKit

protocol AdaptivePresentationControllerDelegate: AnyObject {
  func presentationControllerDidDismiss()
}
final class AdaptivePresentationControllerDelegateProxy: NSObject, UIAdaptivePresentationControllerDelegate {
  weak var delegate: AdaptivePresentationControllerDelegate?
  
  func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
    delegate?.presentationControllerDidDismiss()
  }
}
