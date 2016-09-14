//
//  LoggerTableViewController.swift
//  swift_udp_client
//
//  Created by Matz Persson on 14/09/2016.
//  Copyright © 2016 Headstation. All rights reserved.
//

// Works together with UDP Broadcaster on https://github.com/matzpersson/udp-broadcasting.git

import UIKit
import CocoaAsyncSocket

class LoggerTableViewController: UITableViewController, GCDAsyncUdpSocketDelegate {

    let defaults = NSUserDefaults.standardUserDefaults()
    
    var socket : GCDAsyncUdpSocket?
    var broadcastPort: UInt16 = 54545
    var broadcastAddress: String = ""
    var logCount = 1
    var log: [[String]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 160.0
        
        broadcastAddress = defaults.stringForKey("broadcastAddress")!
        broadcastPort = UInt16( defaults.integerForKey("broadcastPort") )
 
        let socket = GCDAsyncUdpSocket(delegate: self, delegateQueue: dispatch_get_main_queue())
        
        // -- Enable IP4 only
        socket.setIPv6Enabled(false)
        socket.setIPv4Enabled(true)
        
        do {
            
            try socket.bindToPort(broadcastPort)
            try socket.enableBroadcast(true)
            try socket.beginReceiving()
            
            log.append( ["Started", "Waiting to receive from " + broadcastAddress + ":" + String(broadcastPort) ] )
            self.tableView.reloadData()
            
        } catch _ as NSError {
            
            print("Issue with setting up listener")
        
        }

    }

    func udpSocket(sock: GCDAsyncUdpSocket!, didReceiveData data: NSData!, fromAddress address: NSData!, withFilterContext filterContext: AnyObject!) {
        
        var host: NSString?
        var port1: UInt16 = 0
        GCDAsyncUdpSocket.getHost(&host, port: &port1, fromAddress: address)
        
        let message = NSString(data: data, encoding: NSUTF8StringEncoding) as! String

        log.append( [String(host!), message ] )
        self.tableView.reloadData()
        
    }
    

    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return log.count
    }

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "UDP Receiver Log"
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("logCell", forIndexPath: indexPath)

        let idx = indexPath.row
        cell.textLabel!.text = log[idx][0] as String
        cell.detailTextLabel!.text = log[idx][1] as String
        
        return cell
        
    }
    

}
