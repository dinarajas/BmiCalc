//
// Created by Dinesh on 27/08/18.
// Copyright (c) 2018 dinaraja.me. All rights reserved.
//

import Foundation
import RxSwift

class BmiModel {
  static func bind(
    _ lifecycle: Observable<MviLifecycle>,
    _ states: Observable<BmiState>
  ) -> Observable<BmiState> {
    let createdLifecycleStates = lifecycle
      .filter { lifecycle in lifecycle == .created }
      .map { _ in BmiState.initial() }

    let restoredLifecycleStates = lifecycle
      .filter { lifecycle in lifecycle == .restored }
      .withLatestFrom(states)
      .map { (state: BmiState) in state.restored() }

    return Observable.merge(
      createdLifecycleStates,
      restoredLifecycleStates
    )
  }
}
