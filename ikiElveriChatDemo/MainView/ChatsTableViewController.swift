//
//  ChatsTableViewController.swift
//  ikiElveriChatDemo
//
//  Created by Tahir Atakan Can on 9.06.2024.
//

import UIKit

class ChatsTableViewController: UITableViewController {

    //MARK: - Vars
    var allRecents:[RecentChat] = []
    var filteredRecents:[RecentChat] = []
    
    let searchController = UISearchController(searchResultsController: nil)
    
    //MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        downloadRecentChats()
        setupSearchController()
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return searchController.isActive ? filteredRecents.count : allRecents.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! RecentTableViewCell

        let recent = searchController.isActive ? filteredRecents[indexPath.row] : allRecents[indexPath.row]
        
        cell.configure(recent: allRecents[indexPath.row])
        return cell
    }
    
    //MARK: - Download Chats
    
    private func downloadRecentChats(){
        
        FirebaseRecentListener.shared.downloadRecentChatsFromFireStore { (allChats) in
            
            self.allRecents = allChats
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    //MARK: - Setup Controller
    private func setupSearchController(){
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search User"
        searchController.searchResultsUpdater = self
        definesPresentationContext = true
    }
    
    private func filteredContentForSearchText(searchText: String) {
        
        filteredRecents = allRecents.filter({ (recent) -> Bool in
            return recent.receiverName.lowercased().contains(searchText.lowercased())
        })
        tableView.reloadData()
    }
    
}



extension ChatsTableViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        filteredContentForSearchText(searchText: searchController.searchBar.text!)
    }
    
}
