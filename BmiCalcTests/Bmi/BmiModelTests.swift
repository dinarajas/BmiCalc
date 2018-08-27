//
// Created by Dinesh on 27/08/18.
// Copyright (c) 2018 dinaraja.me. All rights reserved.
//

import Foundation
import XCTest
import RxTest
import RxSwift
import RxCocoa
@testable import BmiCalc

/*
  Test cases:
  ==========
  - emits bmi when view created
  - TODO: emits bmi when view restored
  - TODO: emits bmi when height changed
  - TODO: emits bmi when weight changed
*/
class BmiModelTests: XCTestCase {
  func testEmitsBmi_whenViewCreated() {
    // Setup
    let observer = TestScheduler(initialClock: 0)
      .createObserver(BmiState.self)
    let lifecycle = PublishRelay<MviLifecycle>()
    let disposeBag = DisposeBag()
    BmiModel
      .bind(lifecycle: lifecycle.asObservable())
      .subscribe(observer)
      .disposed(by: disposeBag)

    // Act
    lifecycle.accept(.created)

    // Assert
    let expectedEvents = [
      next(0, BmiState.initial())
    ]
    assertEvents(
      observer.events,
      expectedEvents
    )
  }

  private func assertEvents<T: MviState>(
    _ actualEvents: [Recorded<Event<T>>],
    _ expectedEvents: [Recorded<Event<T>>]
  ) {
    XCTAssertEqual(actualEvents, expectedEvents)
  }
}
