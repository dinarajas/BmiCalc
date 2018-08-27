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

  private let weightChanges: Observable<Float>
  private let minWeight: Int
  private let maxWeight: Int

  init(
    _ heightChanges: Observable<Float>,
    _ minHeight: Int,
    _ maxHeight: Int,
    _ weightChanges: Observable<Float>,
    _ minWeight: Int,
    _ maxWeight: Int
  ) {
    self.heightChanges = heightChanges
    self.minHeight = minHeight
    self.maxHeight = maxHeight

    self.weightChanges = weightChanges
    self.minWeight = minWeight
    self.maxWeight = maxWeight
  }

  func height() -> Observable<Int> {
    return heightChanges
      .map { progress in self.minHeight + Int(progress * Float(self.maxHeight - self.minHeight)) }
  }

  func weight() -> Observable<Int> {
    return weightChanges
      .map { progress in self.minWeight + Int(progress * Float(self.maxWeight - self.minWeight)) }
  }
}
