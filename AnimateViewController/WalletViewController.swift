//
//  WalletViewController.swift
//  PeerParking
//
//  Created by Munzareen Atique on 06/09/2019.
//  Copyright © 2019 Munzareen Atique. All rights reserved.
//

import UIKit
import NotificationCenter
class WalletViewController: UIViewController {

   // @IBOutlet weak var someView: UIView!
    @IBOutlet weak var blackView: UIView!
    
    var animator: UIViewPropertyAnimator?
    
    func createBottomView() {
        guard let sub = storyboard!.instantiateViewController(withIdentifier: "transactionVC") as? TransactionViewController else { return }
        self.addChild(sub)
        self.view.addSubview(sub.view)
        sub.didMove(toParent: self)
        
//        self.view.roundCorners(corners: <#T##UIRectCorner#>, radius: <#T##CGFloat#>)
//
//        self.view.
//        
//        sub.view.
        sub.view.roundCorners(corners: [.topLeft, .topRight], radius: 30.0)
        
       // sub.view.addShadow(location: .top, color: #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1), opacity: 1.0, radius: 25.0)
    
        sub.view.frame = CGRect(x: 15, y: view.frame.maxY-5, width: view.frame.width, height: view.frame.height)
        
        sub.view.layer.masksToBounds = false
        sub.minimize(completion: nil)
    }
    
    func subViewGotPanned(_ percentage: Int) {
        guard let propAnimator = animator else {
            animator = UIViewPropertyAnimator(duration: 3, curve: .linear, animations: {
                self.blackView.alpha = 1
//                self.someView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8).concatenating(CGAffineTransform(translationX: 0, y: -20))
            })
            animator?.startAnimation()
            animator?.pauseAnimation()
            return
        }
        propAnimator.fractionComplete = CGFloat(percentage) / 100
    }
    
    func receiveNotification(_ notification: Notification) {
    
        
        guard let percentage = notification.userInfo?["percentage"] as? Int else { return }
        if(percentage >= 90)
        {
            self.navigationController?.navigationBar.isHidden = true
        }
        else
        {
            self.navigationController?.navigationBar.isHidden = false
        }
        subViewGotPanned(percentage)
        print(percentage)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createBottomView()
        
        let name = NSNotification.Name(rawValue: "BottomViewMoved")
        NotificationCenter.default.addObserver(forName: name, object: nil, queue: nil, using: receiveNotification(_:))
    }
}
