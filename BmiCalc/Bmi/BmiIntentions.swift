//
// Created by Dinesh IIINC on 27/08/18.
// Copyright (c) 2018 dinaraja.me. All rights reserved.
//

import Foundation
import RxSwift

class BmiIntentions {
  private let heightChanges: Observable<Float>
  private let minHeight: Int
  private let maxHeight: Int

  init(
    _ heightChanges: Observable<Float>,
    _ minHeight: Int,
    _ maxHeight: Int
  ) {
    self.heightChanges = heightChanges
    self.minHeight = minHeight
    self.maxHeight = maxHeight
  }

  func height() -> Observable<Int> {
    return heightChanges
      .map { progress in self.minHeight + Int(progress * Float(self.maxHeight - self.minHeight)) }
  }
}
