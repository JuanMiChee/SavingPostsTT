//
//  DetailViewController.swift
//  PostsTechnicalTest
//
//  Created by Juan Harrington on 10/08/22.
//

import Foundation
import UIKit

class DetailViewController: UIViewController{

    var postViewModel: PostViewModel!
    var userViewModel: UserViewModel!
    var emptyViewModel: PostViewModel?
    
    private lazy var presenter: DetailPresenter = {
        let fetchData = FetchData()
        let fetchCoreData = CoreDataStorage()
        let presenter = DetailViewPresenter(fetchData: fetchData, fetchCoreData: fetchCoreData)
        presenter.view = self
        return presenter
    }()
    
    private var postComments = [CommentViewModel]()
    
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var tableViewTwo: UITableView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var websideLabel: UILabel!
    @IBOutlet weak var starButton: UIBarButtonItem!
    
    var toReciveArrayStarred: [PostViewModel] = []
    
    var starButtonImageName: String = "star"
    
    
    var mainVC: MainViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewTwo.delegate = self
        tableViewTwo.dataSource = self
        descriptionLabel.text = postViewModel.body
        toReciveArrayStarred.append(postViewModel)
        
        presenter.handleViewDidLoad(postId: postViewModel.id, userId: postViewModel.userId)

        if isItFavorite(){
            starButton.image = UIImage(systemName: "star.fill")
        }else{
            starButton.image = UIImage(systemName: "star")
        }
    }
    
   
    func isItFavorite() -> Bool{
        
        let isFavorite = mainVC?.favoritesArray.contains(where: { (viewModel) -> Bool in
            if viewModel.id == postViewModel!.id {
                //presenter.handleFavorites(post: postViewModel)
                return true
            }else{
                //presenter.handleFavorites(post: viewModel)
                return false
            }
        })
        
        if isFavorite == true{
            return true
        }else{
            return false
        }
    }

    @IBAction func starButtonAction(_ sender: Any) {
        if isItFavorite() == true{
            
            starButton.image = UIImage(systemName: "star")
            mainVC?.favoritesArray.removeAll(where: { (post) -> Bool in
                if post.id == postViewModel.id{
                    return true
                }else{
                    
                    return false
                }
            })
        }else{
            presenter.handleFavorites(post: postViewModel, comments: postComments, user: userViewModel)
            starButton.image = UIImage(systemName: "star.fill")
            mainVC?.favoritesArray = toReciveArrayStarred
        }
    }
}

extension DetailViewController: DetailView{
    
    func display(user: UserViewModel, favoriteComments: [CommentViewModel]) {
        userViewModel = user
        postComments = favoriteComments
        tableViewTwo.reloadData()
        DispatchQueue.main.async {
            self.nameLabel.text = user.name
            self.emailLabel.text = user.email
            self.phoneLabel.text = user.phone
            self.websideLabel.text = user.website
        }
    }
    
    func displayAlert(message: String) {
        print(message)
    }
    
    func display(result:[CommentViewModel]){
        postComments = result
        DispatchQueue.main.async {
            self.tableViewTwo.reloadData()
        }
    }
    
//    func userDisplay(result:[UserViewModel]){
//        userViewModel = result
//        DispatchQueue.main.async {
//        }
//    }
}

extension DetailViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("touched cell")
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension DetailViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        postComments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellTwo", for: indexPath)
        let viewModel = postComments[indexPath.row]
        cell.textLabel?.text = viewModel.body
        cell.textLabel?.numberOfLines = 0
        return cell
    }
}
