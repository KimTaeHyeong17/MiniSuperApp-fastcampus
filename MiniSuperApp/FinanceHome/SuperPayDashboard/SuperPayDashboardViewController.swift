//
//  SuperPayDashboardViewController.swift
//  MiniSuperApp
//
//  Created by TaeHyeong Kim on 2021/10/25.
//

import ModernRIBs
import UIKit

protocol SuperPayDashboardPresentableListener: AnyObject {
  func superPayDashoardDidTapTopup()
}

final class SuperPayDashboardViewController: UIViewController, SuperPayDashboardPresentable, SuperPayDashboardViewControllable {
  
  weak var listener: SuperPayDashboardPresentableListener?
  
  private let headerStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.alignment = .fill
    stackView.distribution = .equalSpacing
    stackView.axis = .horizontal
    return stackView
  }()
  
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = .systemFont(ofSize: 22, weight: .semibold)
    label.text = "슈퍼페이 잔고"
    return label
  }()
  
  private lazy var topupButton: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setTitle("충전하기", for: .normal)
    button.setTitleColor(.systemBlue, for: .normal)
    button.addTarget(self, action: #selector(topupButtonDidTap), for: .touchUpInside)
    return button
  }()
  
  private let cardView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.roundCorners()
    view.backgroundColor = .systemIndigo
    return view
  }()
  
  private let currencyLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = .systemFont(ofSize: 32, weight: .semibold)
    label.text = "원"
    label.textColor = .white
    return label
  }()
  
  private let balanceAmountLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = .systemFont(ofSize: 22, weight: .semibold)
    label.textColor = .white
    label.text = "10,000"
    return label
  }()
  
  private let balanceStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.alignment = .fill
    stackView.distribution = .equalSpacing
    stackView.axis = .horizontal
    stackView.spacing = 4
    return stackView
  }()
  
  init() {
    super.init(nibName: nil, bundle: nil)
    setupViews()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setupViews()
  }
  
  private func setupViews() {
    view.backgroundColor = .white
    view.addSubview(headerStackView)
    view.addSubview(cardView)
    cardView.addSubview(balanceStackView)
    balanceStackView.addArrangedSubview(balanceAmountLabel)
    balanceStackView.addArrangedSubview(currencyLabel)
    
    headerStackView.addArrangedSubview(titleLabel)
    headerStackView.addArrangedSubview(topupButton)
    
    NSLayoutConstraint.activate([
      headerStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
      headerStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 20),
      headerStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
      
      cardView.topAnchor.constraint(equalTo: headerStackView.bottomAnchor, constant: 10),
      cardView.heightAnchor.constraint(equalToConstant: 180),
      cardView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
      cardView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
      cardView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
      
      balanceStackView.centerXAnchor.constraint(equalTo: cardView.centerXAnchor),
      balanceStackView.centerYAnchor.constraint(equalTo: cardView.centerYAnchor)
      
    ])
  }
  
  func updateBalance(_ balance: String) {
    balanceAmountLabel.text = balance
  }
  
  @objc
  private func topupButtonDidTap() {
    listener?.superPayDashoardDidTapTopup()
  }
}
