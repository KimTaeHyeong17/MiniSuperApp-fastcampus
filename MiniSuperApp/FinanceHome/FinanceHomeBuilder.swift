import ModernRIBs

protocol FinanceHomeDependency: Dependency {
  // TODO: Declare the set of dependencies required by this RIB, but cannot be
  // created by this RIB.
}

final class FinanceHomeComponent: Component<FinanceHomeDependency>, SuperPayDashboardDependency {
  ///리블렛이 필요한 객체를 담는 바구니
  ///자식리블렛이 필요한 객체도 담고 있어서 자식들의 dependency를 conform 해야함
  
  var balance: ReadOnlyCurrentValuePublisher<Double> { balancePublisher }
  private let balancePublisher: CurrentValuePublisher<Double>

  init(
    dependency: FinanceHomeDependency,
    balance: CurrentValuePublisher<Double>
  ) {
    self.balancePublisher = balance
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
    let component = FinanceHomeComponent(
      dependency: dependency,
      balance: balancePublisher
    )
    let viewController = FinanceHomeViewController()
    let interactor = FinanceHomeInteractor(presenter: viewController)
    interactor.listener = listener
    
    let superPayDashboardBuilder = SuperPayDashboardBuilder(dependency: component)
    
    return FinanceHomeRouter(
      interactor: interactor,
      viewController: viewController,
      superPayDashboardBuildable: superPayDashboardBuilder)
  }
}
