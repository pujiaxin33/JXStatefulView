//
//  JXStatefulViewDefines.swift
//  JXStatefulView
//
//  Created by jiaxin on 2019/12/16.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import Foundation
import UIKit

public protocol StatefulViewCompatible {
    var sv: StatefulViewWrapper { get }
}

extension UIView: StatefulViewCompatible {
    public var sv: StatefulViewWrapper {
        get { return associatedObject(self, key: &statefulViewWrapperKey) { return StatefulViewWrapper(backingView: self) } }
    }
}

public class StatefulViewWrapper {
    public var viewProvider: StateViewProvider?
    public var hasContent: (()->Bool)?
    public var retry: ((ViewState)->())?
    private let backingView: UIView
    private var currentView: StateView?
    private var currentState: ViewState?

    init(backingView: UIView) {
        self.backingView = backingView
    }

    public func startLoading() {
        transition(to: .loading)
    }

    public func endLoading(error: Error? = nil) {
        assert(hasContent != nil, "sv.hasContent can't be nil! You must set it.")
        if hasContent?() == true {
            transition(to: .none)
            return
        }
        if error != nil {
            transition(to: .error)
        }else {
            transition(to: .empty)
        }
    }

    public func transition(to state: ViewState) {
        if currentState == state {
            return
        }
        currentView?.didDisapper()
        currentView?.removeFromSuperview()
        currentState = state
        guard let view = viewProvider?.view(for: state) else {
            currentView = nil
            return
        }
        view.frame = backingView.bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        if associatedObject(view, key: &stateViewGestureKey) == nil {
            let tap = UITapGestureRecognizer(target: self, action: #selector(didTap(_:)))
            view.addGestureRecognizer(tap)
            setAssociatedObject(view, key: &stateViewGestureKey, value: tap)
        }
        backingView.addSubview(view)
        view.didAppear()
        currentView = view
    }

    @objc func didTap(_ gesture: UITapGestureRecognizer) {
        guard let state = currentState else {
            return
        }
        retry?(state)
    }
}

public enum ViewState {
    case none
    case loading
    case error
    case empty
}

public protocol StateViewLifecycle {
    func didAppear()
    func didDisapper()
}
public extension StateViewLifecycle {
    func didAppear() {}
    func didDisapper() {}
}
public typealias StateView = UIView & StateViewLifecycle

public protocol StateViewProvider {
    func view(for state: ViewState) -> StateView?
}

private var statefulViewWrapperKey: UInt8 = 0
private var stateViewGestureKey: UInt8 = 0
private func associatedObject<T: Any>(_ host: AnyObject, key: UnsafeRawPointer) -> T? {
    return objc_getAssociatedObject(host, key) as? T
}
private func associatedObject<T: Any>(_ host: AnyObject, key: UnsafeRawPointer, initial: () -> T) -> T {
    var value = objc_getAssociatedObject(host, key) as? T
    if value == nil {
        value = initial()
        objc_setAssociatedObject(host, key, value, .OBJC_ASSOCIATION_RETAIN)
    }
    return value!
}
private func setAssociatedObject(_ host: AnyObject, key: UnsafeRawPointer, value: Any?) {
    return objc_setAssociatedObject(host, key, value, .OBJC_ASSOCIATION_RETAIN)
}
