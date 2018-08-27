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

  private let defaultHeight = 160
  private let minimumHeight = 130

  override func bind(
    states: Observable<BmiState>,
    lifecycle: Observable<MviLifecycle>
  ) -> Observable<BmiState> {
    return BmiModel
      .bind(lifecycle, states)
  }

  override func emits(state: BmiState) {
    render(state: state)
  }
}

extension BmiViewController: BmiView {
  func showBmi(bmi: Float, height: Int, weight: Int) {
    bmiValueLabel.text = "\(bmi)"
    heightLabel.text = "\(height)"
    weightLabel.text = "\(weight)"
  }
}
