//
// Created by Dinesh IIINC on 27/08/18.
// Copyright (c) 2018 dinaraja.me. All rights reserved.
//

import Foundation

struct BmiState: MviState {
  let height: Int
  let weight: Int
  let bmi: Float

  static func initial() -> BmiState {
    return BmiState(height: 160, weight: 40, bmi: 15.6)
  }

  static func ==(lhs: BmiState, rhs: BmiState) -> Bool {
    return lhs.height == rhs.height
      && lhs.weight == rhs.weight
      && lhs.bmi == rhs.bmi
  }
}
