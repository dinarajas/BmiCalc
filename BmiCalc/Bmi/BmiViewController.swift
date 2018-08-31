//
//  BmiViewController.swift
//  BmiCalc
//
//  Created by Dinesh on 26/08/18.
//  Copyright © 2018 dinaraja.me. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

struct SliderPayload {
  let min: Int
  let max: Int
  let progress: Float

  func actualValue() -> Int {
    return min + Int(progress * Float(max - min))
  }
}

class BmiViewController: MviController<BmiState> {
  @IBOutlet weak var heightSlider: UISlider!
  @IBOutlet weak var weightSlider: UISlider!
  @IBOutlet weak var weightLabel: UILabel!
  @IBOutlet weak var heightLabel: UILabel!
  @IBOutlet weak var bmiValueLabel: UILabel!

  private let bmiNumberFormatter: NumberFormatter = {
    let numberFormatter = NumberFormatter()
    numberFormatter.maximumFractionDigits = 1
    numberFormatter.minimumFractionDigits = 1
    return numberFormatter
  }()

  private let minWeight = 30
  private let maxWeight = 200

  private let minHeight = 130
  private let maxHeight = 200

  private lazy var weightChanges = weightSlider.rx
    .value
    .map { progress in
      SliderPayload(min: self.minWeight, max: self.maxWeight, progress: progress)
    }

  private lazy var heightChanges = heightSlider.rx
    .value
    .map { progress in
      SliderPayload(min: self.minHeight, max: self.maxHeight, progress: progress)
    }

  private lazy var intentions = BmiIntentions(heightChanges, weightChanges)

  override func bind(
    states: Observable<BmiState>,
    lifecycle: Observable<MviLifecycle>
  ) -> Observable<BmiState> {
    return BmiModel
      .bind(lifecycle, states, intentions)
  }

  override func emitted(state: BmiState) {
    render(state: state)
  }
}

extension BmiViewController: BmiView {
  func showBmi(bmi: Double, height: Int, weight: Int) {
    let bmiString = bmiNumberFormatter
      .string(from: NSNumber(value: bmi))
    bmiValueLabel.text = bmiString

    heightLabel.text = "\(height)"
    weightLabel.text = "\(weight)"
  }
}
