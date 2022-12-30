//
//  ViewController.swift
//  FileManager
//
//  Created by ROMAN VRONSKY on 30.12.2022.
//

import UIKit

class DocViewController: UIViewController, UINavigationControllerDelegate {
    
  
    
    private let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    
    private var content: [String] {
        do {
            var array =  try FileManager.default.contentsOfDirectory(atPath: path.path())
            if UserDefaults.standard.bool(forKey: "SortFiles") == true {
                array.sort(by: {$0>$1})
                
            } else if UserDefaults.standard.bool(forKey: "SortFiles") == false {
                array.sort(by: {$0<$1})
                
            }
            return array
        } catch {
            print(error)
            return[]
        }
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigationBar()
        self.setup()
        UserDefaults.standard.set(true, forKey: "isLogin")
        print("🍓🍓 \(String(describing: content))")
        print(UserDefaults.standard.bool(forKey: "SortFiles"))
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tableView.reloadData()
    }
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.register(DocTableViewCell.self, forCellReuseIdentifier: "photoCell")
        return tableView
    }()
    
    private func setupNavigationBar() {
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = path.lastPathComponent
        
        let button = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPhoto))
        button.tintColor = .blue
        navigationItem.rightBarButtonItem = button
    }
    
    
    @objc private func addPhoto() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true)
    }
    
    private func setup() {
        self.view.backgroundColor = .white
        self.view.addSubview(self.tableView)
        
        NSLayoutConstraint.activate([
            self.tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
        
        ])
        
    }
}
extension DocViewController: UITableViewDelegate, UITableViewDataSource {
   
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return content.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "photoCell", for: indexPath) as! DocTableViewCell
        
        cell.setup(photo: content[indexPath.row] )
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let pathForDel = path.path() + "/" + content[indexPath.row]
            try? FileManager.default.removeItem(atPath: pathForDel)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
               //
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension DocViewController: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let imageURL = info[.imageURL] as! URL
        let imageName = imageURL.lastPathComponent
        let toURL = path.appending(component: imageName )
        try? FileManager.default.copyItem(at: imageURL, to: toURL)
        tableView.reloadData()
        picker.dismiss(animated: true, completion: nil)
    }
    
    
}
    

