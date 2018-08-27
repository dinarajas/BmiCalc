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
  - emits bmi when view restored
  - emits bmi when height changed
  - TODO: emits bmi when weight changed
*/
class BmiModelTests: XCTestCase {
  private let initialState = BmiState.initial()
  private let minHeight = 130
  private let maxHeight = 200

  private var disposeBag: DisposeBag!
  private var observer: TestableObserver<BmiState>!

  private var lifecycle: PublishRelay<MviLifecycle>!
  private var states: PublishRelay<BmiState>!

  private var heightChanges: PublishRelay<Float>!

  private var intentions: BmiIntentions!

  override func setUp() {
    super.setUp()
    // Initialization
    disposeBag = DisposeBag()
    observer = TestScheduler(initialClock: 0)
      .createObserver(BmiState.self)

    lifecycle = PublishRelay()
    states = PublishRelay()

    heightChanges = PublishRelay()

    intentions = BmiIntentions(heightChanges.asObservable(), minHeight, maxHeight)

    // Setup
    BmiModel
      .bind(lifecycle.asObservable(), states.asObservable(), intentions)
      .do(onNext: { state in self.states.accept(state) })
      .subscribe(observer)
      .disposed(by: disposeBag)
  }

  func testEmitsBmi_whenViewCreated() {
    // Setup
    // Act
    lifecycle.accept(.created)

    // Assert
    let expectedEvents = [
      next(0, initialState)
    ]
    assertEvents(
      observer.events,
      expectedEvents
    )
  }

  func testEmitsBmi_whenViewRestored() {
    // Setup
    // Act
    lifecycle.accept(.created)
    lifecycle.accept(.restored)

    // Assert
    let expectedEvents = [
      next(0, initialState),
      next(0, initialState.restored())
    ]
    assertEvents(
      observer.events,
      expectedEvents
    )
  }

  func testEmitsBmi_whenHeightChanged() {
    // Setup
    // Act
    lifecycle.accept(.created)
    heightChanges.accept(0.7)

    // Assert
    let expectedEvents = [
      next(0, initialState),
      next(0, initialState.heightChanged(
        height: 179,
        bmi: BmiModel.calculateBmi(height: 179, weight: initialState.weight))
      )
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
