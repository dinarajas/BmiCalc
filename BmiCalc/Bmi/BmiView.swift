//
// Created by Dinesh on 27/08/18.
// Copyright (c) 2018 dinaraja.me. All rights reserved.
//

import Foundation

protocol BmiView {
  func render(state: BmiState)
  func showBmi(
    bmi: Double,
    height: Int,
    weight: Int
  )
}

extension BmiView {
  func render(state: BmiState) {
    showBmi(
      bmi: state.bmi,
      height: state.height,
      weight: state.weight
    )
  }
}
