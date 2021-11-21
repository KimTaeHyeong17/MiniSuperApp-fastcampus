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
  func attachEnterAmount()
  func detachEnterAmount()
  func attachCardOnFile(paymentMethods: [PaymentMethod])
  func detachCardOnFile()
}

protocol TopupListener: AnyObject {
  func topupDidClose()
  func topupDidFinish()
}

protocol TopupInteractoryDependency {
  var cardOnFileRepository: CardOnFileRepository { get }
  var paymentMethodStream: CurrentValuePublisher<PaymentMethod> { get }
}

final class TopupInteractor: Interactor, TopupInteractable, AddPaymentMethodListener, AdaptivePresentationControllerDelegate {
  
  weak var router: TopupRouting?
  weak var listener: TopupListener?
  
  let presentationDelegateProxy: AdaptivePresentationControllerDelegateProxy
  
  private var paymentMehtods: [PaymentMethod] {
    dependency.cardOnFileRepository.cardOnFile.value
  }
  
  private let dependency: TopupInteractoryDependency
  
  init(dependency: TopupInteractoryDependency) {
    self.presentationDelegateProxy = AdaptivePresentationControllerDelegateProxy()
    self.dependency = dependency
    super.init()
    self.presentationDelegateProxy.delegate = self
  }
  
  override func didBecomeActive() {
    super.didBecomeActive()
    
    if let card = dependency.cardOnFileRepository.cardOnFile.value.first {
      dependency.paymentMethodStream.send(card)
      router?.attachEnterAmount()
    } else {
      router?.attachAddPaymentMethod()
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
  
  func enterAmountDidTapClose() {
    router?.detachEnterAmount()
    listener?.topupDidClose()
  }
  
  func enterAmountDidTapPaymentMethod() {
    router?.attachCardOnFile(paymentMethods: paymentMehtods)
  }
  
  func enterAmountDidFinishTopup() {
    listener?.topupDidFinish()
  }
  
  func cardOnFileDidTapClose() {
    router?.detachCardOnFile()
  }
  
  func cardOnFileDidTapAddCard() {
    
  }
  
  func cardOnFileDidSelect(at index: Int) {
    if let selected = paymentMehtods[safe:index] {
      dependency.paymentMethodStream.send(selected)
    }
    router?.detachCardOnFile()
  }
  
}
