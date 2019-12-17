//
//  StatefulViewComponents.swift
//  JXStatefulView
//
//  Created by jiaxin on 2019/12/16.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import Foundation
import UIKit

public class LoadingView: StateView {
    public lazy var stackView = UIStackView()
    public lazy var activityIndicatorView = UIActivityIndicatorView(style: .gray)
    public lazy var titleLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .white

        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.spacing = 15
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true

        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(activityIndicatorView)

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "Loading..."
        titleLabel.textColor = .black
        titleLabel.font = .systemFont(ofSize: 17)
        stackView.addArrangedSubview(titleLabel)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func didAppear() {
        activityIndicatorView.startAnimating()
    }

    public func didDisapper() {
        activityIndicatorView.stopAnimating()
    }
}

public class EmptyView: StateView {
    public lazy var stackView = UIStackView()
    public lazy var iconImageView = UIImageView()
    public lazy var titleLabel = UILabel()
    public lazy var tipsLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .white

        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.spacing = 15
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        stackView.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 30).isActive = true
        stackView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -30).isActive = true

        iconImageView.image = UIImage(named: "ic_statefulview_empty")
        stackView.addArrangedSubview(iconImageView)

        titleLabel.numberOfLines = 0
        titleLabel.textColor = .black
        titleLabel.font = .systemFont(ofSize: 17)
        addSubview(titleLabel)
        stackView.addArrangedSubview(titleLabel)

        tipsLabel.numberOfLines = 0
        tipsLabel.textColor = .gray
        tipsLabel.font = .systemFont(ofSize: 15)
        addSubview(tipsLabel)
        stackView.addArrangedSubview(tipsLabel)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

public class ErrorView: EmptyView {

    override init(frame: CGRect) {
        super.init(frame: frame)

        iconImageView.image = UIImage(named: "ic_statefulview_error")
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
