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
    
    //MARK: - Vars
    var allChannels: [Channel] = []
    var subscribedChannels: [Channel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.largeTitleDisplayMode = .always
        self.title = "Channel"
        
        self.refreshControl = UIRefreshControl()
        self.tableView.refreshControl = self.refreshControl
        
        tableView.tableFooterView = UIView()
        
        downloadAllChannels()
        downloadSubscribedChannels()
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return channelSegmentOutlet.selectedSegmentIndex == 0 ? subscribedChannels.count : allChannels.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ChannelTableViewCell
        
        let channel = channelSegmentOutlet.selectedSegmentIndex == 0 ? subscribedChannels[indexPath.row] : allChannels[indexPath.row]
        
        cell.configure(channel: channel)
        
        return cell
    }
    
    //MARK: - TableView Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if channelSegmentOutlet.selectedSegmentIndex == 1 {
            showChannelView(channel: allChannels[indexPath.row])
        }else {
            //show chat view
            showChat(channel: subscribedChannels[indexPath.row])
        }
    }
    
    
    //MARK: - IBActions
    @IBAction func channelSegmentValueChanged(_ sender: Any) {
        tableView.reloadData()
    }
    
    
    //MARK: - Download Channels
    private func downloadAllChannels() {
        
        FirebaseChannelListener.shared.downloadAllChannels { (allChannels) in
            
            self.allChannels = allChannels
            
            if self.channelSegmentOutlet.selectedSegmentIndex == 1 {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    private func downloadSubscribedChannels() {
        
            FirebaseChannelListener.shared.downloadSubscribedChannels { (subscribedChannels) in
                
                self.subscribedChannels = subscribedChannels
                
                
                if self.channelSegmentOutlet.selectedSegmentIndex == 0 {
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
    }
    
    //MARK: - UIScrollViewDelegate
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        if self.refreshControl!.isRefreshing {
            self.downloadAllChannels()
            self.refreshControl!.endRefreshing()
        }
    }
    
    //MARK: - Navigation
    private func showChannelView(channel: Channel) {
        
        let channelVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "channelView") as! ChannelTableViewController
        channelVC.channel = channel
        
        self.navigationController?.pushViewController(channelVC, animated: true)
    }
    
    private func showChat(channel: Channel) {
        print("chat of channel",channel.name)
    }
    
}
