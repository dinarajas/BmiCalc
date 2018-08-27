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
    let createdLifecycleStates = lifecycleCreatedUseCase(lifecycle)
    let restoredLifecycleStates = lifecycleRestoredUseCase(lifecycle, states)
    let heightChangeStates = heightChangesUseCase(intentions, states)
    let weightChangeStates = weightChangesUseCase(intentions, states)

    return Observable.merge(
      createdLifecycleStates,
      restoredLifecycleStates,
      heightChangeStates,
      weightChangeStates
    )
  }

  private static func weightChangesUseCase(
    _ intentions: BmiIntentions,
    _ states: Observable<BmiState>
  ) -> Observable<BmiState> {
    return intentions
      .weight()
      .withLatestFrom(states) { (weight: Int, state: BmiState) -> BmiState in
        let bmi = calculateBmi(height: state.height, weight: weight)
        return state.weightChanged(weight: weight, bmi: bmi)
      }
  }

  private static func heightChangesUseCase(
    _ intentions: BmiIntentions,
    _ states: Observable<BmiState>
  ) -> Observable<BmiState> {
    return intentions
      .height()
      .withLatestFrom(states) { (height: Int, state: BmiState) -> BmiState in
        let bmi = calculateBmi(height: height, weight: state.weight)
        return state.heightChanged(height: height, bmi: bmi)
      }
  }

  private static func lifecycleRestoredUseCase(
    _ lifecycle: Observable<MviLifecycle>,
    _ states: Observable<BmiState>
  ) -> Observable<BmiState> {
    return lifecycle
      .filter { lifecycle in lifecycle == .restored }
      .withLatestFrom(states)
      .map { (state: BmiState) in state.restored() }
  }

  private static func lifecycleCreatedUseCase(
    _ lifecycle: Observable<MviLifecycle>
  ) -> Observable<BmiState> {
    return lifecycle
      .filter { lifecycle in lifecycle == .created }
      .map { _ -> BmiState in
        let defaultHeight = 160
        let defaultWeight = 40
        let bmi = calculateBmi(height: defaultHeight, weight: defaultWeight)
        return BmiState.initial(height: defaultHeight, weight: defaultWeight, bmi: bmi)
      }
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
