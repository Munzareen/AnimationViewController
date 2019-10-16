//
//  TransactionViewController.swift
//  PeerParking
//
//  Created by Munzareen Atique on 06/09/2019.
//  Copyright © 2019 Munzareen Atique. All rights reserved.
//

import UIKit
import NotificationCenter
class TransactionViewController: UIViewController , UIGestureRecognizerDelegate {
    @IBOutlet weak var navBarView: UIView!
    
    @IBOutlet weak var tblTransaction: UITableView!
    @IBOutlet weak var imgBottom: UIImageView!
    @IBOutlet weak var btnBack: UIButton!
    let closeThresholdHeight: CGFloat = 150
    let openThreshold: CGFloat = UIScreen.main.bounds.height - 250
    let closeThreshold = UIScreen.main.bounds.height - 120 // same value as closeThresholdHeight
    var panGestureRecognizer: UIPanGestureRecognizer?
    var animator: UIViewPropertyAnimator?
    
    private var lockPan = false
    
    override func viewDidLoad() {
        gotPanned(0)
        super.viewDidLoad()
        
        let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(respondToPanGesture))
        view.addGestureRecognizer(gestureRecognizer)
        gestureRecognizer.delegate = self
        panGestureRecognizer = gestureRecognizer
        
        
              

    
    
    }

   

    func gotPanned(_ percentage: Int) {
        if animator == nil {
            animator = UIViewPropertyAnimator(duration: 1, curve: .linear, animations: {
               // let scaleTransform = CGAffineTransform(scaleX: 1, y: 5).concatenating(CGAffineTransform(translationX: 0, y: 240))
                //self.navBarView.transform = scaleTransform
               // self.navBarView.alpha = 0
                if(percentage >= 50)
                {
                   self.navBarView.backgroundColor = #colorLiteral(red: 0.9763647914, green: 0.9765316844, blue: 0.9763541818, alpha: 1)
//                    self.navBarView.borderColor = #colorLiteral(red: 0.9136260152, green: 0.9137827754, blue: 0.9136161804, alpha: 0.9334837148)
//                    self.navBarView.borderWidth = 1
                  // self.imgBottom.isHidden = true
            self.btnBack.setImage(UIImage.init(named: "icon_up"), for: .normal )
                }
                else
                {
                    self.navBarView.backgroundColor = .white;
                  //  self.navBarView.borderColor = .white;
                    //self.imgBottom.isHidden = false
                    self.btnBack.setImage(UIImage.init(named: "icon_down"), for: .normal )
                }
            })
            animator?.isReversed = true
            animator?.startAnimation()
            animator?.pauseAnimation()
        }
        animator?.fractionComplete = CGFloat(percentage) / 100
        
        if(percentage >= 50)
        {
            self.btnBack.setImage(UIImage.init(named: "icon_down"), for: .normal )
        }
        else
        {
            self.btnBack.setImage(UIImage.init(named: "icon_up"), for: .normal )
        }
       // print(animator?.fractionComplete)
    }
    
    // MARK: methods to make the view draggable
    
    @objc func respondToPanGesture(recognizer: UIPanGestureRecognizer) {
        guard !lockPan else { return }
        if recognizer.state == .ended {
            let maxY = UIScreen.main.bounds.height - CGFloat(openThreshold)
            lockPan = true
            if maxY > self.view.frame.minY {
                maximize { self.lockPan = false }
            } else {
                minimize { self.lockPan = false }
            }
            return
        }
        let translation = recognizer.translation(in: self.view)
        moveToY(self.view.frame.minY + translation.y)
        recognizer.setTranslation(.zero, in: self.view)
    }
    
    func maximize(completion: (() -> Void)?) {
        UIView.animate(withDuration: 0.2, animations: {
            self.moveToY(0)
        }) { _ in
            if let completion = completion {
                completion()
            }
        }
    }
    
    func minimize(completion: (() -> Void)?) {
        UIView.animate(withDuration: 0.2, animations: {
            self.moveToY(self.closeThreshold)
        }) { _ in
            if let completion = completion {
                completion()
            }
        }
    }
    
    private func moveToY(_ position: CGFloat) {
        view.frame = CGRect(x: 0, y: position, width: view.frame.width, height: view.frame.height)
        
        let maxHeight = view.frame.height - closeThresholdHeight
        let percentage = Int(100 - ((position * 100) / maxHeight))
        
        gotPanned(percentage)
        
        let name = NSNotification.Name(rawValue: "BottomViewMoved")
        NotificationCenter.default.post(name: name, object: nil, userInfo: ["percentage": percentage])
    }
}
