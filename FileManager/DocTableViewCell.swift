//
//  DocTableViewCell.swift
//  FileManager
//
//  Created by ROMAN VRONSKY on 30.12.2022.
//

import UIKit

class DocTableViewCell: UITableViewCell {

    private lazy var descriptionLabel: UILabel = {
           let label = UILabel()
           label.translatesAutoresizingMaskIntoConstraints = false
           return label
       }()

       private lazy var photoView: UIImageView = {
          let imageView = UIImageView()
           imageView.translatesAutoresizingMaskIntoConstraints = false
           imageView.clipsToBounds = true
           imageView.contentMode = .scaleAspectFit
           return imageView
       }()
       
       override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
           super .init(style: style, reuseIdentifier: reuseIdentifier)
           self.setupView()
       }
       
       required init?(coder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }
       
       func setup(photo: String) {
           let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].path() + "/" + photo
           self.photoView.image = UIImage(contentsOfFile: url)
       }
       
       private func setupView() {
           self.contentView.addSubview(photoView)
           
           NSLayoutConstraint.activate([
               self.photoView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 16),
               self.photoView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor),
               self.photoView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor),
               self.photoView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -16),
               self.photoView.heightAnchor.constraint(equalToConstant: 200),
               
              
           ])
       }
   }
