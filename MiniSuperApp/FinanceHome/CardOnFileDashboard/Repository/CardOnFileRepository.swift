//
//  CardOnFileRepository.swift
//  MiniSuperApp
//
//  Created by TaeHyeong Kim on 2021/10/26.
//

import Foundation
import Combine

protocol CardOnFileRepository {
  var cardOnFile: ReadOnlyCurrentValuePublisher<[PaymentMethod]> { get }
  func addCard(info: AddPaymentMethodInfo) -> AnyPublisher<PaymentMethod, Error>
}

final class CardOnFileRepositoryImp: CardOnFileRepository {
  var cardOnFile: ReadOnlyCurrentValuePublisher<[PaymentMethod]> { paymentMethodSubject }
  
  private let paymentMethodSubject = CurrentValuePublisher<[PaymentMethod]>([
    PaymentMethod(id: "0", name: "우리은행", digits: "0123", color: "#f19a38ff", isPrimary: false),
    PaymentMethod(id: "1", name: "신한카드", digits: "2938", color: "#3478f6ff", isPrimary: false),
    PaymentMethod(id: "2", name: "현대카드", digits: "1093", color: "#78c5f5ff", isPrimary: false),
  ])
  
  func addCard(info: AddPaymentMethodInfo) -> AnyPublisher<PaymentMethod, Error> {
    let paymentMethod = PaymentMethod(id: "00", name: "New 카드", digits: "\(info.number.suffix(4))", color: "", isPrimary: false)
    var new = paymentMethodSubject.value
    new.append(paymentMethod)
    paymentMethodSubject.send(new)
    
    return Just(paymentMethod).setFailureType(to: Error.self).eraseToAnyPublisher()
  }
  
  
}
