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

class BmiViewController: MviController<BmiState> {
  @IBOutlet weak var weightLabel: UILabel!
  @IBOutlet weak var heightLabel: UILabel!

  @IBOutlet weak var heightSlider: UISlider!
  @IBOutlet weak var weightSlider: UISlider!
  
  @IBOutlet weak var bmiValueLabel: UILabel!

  private let defaultWeight = 40
  private let minimumWeight = 30
  private let maximumWeight = 200

  private let defaultHeight = 160
  private let minimumHeight = 130
  private let maximumHeight = 200

  private lazy var intentions = BmiIntentions(
    heightSlider.rx.value.asObservable(),
    minimumHeight,
    maximumHeight
  )

  override func bind(
    states: Observable<BmiState>,
    lifecycle: Observable<MviLifecycle>
  ) -> Observable<BmiState> {
    return BmiModel
      .bind(lifecycle, states, intentions)
  }

  override func emits(state: BmiState) {
    render(state: state)
  }
}

extension BmiViewController: BmiView {
  func showBmi(bmi: Double, height: Int, weight: Int) {
    bmiValueLabel.text = "\(bmi)"
    heightLabel.text = "\(height)"
    weightLabel.text = "\(weight)"
  }
}
