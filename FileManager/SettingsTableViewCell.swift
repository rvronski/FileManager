//
//  SettingsTableViewCell.swift
//  FileManager
//
//  Created by ROMAN VRONSKY on 30.12.2022.
//

import UIKit


class SettingsTableViewCell: UITableViewCell {

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var switcher: UISwitch = {
        let switcher = UISwitch()
        switcher.addTarget(self, action: #selector(didSwitchSort), for: .valueChanged)
        switcher.translatesAutoresizingMaskIntoConstraints = false
        return switcher
    }()

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupView()
        if UserDefaults.standard.bool(forKey: "SortFiles") {
            self.switcher.setOn(true, animated: true)
        } else {
            self.switcher.setOn(false, animated: true)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(text: String, switcherIsHidden: Bool) {
        self.switcher.isHidden = switcherIsHidden
        self.descriptionLabel.text = text
    }
    
    @objc private func didSwitchSort() {
        
        if self.switcher.isOn {
            print("ON")
            UserDefaults.standard.set(true, forKey: "SortFiles")
        } else {
            print("Off")
            UserDefaults.standard.set(false, forKey: "SortFiles")
            
        }
    }
    
    private func setupView() {
        self.contentView.addSubview(self.descriptionLabel)
        self.contentView.addSubview(self.switcher)
        
        NSLayoutConstraint.activate([
            
            self.descriptionLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            self.descriptionLabel.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 16),
            self.descriptionLabel.heightAnchor.constraint(equalToConstant: 30),
            self.descriptionLabel.widthAnchor.constraint(equalToConstant: 300),
            
            self.switcher.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            self.switcher.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -16)
        ])
    }
}
