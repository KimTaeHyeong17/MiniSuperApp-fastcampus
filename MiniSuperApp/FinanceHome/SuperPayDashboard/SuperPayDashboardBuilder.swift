//
//  SuperPayDashboardBuilder.swift
//  MiniSuperApp
//
//  Created by TaeHyeong Kim on 2021/10/25.
//

import ModernRIBs
import Foundation

protocol SuperPayDashboardDependency: Dependency { ///부모로 부터 받고싶은 dependency
  var balance: ReadOnlyCurrentValuePublisher<Double> { get }

}

final class SuperPayDashboardComponent: Component<SuperPayDashboardDependency>, SuperPayDashboardInteractorDependency {
  var balanceFormatter: NumberFormatter { Formatter.balanceFormatter }
  var balance: ReadOnlyCurrentValuePublisher<Double> { dependency.balance }
}

// MARK: - Builder

protocol SuperPayDashboardBuildable: Buildable {
  func build(withListener listener: SuperPayDashboardListener) -> SuperPayDashboardRouting
}

final class SuperPayDashboardBuilder: Builder<SuperPayDashboardDependency>, SuperPayDashboardBuildable {
  
  override init(dependency: SuperPayDashboardDependency) {
    super.init(dependency: dependency)
  }
  
  func build(withListener listener: SuperPayDashboardListener) -> SuperPayDashboardRouting {
    let component = SuperPayDashboardComponent(dependency: dependency)
    let viewController = SuperPayDashboardViewController()
    let interactor = SuperPayDashboardInteractor(
      presenter: viewController,
      dependency: component
    )
    interactor.listener = listener
    return SuperPayDashboardRouter(interactor: interactor, viewController: viewController)
  }
}
