//
//  Combine+Utils.swift
//  MiniSuperApp
//
//  Created by TaeHyeong Kim on 2021/10/25.
//

import Combine
import CombineExt
import Foundation

/// 잔액을 읽을수만 있는 Publisher
public class ReadOnlyCurrentValuePublisher<Element>: Publisher {
  public typealias Output = Element
  public typealias Failure = Never
  
  public var value: Element {
    currentValueRelay.value
  }
  
  fileprivate let currentValueRelay: CurrentValueRelay<Output>
  
  fileprivate init(_ initialValue: Element) {
    currentValueRelay = CurrentValueRelay(initialValue)
  }
  
  public func receive<S>(subscriber: S) where S : Subscriber, Never == S.Failure, Element == S.Input {
    currentValueRelay.receive(subscriber: subscriber)
  }
}

/// 잔액을 업데이트 해줄 수 있는 Publisher
public final class CurrentValuePublisher<Element>: ReadOnlyCurrentValuePublisher<Element> {
  typealias Output = Element
  typealias Failure = Never
  
  public override init(_ initialValue: Element) {
    super.init(initialValue)
  }
  
  public func send(_ value: Element) {
    currentValueRelay.accept(value)
  }
  
}
