//
// Created by Dinesh IIINC on 27/08/18.
// Copyright (c) 2018 dinaraja.me. All rights reserved.
//

import Foundation
import RxSwift

class BmiModel {
  static func bind(
    lifecycle: Observable<MviLifecycle>
  ) -> Observable<BmiState> {
    let createdLifecycleStates = lifecycle
      .filter { lifecycle in lifecycle == .created }
      .map { _ in BmiState.initial() }

    return createdLifecycleStates
  }
}
