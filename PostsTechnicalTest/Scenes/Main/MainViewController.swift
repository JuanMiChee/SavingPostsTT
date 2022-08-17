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
    var favoritesArray = [PostViewModel]()
    
    
    
    var segmentedControlState = 0
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navBar: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.handleViewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(addTapped))
        DeleteAllButton.addTarget(self, action: #selector(deleteAllButton), for: .touchUpInside)
    }
    @objc func addTapped(){
        presenter.handleViewDidLoad()
        tableView.reloadData()
    }
    
    //@IBAction func changeToFavoritesScreen(_ sender: UISegmentedControl) {
    @IBAction func starredPosts(_ sender: UISegmentedControl){
        if sender.selectedSegmentIndex == 0{
            segmentedControlState = 0
            tableView.reloadData()

        }else if sender.selectedSegmentIndex == 1{
            segmentedControlState = 1
            tableView.reloadData()
        }
    }
    
    
    @objc func deleteAllButton(_ sender: Any) {
        // create the alert
        let alert = UIAlertController(title: "Deleting All Posts", message: "If you continue, you will delete all your favorite posts", preferredStyle: UIAlertController.Style.alert)
        
        // add the actions (buttons)
        alert.addAction(UIAlertAction(title: "Continue", style: UIAlertAction.Style.default, handler: { action in
            if self.segmentedControlState == 0{
                self.postsArray = []
            }else if self.segmentedControlState == 1{
                self.favoritesArray = []
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
    
    func display(result:[PostViewModel], favorites: [PostViewModel]) {
        postsArray = result
        favoritesArray = favorites
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

extension MainViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("touched cell")
        let vc = storyboard?.instantiateViewController(identifier: "DetailViewController") as! DetailViewController
        
        if segmentedControlState == 0 {
            vc.postViewModel = postsArray[indexPath.row]
        }else if segmentedControlState == 1 {
            vc.postViewModel = favoritesArray[indexPath.row]
        }
        vc.toReciveArrayStarred = favoritesArray
        vc.mainVC = self
        //print(postsArray[indexPath.row])
        self.navigationController?.pushViewController(vc, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
}

extension MainViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if segmentedControlState == 0 {
            return postsArray.count
        }else{
            return favoritesArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        var viewModel: PostViewModel?
        

        if segmentedControlState == 0 {
            viewModel = postsArray[indexPath.row]
        }else if segmentedControlState == 1 {
            viewModel = favoritesArray[indexPath.row]
        }
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
