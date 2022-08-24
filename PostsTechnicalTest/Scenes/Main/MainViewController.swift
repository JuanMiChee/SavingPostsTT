//
//  ViewController.swift
//  PostsTechnicalTest
//  Created by Juan Harrington on 9/08/22.
//

import UIKit
import Foundation

class MainViewController: UIViewController {
    
    
    
    
    private lazy var presenter: MainPresenter = {
        let fetchData = FetchData()
        let fetchCoreData = CoreDataStorage()
        
        let presenter = MainViewPresenter(fetchData: fetchData, fetchCoreData: fetchCoreData)
        presenter.view = self
        return presenter
        
    }()

    @IBOutlet weak var DeleteAllButton: UIButton!
    
    var postsArray = [PostViewModel]()
    var tableViewArray = [PostViewModel]()
    var segmentedControlState = 0
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navBar: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.handleViewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(addTapped))
        DeleteAllButton.addTarget(self, action: #selector(deleteAllButton), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.handleViewDidLoad()
    }
    
    @objc func addTapped(){
        presenter.handleViewDidLoad()
        tableView.reloadData()
    }
    
    @IBAction func starredPosts(_ sender: UISegmentedControl){
        if sender.selectedSegmentIndex == 0{
            segmentedControlState = 0
            tableViewArray = postsArray.sorted(by: { (parameterOne, parameterTwo) in
                parameterOne.isFavorite || parameterOne.title < parameterTwo.title
            })
            tableView.reloadData()
            
        }else if sender.selectedSegmentIndex == 1{
            segmentedControlState = 1
            tableViewArray = postsArray.filter({ (post) -> Bool in
                post.isFavorite
            })
            tableView.reloadData()
            
        }
    }
    
    @objc func deleteAllButton(_ sender: Any) {
        // create the alert
        let alert = UIAlertController(title: "Deleting All Posts", message: "If you continue, you will delete all your favorite posts", preferredStyle: UIAlertController.Style.alert)
        
        // add the actions (buttons)
        alert.addAction(UIAlertAction(title: "Continue", style: UIAlertAction.Style.default, handler: { action in
            if self.segmentedControlState == 0{
                self.tableViewArray = []
            }else if self.segmentedControlState == 1{
                self.tableViewArray = []//favoritesArray = []
            }
            self.tableView.reloadData()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: {action in
            
        }))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    
}

extension MainViewController: View{
    
    
    func displayAlert(message: String) {
        print("error corred \(message)")
    }
    
    func display(result:[PostViewModel]){
        postsArray = result
        tableViewArray = postsArray
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

extension MainViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("touched cell")
        print(tableViewArray[indexPath.row].id)
        tableView.reloadData()
        let vc = storyboard?.instantiateViewController(identifier: "DetailViewController") as! DetailViewController
        vc.postViewModel = tableViewArray[indexPath.row]
        vc.mainVC = self
        self.navigationController?.pushViewController(vc, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
}

extension MainViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        var viewModel: PostViewModel?
        
        viewModel = tableViewArray[indexPath.row]
        
        cell.textLabel?.text = viewModel?.title
        cell.textLabel?.numberOfLines = 0
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            postsArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .right)
        }else if editingStyle == .insert {
            print("Style Insert")
        }
    }
}
