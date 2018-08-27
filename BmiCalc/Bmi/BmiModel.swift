//
// Created by Dinesh on 27/08/18.
// Copyright (c) 2018 dinaraja.me. All rights reserved.
//

import Foundation
import RxSwift

class BmiModel {
  static func bind(
    _ lifecycle: Observable<MviLifecycle>,
    _ states: Observable<BmiState>,
    _ intentions: BmiIntentions
  ) -> Observable<BmiState> {
    let createdLifecycleStates = lifecycle
      .filter { lifecycle in lifecycle == .created }
      .map { _ -> BmiState in
        let defaultHeight = 160
        let defaultWeight = 40
        let bmi = calculateBmi(height: defaultHeight, weight: defaultWeight)
        return BmiState.initial(height: defaultHeight, weight: defaultWeight, bmi: bmi)
      }

    let restoredLifecycleStates = lifecycle
      .filter { lifecycle in lifecycle == .restored }
      .withLatestFrom(states)
      .map { (state: BmiState) in state.restored() }

    let heightChangeStates = intentions
      .height()
      .withLatestFrom(states) { (height: Int, state: BmiState) -> BmiState in
        let bmi = calculateBmi(height: height, weight: state.weight)
        return state.heightChanged(height: height, bmi: bmi)
      }

    let weightChangeStates = intentions
      .weight()
      .withLatestFrom(states) { (weight: Int, state: BmiState) -> BmiState in
        let bmi = calculateBmi(height: state.height, weight: weight)
        return state.weightChanged(weight: weight, bmi: bmi)
      }

    return Observable.merge(
      createdLifecycleStates,
      restoredLifecycleStates,
      heightChangeStates,
      weightChangeStates
    )
  }

  static func calculateBmi(
    height: Int,
    weight: Int
  ) -> Double {
    let heightInMeters = Double(height)/100
    let bmi = Double(weight) / (heightInMeters * heightInMeters)
    return bmi
  }
}
