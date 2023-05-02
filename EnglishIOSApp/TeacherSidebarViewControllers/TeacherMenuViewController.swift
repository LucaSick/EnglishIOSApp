//
//  MenuViewController.swift
//  EnglishIOSApp
//
//  Created by Lucas Gvasalia on 29.04.2023.
//

import UIKit

protocol TeacherMenuViewControllerDelegate: AnyObject {
    func didSelect(menuItem: TeacherMenuViewController.MenuOptions)
}

class TeacherMenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    weak var delegate: TeacherMenuViewControllerDelegate?
    
    @objc(tableView:cellForRowAtIndexPath:) func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = MenuOptions.allCases[indexPath.row].rawValue
        cell.backgroundColor = UIColor.red
        cell.contentView.backgroundColor = UIColor.red
        cell.textLabel?.textColor = UIColor.white
        cell.imageView?.image = UIImage(systemName: MenuOptions.allCases[indexPath.row].imageName)
        cell.imageView?.tintColor = UIColor.white
        return cell
    }
    
    @objc func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MenuOptions.allCases.count
    }
    
    @objc func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = MenuOptions.allCases[indexPath.row]
        delegate?.didSelect(menuItem: item)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: view.bounds.size.width, height: view.bounds.size.height)
    }
    
    
    
    enum MenuOptions: String, CaseIterable {
        case profile = "Профиль"
        case lessons = "Занятия"
        case settings = "Настройки"
        
        var imageName: String {
            switch self {
            case .profile:
                return "person.fill"
            case .lessons:
                return "book.fill"
            case .settings:
                return "gear"
            }
        }
    }
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()

    override func viewDidLoad() {
        tableView.backgroundColor = UIColor.red
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        view.backgroundColor = UIColor.red
        
    }
}
