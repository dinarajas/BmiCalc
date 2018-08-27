//
// Created by Dinesh on 27/08/18.
// Copyright (c) 2018 dinaraja.me. All rights reserved.
//

import Foundation
import RxSwift

extension CompositeDisposable {
  static func +=(lhs: CompositeDisposable, disposable: Disposable) {
    _ = lhs.insert(disposable)
  }
}
