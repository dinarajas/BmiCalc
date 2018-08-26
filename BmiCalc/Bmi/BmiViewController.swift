//
//  BmiViewController.swift
//  BmiCalc
//
//  Created by Dinesh IIINC on 26/08/18.
//  Copyright © 2018 dinaraja.me. All rights reserved.
//

import UIKit

class BmiViewController: UIViewController {
  @IBOutlet weak var weightLabel: UILabel!
  @IBOutlet weak var heightLabel: UILabel!

  @IBOutlet weak var heightSlider: UISlider!
  @IBOutlet weak var weightSlider: UISlider!
  
  @IBOutlet weak var bmiValueLabel: UILabel!

  private let defaultWeight = 40
  private let minimumWeight = 30

  private let defaultHeight = 160
  private let minimumHeight = 130
}
