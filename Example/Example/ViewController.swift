//
//  ViewController.swift
//  Example
//
//  Created by jiaxin on 2019/12/16.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import UIKit
import JXStatefulView

struct ViewProvider: StateViewProvider {
    func view(for state: ViewState) -> StateView? {
        switch state {
        case .loading:
            return LoadingView()
        case .error:
            let errorView = ErrorView()
            errorView.titleLabel.text = "Something wrong!"
            errorView.tipsLabel.text = "Tap to retry"
            return errorView
        case .empty:
            let emptyView = EmptyView()
            emptyView.titleLabel.text = "No content to show"
            emptyView.tipsLabel.text = "Tap to retry"
            return emptyView
        default:
            return nil
        }
    }
}

class ViewController: UIViewController {
    var dataSource = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.sv.viewProvider = ViewProvider()
        view.sv.hasContent = hasContent
        view.sv.retry = retry(state:)

        let btn = UIButton(type: .custom)
        btn.setTitle("transition to loading", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.addTarget(self, action: #selector(didBtnClick), for: .touchUpInside)
        view.addSubview(btn)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        btn.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true

        view.sv.transition(to: .loading)
    }

    @objc func didBtnClick() {
        view.sv.transition(to: .loading)
    }

    func hasContent() -> Bool {
        return !dataSource.isEmpty
    }

    func retry(state: ViewState) {
        switch state {
        case .loading:
            view.sv.transition(to: .error)
        case .error:
            view.sv.transition(to: .empty)
        case .empty:
            view.sv.transition(to: .loading)
        default:
            break
        }
    }
}

