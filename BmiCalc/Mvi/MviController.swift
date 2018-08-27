//
// Created by Dinesh on 27/08/18.
// Copyright (c) 2018 dinaraja.me. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MviController<T: MviState>: UIViewController {
  private var lastLifecycleEvent: MviLifecycle = .created
  private var disposables: CompositeDisposable!

  private lazy var lifecycleRelay = PublishRelay<MviLifecycle>()
  private lazy var statesRelay = BehaviorRelay<T?>(value: nil)

  // Methods to override
  func setup() {}
  func preBind() {}
  func bind(states: Observable<T>, lifecycle: Observable<MviLifecycle>) -> Observable<T> {
    fatalError("Bind(states:lifecycle:) method has not implemented")
  }
  func emitted(state: T) {
    fatalError("emits(state:) method has not implemented")
  }
  func postBind() {}
  func unBind() {}

  override final func viewDidLoad() {
    super.viewDidLoad()
    // Do any setup that is required before starts everything
    setup()

    // Setting up the lifecycle when the view is created.
    lastLifecycleEvent = .created
  }

  override final func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    // re-create the disposable every time when view is created/restored.
    disposables = CompositeDisposable()

    // Do work before binding starts
    preBind()

    // Prevents state relay from taking nil flow into the streams
    let statesObservable = statesRelay
      .filter { $0 != nil }
      .map { $0! }
      .distinctUntilChanged()
      .asObservable()

    /*
      Bind states & lifecycle with business logic reside in model and emits the state whenever
      user makes a change or lifecycle events kicked off.
    */
    disposables += bind(states: statesObservable, lifecycle: lifecycleRelay.asObservable())
      .observeOn(MainScheduler.asyncInstance)
      .subscribe { event in
        // Prevents nil state flowing through the observable streams
        if let state = event.element {
          self.statesRelay.accept(state)
          self.emitted(state: state)
        }
      }

    // Do any work after binding starts but before lifecycle starts
    postBind()

    // View to get called for created/restored lifecycle events
    lifecycleRelay.accept(lastLifecycleEvent)
  }

  override final func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    // Setting up the lifecycle when the view is stopped
    lastLifecycleEvent = .stopped

    // Do any work that requires clean up before going out of the screen
    unBind()

    // Dispose everything in the disposables when view goes out.
    disposables.dispose()
  }

  override final func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    // Setting up the lifecycle to restored in case user come back to the view.
    lastLifecycleEvent = .restored
  }
}
