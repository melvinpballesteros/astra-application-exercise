//
//  BaselineViewController.swift
//  AstraApplicationExercise
//
//  Created by Melvin Ballesteros on 7/2/23.
//

import UIKit

class BaselineViewController: UIViewController {
    
    // MARK: - Controls
    lazy var activityIndicatorView: UIActivityIndicatorView = {
        let indicatorView = UIActivityIndicatorView(style: .whiteLarge)
        indicatorView.hidesWhenStopped = true
        indicatorView.stopAnimating()
        return indicatorView
    }()
    
    lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        label.textColor = .white
        label.sizeToFit()
        return label
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = AppColor.black
        tableView.separatorStyle = .none
        return tableView
    }()
    
    lazy var searchTextField: UITextField = {
        let textField = UITextField()
        textField.leftViewMode = .always
        textField.layer.cornerRadius = 25
        textField.backgroundColor = AppColor.grayBlack
        textField.textColor = .white
        
        let imageView = UIImageView(frame: CGRect(x: 12, y: 0, width: 20, height: 20))
        let image = UIImage(named: "search")
        imageView.image = image

        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 20 + 2 * 10, height: 16))
        containerView.addSubview(imageView)
        
        textField.leftView = containerView
        textField.leftViewMode = .always

        return textField
    }()

    // MARK: - View Delegates
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackground()
        setupViews()
        setupConstraints()
    }
    
    // MARK: - Setup
    private func setupViews() {
        view.setSubviewForAutoLayout(
            searchTextField,
            headerLabel,
            tableView,
            activityIndicatorView
        )
    }
    
    private func setupConstraints() {
        headerLabel.snp.makeConstraints { make in
            make.left.equalTo(25)
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(10)
        }
        
        searchTextField.snp.makeConstraints { make in
            make.top.equalTo(headerLabel.snp.bottom).offset(25)
            make.left.equalTo(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(50)
        }
        
        tableView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-80)
            make.top.equalTo(searchTextField.snp.bottom).offset(25)
        }
        
        activityIndicatorView.snp.makeConstraints { make in
            make.width.height.equalTo(50)
            make.centerX.centerY.equalToSuperview()
        }
    }
    
    private func setupBackground() {
        view.backgroundColor = AppColor.black
    }
    
    func activityIndicatorStart() {
        activityIndicatorView.startAnimating()
    }
    
    func activityIndicatorEnd() {
        activityIndicatorView.stopAnimating()
    }

}
