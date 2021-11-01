//
//  TopupInteractor.swift
//  MiniSuperApp
//
//  Created by TaeHyeong Kim on 2021/11/01.
//

import ModernRIBs

protocol TopupRouting: Routing {
  func cleanupViews()
  
  func attachAddPaymentMethod()
  func detachAddPaymentMethod()
}

protocol TopupListener: AnyObject {
  func topupDidClose()
}

protocol TopupInteractoryDependency {
  var cardOnFileRepository: CardOnFileRepository { get }
}

final class TopupInteractor: Interactor, TopupInteractable, AddPaymentMethodListener, AdaptivePresentationControllerDelegate {
  
  weak var router: TopupRouting?
  weak var listener: TopupListener?
  
  let presentationDelegateProxy: AdaptivePresentationControllerDelegateProxy
  
  private let dependency: TopupInteractoryDependency
  
  init(dependency: TopupInteractoryDependency) {
    self.presentationDelegateProxy = AdaptivePresentationControllerDelegateProxy()
    self.dependency = dependency
    super.init()
    self.presentationDelegateProxy.delegate = self
  }
  
  override func didBecomeActive() {
    super.didBecomeActive()
    if dependency.cardOnFileRepository.cardOnFile.value.isEmpty {
      //카드 추가 화면
      router?.attachAddPaymentMethod()

    } else {
      //금액 화면
    }
  }
  
  override func willResignActive() {
    super.willResignActive()
    router?.cleanupViews()
  }
  
  func presentationControllerDidDismiss() {
    listener?.topupDidClose()
  }
  
  func addPaymentMethodDidTapClose() {
    router?.detachAddPaymentMethod()
    listener?.topupDidClose()
  }
  
  func addPaymentMethodDidAddCard(paymentMethod: PaymentMethod) {
     
  }

}
