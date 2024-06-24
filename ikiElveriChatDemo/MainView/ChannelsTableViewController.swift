//
//  ChannelsTableViewController.swift
//  ikiElveriChatDemo
//
//  Created by Tahir Atakan Can on 24.06.2024.
//

import UIKit

class ChannelsTableViewController: UITableViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var channelSegmentOutlet: UISegmentedControl!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.largeTitleDisplayMode = .always
        self.title = "Channel"
        
        tableView.tableFooterView = UIView()
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return UITableViewCell()
    }

    //MARK: - IBActions
    
    @IBAction func channelSegmentValueChanged(_ sender: Any) {
    }
    
    
    
}
