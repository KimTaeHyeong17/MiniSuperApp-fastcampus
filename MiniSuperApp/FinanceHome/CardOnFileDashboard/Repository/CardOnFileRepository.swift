//
//  CardOnFileRepository.swift
//  MiniSuperApp
//
//  Created by TaeHyeong Kim on 2021/10/26.
//

import Foundation

protocol CardOnFileRepository {
  var cardOnFile: ReadOnlyCurrentValuePublisher<[PaymentMethod]> { get }
}

final class CardOnFileRepositoryImp: CardOnFileRepository {
  var cardOnFile: ReadOnlyCurrentValuePublisher<[PaymentMethod]> { paymentMethodSubject }
  
  private let paymentMethodSubject = CurrentValuePublisher<[PaymentMethod]>([
    PaymentMethod(id: "0", name: "우리은행", digits: "0123", color: "#f19a38ff", isPrimary: false),
    PaymentMethod(id: "1", name: "신한카드", digits: "2938", color: "#3478f6ff", isPrimary: false),
    PaymentMethod(id: "2", name: "현대카드", digits: "1093", color: "#78c5f5ff", isPrimary: false),
    PaymentMethod(id: "3", name: "국민카드", digits: "4821", color: "#65c466ff", isPrimary: false),
    PaymentMethod(id: "4", name: "부산은행", digits: "9243", color: "#ffcc00ff", isPrimary: false),
  ])
  
}
