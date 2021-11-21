import ModernRIBs

protocol FinanceHomeDependency: Dependency {
  var cardOnFileRepository: CardOnFileRepository { get }
  var superPayRepository: SuperPayRepository { get }
}

final class FinanceHomeComponent: Component<FinanceHomeDependency>, SuperPayDashboardDependency, CardOnFileDashboardDependency, AddPaymentMethodDependency, TopupDependency {
  
  var topupBaseViewController: ViewControllable
  
  ///리블렛이 필요한 객체를 담는 바구니
  ///자식리블렛이 필요한 객체도 담고 있어서 자식들의 dependency를 conform 해야함
  
  var cardOnFileRepository: CardOnFileRepository { dependency.cardOnFileRepository }
  var superPayRepository: SuperPayRepository { dependency.superPayRepository }
  var balance: ReadOnlyCurrentValuePublisher<Double> { superPayRepository.balance }

  init(
    dependency: FinanceHomeDependency,
    cardOnFileRepository: CardOnFileRepository,
    superPayRepository: SuperPayRepository,
    topupBaseViewController: ViewControllable
  ) {
    self.topupBaseViewController = topupBaseViewController
    super.init(dependency: dependency)
  }

}

// MARK: - Builder

protocol FinanceHomeBuildable: Buildable {
  func build(withListener listener: FinanceHomeListener) -> FinanceHomeRouting
}

final class FinanceHomeBuilder: Builder<FinanceHomeDependency>, FinanceHomeBuildable {
  
  override init(dependency: FinanceHomeDependency) {
    super.init(dependency: dependency)
  }
  
  func build(withListener listener: FinanceHomeListener) -> FinanceHomeRouting {
    let balancePublisher = CurrentValuePublisher<Double>(10000)
    
    let viewController = FinanceHomeViewController()

    let component = FinanceHomeComponent(
      dependency: dependency,
      cardOnFileRepository: dependency.cardOnFileRepository,
      superPayRepository: dependency.superPayRepository,
      topupBaseViewController: viewController
    )
    let interactor = FinanceHomeInteractor(presenter: viewController)
    interactor.listener = listener
    
    let superPayDashboardBuilder = SuperPayDashboardBuilder(dependency: component)
    let cardOnFileDashboardBuilder = CardOnFileDashboardBuilder(dependency: component)
    let addPaymentMethodBuilder = AddPaymentMethodBuilder(dependency: component)
    let topupBuilder = TopupBuilder(dependency: component)
    
    return FinanceHomeRouter(
      interactor: interactor,
      viewController: viewController,
      superPayDashboardBuildable: superPayDashboardBuilder,
      cardOnFileDashboardBuildable: cardOnFileDashboardBuilder,
      addPaymentMethodBuildable: addPaymentMethodBuilder,
      topupBuildable: topupBuilder
    )
  }
}
