//
// Created by Dinesh IIINC on 27/08/18.
// Copyright (c) 2018 dinaraja.me. All rights reserved.
//

import Foundation
import RxSwift

class BmiIntentions {
  private let heightChanges: Observable<SliderPayload>
  private let weightChanges: Observable<SliderPayload>

  init(
    _ heightChanges: Observable<SliderPayload>,
    _ weightChanges: Observable<SliderPayload>
  ) {
    self.heightChanges = heightChanges
    self.weightChanges = weightChanges
  }

  func height() -> Observable<Int> {
    return heightChanges
      .map { payload in payload.calculatedValue() }
  }

  func weight() -> Observable<Int> {
    return weightChanges
      .map { payload in payload.calculatedValue() }
  }
}
