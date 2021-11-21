//
//  TopupBuilder.swift
//  MiniSuperApp
//
//  Created by TaeHyeong Kim on 2021/11/01.
//

import ModernRIBs

protocol TopupDependency: Dependency {
  var topupBaseViewController: ViewControllable { get }
  var cardOnFileRepository: CardOnFileRepository { get }
  var superPayRepository: SuperPayRepository { get }

}

final class TopupComponent: Component<TopupDependency>, TopupInteractoryDependency, AddPaymentMethodDependency, EnterAmountDependency, CardOnFileDependency {
  var superPayRepository: SuperPayRepository { dependency.superPayRepository }
  var selectedPaymentMethod: ReadOnlyCurrentValuePublisher<PaymentMethod> { paymentMethodStream }
  var cardOnFileRepository: CardOnFileRepository { dependency.cardOnFileRepository }
  
  fileprivate var topupBaseViewController: ViewControllable {
    return dependency.topupBaseViewController
  }
  
  let paymentMethodStream: CurrentValuePublisher<PaymentMethod>
  
  init(dependency: TopupDependency, paymentMethodStream: CurrentValuePublisher<PaymentMethod>) {
    self.paymentMethodStream = paymentMethodStream
    super.init(dependency: dependency)
  }
  
}

// MARK: - Builder

protocol TopupBuildable: Buildable {
  func build(withListener listener: TopupListener) -> TopupRouting
}

final class TopupBuilder: Builder<TopupDependency>, TopupBuildable {
  
  override init(dependency: TopupDependency) {
    super.init(dependency: dependency)
  }
  
  func build(withListener listener: TopupListener) -> TopupRouting {
    let paymentMethodStream = CurrentValuePublisher(PaymentMethod(id: "", name: "", digits: "", color: "", isPrimary: false))
    
    let component = TopupComponent(dependency: dependency, paymentMethodStream: paymentMethodStream)
    let interactor = TopupInteractor(dependency: component)
    interactor.listener = listener
    
    let addPaymentMethodBuilder = AddPaymentMethodBuilder(dependency: component)
    let enterAmountBuilder = EnterAmountBuilder(dependency: component)
    let cardOnFileBuilder = CardOnFileBuilder(dependency: component)
    
    return TopupRouter(interactor: interactor, viewController: component.topupBaseViewController, addPaymentMethodBuildable: addPaymentMethodBuilder, enterAmountBuildable: enterAmountBuilder, cardOnFileBuildable: cardOnFileBuilder)
  }
}
