//
//  TransactionViewController.swift
//  PeerParking
//
//  Created by Munzareen Atique on 06/09/2019.
//  Copyright © 2019 Munzareen Atique. All rights reserved.
//

import UIKit
import NotificationCenter
class TransactionViewController: UIViewController , UIGestureRecognizerDelegate, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var navBarView: UIView!
    
    @IBOutlet weak var tblTransaction: UITableView!
    @IBOutlet weak var imgBottom: UIImageView!
    @IBOutlet weak var btnBack: UIButton!
    let closeThresholdHeight: CGFloat = 150
    let openThreshold: CGFloat = UIScreen.main.bounds.height - 200
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
        
        
                tblTransaction.dataSource =  self
                tblTransaction.delegate = self
        
                tblTransaction.register(UINib(nibName: "transactionCell", bundle: nil), forCellReuseIdentifier: "transactionCell")
                // Do any additional setup after loading the view.
      
        self.tblTransaction.register(UINib(nibName: "HeaderCell", bundle: nil), forCellReuseIdentifier: "headerCell")

    
    
    }

     func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    // return the number of rows in the specified section
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rowCount = 0
        switch (section) {
        case 0:
            rowCount = 2
        case 1:
            rowCount = 2
        case 2:
            rowCount = 2
        default:
            rowCount = 0
        }
        
        return rowCount
    }
    
   
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 70.0
    }
    // Header Cell
     func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let  headerCell = tableView.dequeueReusableCell(withIdentifier: "headerCell") as! HeaderCell
       
        
        
        
        return headerCell
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblTransaction.dequeueReusableCell(withIdentifier: "transactionCell") as! transactionCell
        
        cell.selectionStyle = .none
        return  cell;
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
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
                    self.navBarView.borderColor = #colorLiteral(red: 0.9136260152, green: 0.9137827754, blue: 0.9136161804, alpha: 0.9334837148)
                    self.navBarView.borderWidth = 1
                  // self.imgBottom.isHidden = true
            self.btnBack.setImage(UIImage.init(named: "icon_up"), for: .normal )
                }
                else
                {
                    self.navBarView.backgroundColor = .white;
                    self.navBarView.borderColor = .white;
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
