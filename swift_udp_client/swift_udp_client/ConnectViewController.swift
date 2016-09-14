//
//  ConnectViewController.swift
//  swift_udp_client
//
//  Created by Matz Persson on 14/09/2016.
//  Copyright © 2016 Headstation. All rights reserved.
//

import UIKit

class ConnectViewController: UIViewController {

    @IBOutlet weak var broadcastAddress: UITextField!
    @IBOutlet weak var broadcastPort: UITextField!
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(false)
        
        broadcastAddress.text = defaults.stringForKey("broadcastAddress")
        broadcastPort.text = defaults.stringForKey("broadcastPort")
        
    }
    

    @IBAction func connectButton(sender: UIButton) {
        
        if broadcastAddress.text! == "" || broadcastPort.text! == ""  {

            let alert = UIAlertController(title: "Oops", message: "Need both IP Address and Port...", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "No worries, got it", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            
            
        } else {

            defaults.setObject(broadcastAddress.text!, forKey: "broadcastAddress")
            defaults.setObject(broadcastPort.text!, forKey: "broadcastPort")

            self.performSegueWithIdentifier("connectedSegue", sender: self)
        
        }
        
    }

}

