//
//  MailboxViewController.swift
//  CodePathMailbox
//
//  Created by Jonlin Pei on 2/20/15.
//  Copyright (c) 2015 Jonlin Pei. All rights reserved.
//

import UIKit

class MailboxViewController: UIViewController, UIScrollViewDelegate, UIGestureRecognizerDelegate {

    @IBOutlet weak var feedImageScrollView: UIScrollView!
    
    @IBOutlet weak var feedImageView: UIImageView!
    
    
    @IBOutlet weak var messageContainerView: UIView!
    
    @IBOutlet weak var messageImageView: UIImageView!
    
    @IBOutlet weak var rescheduleImageView: UIImageView!
    @IBOutlet weak var listImageView: UIImageView!
    
    @IBOutlet weak var leftSwipeIconsImageView: UIView!
    @IBOutlet weak var laterIconImageView: UIImageView!
    @IBOutlet weak var listIconImageView: UIImageView!
    @IBOutlet weak var rightSwipeIconsImageView: UIView!
    @IBOutlet weak var deleteIconImageView: UIImageView!
    @IBOutlet weak var archiveIconImageView: UIImageView!
    @IBOutlet weak var mailBoxPageView: UIView!
    
    
    
    
    
    var scale: CGFloat! = 1
    var rotate: CGFloat! = 0
    var messageOriginalCenter: CGPoint!
    var messageStartingCenter: CGPoint!
    var mailBoxPageViewOriginalCenter: CGPoint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        feedImageScrollView.delegate = self
        feedImageScrollView.contentSize = CGSize(width: 320, height: 1500)
        messageOriginalCenter = messageImageView.center
        messageContainerView.backgroundColor = UIColor(red: 232/255, green: 232/255, blue: 232/255, alpha: 1)
        mailBoxPageViewOriginalCenter = mailBoxPageView.center
        
        // reschedule and list views
        rescheduleImageView.alpha = 0.0
        listImageView.alpha = 0.0
        
        // message swipe icons
        laterIconImageView.alpha = 0.0
        listIconImageView.alpha = 0.0
        deleteIconImageView.alpha = 0.0
        archiveIconImageView.alpha = 0.0
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func didPanMessage(sender: AnyObject) {

        var location = sender.locationInView(view)
        var translation = sender.translationInView(view)
        var velocity = sender.velocityInView(view)
        var offset = messageImageView.center.x - messageOriginalCenter.x
        
        println("panning message")
        println("Velocity: \(velocity)")
        println("Offest: \(offset)")
        println("translation: \(translation)")
        println("leftSwipeIconsImageView Center X: \(leftSwipeIconsImageView.center.x)")
        println("rightSwipeIconsImageView Center X: \(rightSwipeIconsImageView.center.x)")

        
        // change background color
        if (offset <= -260.0) {
            messageContainerView.backgroundColor = UIColor(red: 222/255, green: 184/255, blue: 135/255, alpha: 1)
        } else if ((offset > -260) && (offset <= -60)) {
            messageContainerView.backgroundColor = UIColor(red: 255/255, green: 246/255, blue: 143/255, alpha: 1)
        } else if ((offset > -60) && (offset <= 60)) {
            messageContainerView.backgroundColor = UIColor(red: 232/255, green: 232/255, blue: 232/255, alpha: 1)
        } else if ((offset > 60) && (offset <= 260)) {
            messageContainerView.backgroundColor = UIColor(red: 0/255, green: 201/255, blue: 87/255, alpha: 1)
        } else if (offset > 260) {
            messageContainerView.backgroundColor = UIColor(red: 220/255, green: 20/255, blue: 60/255, alpha: 1)
        }
        
        // change and move icon
        if (offset <= -260.0) {
            self.laterIconImageView.alpha = 0.0
            self.listIconImageView.alpha = 1.0
            self.leftSwipeIconsImageView.center.x = 287.5 + 60 + offset
        } else if ((offset > -260) && (offset <= -60)) {
            self.laterIconImageView.alpha = 1.0
            self.listIconImageView.alpha = 0.0
            self.leftSwipeIconsImageView.center.x = 287.5 + 60 + offset
        } else if ((offset > -60) && (offset <= 60)) {
            self.deleteIconImageView.alpha = (offset/60)*1.0
            self.laterIconImageView.alpha = -(offset/60)*1.0
        } else if ((offset > 60) && (offset <= 260)) {
            self.deleteIconImageView.alpha = 0.0
            self.archiveIconImageView.alpha = 1.0
            self.rightSwipeIconsImageView.center.x = 32.5 - 60 + offset
        } else if (offset > 260) {
            self.deleteIconImageView.alpha = 1.0
            self.archiveIconImageView.alpha = 0.0
            self.rightSwipeIconsImageView.center.x = 32.5 - 60 + offset
        }
        
        // transform
        if (sender.state == UIGestureRecognizerState.Began){
            scale = 1.0
            leftSwipeIconsImageView.center.x = 287.5
            rightSwipeIconsImageView.center.x = 32.5
            laterIconImageView.alpha = 0
            archiveIconImageView.alpha = 0
            listIconImageView.alpha = 0
            deleteIconImageView.alpha = 0
            transformMessage()
            
        } else if (sender.state == UIGestureRecognizerState.Changed){
            messageImageView.center = CGPoint(x: messageOriginalCenter.x + translation.x, y: messageOriginalCenter.y)
            

            
        } else if (sender.state == UIGestureRecognizerState.Ended){
            scale = 1.0
            transformMessage()
            
            // snap and transition
            if (offset <= -260.0) {
                UIView.animateWithDuration(0.2, animations: { () -> Void in
                    self.messageImageView.center.x = -320
                    self.listImageView.alpha = 1.0
                    })
            } else if ((offset > -260) && (offset <= -60)) {
                UIView.animateWithDuration(0.5, animations: { () -> Void in
                    self.messageImageView.center.x = -320
                    self.rescheduleImageView.alpha = 1.0
                })
            } else if ((offset > -60) && (offset <= 60)) {
                UIView.animateWithDuration(0.5, animations: { () -> Void in
                    self.messageImageView.center.x = 160
                })
            } else if ((offset > 60) && (offset <= 260)) {
                UIView.animateWithDuration(0.5, animations: { () -> Void in
                    self.messageImageView.center.x = 160
                    })  { (finished: Bool) -> Void in
                        UIView.animateWithDuration(0.5, delay: 0, options: nil, animations: { () -> Void in
                            self.feedImageView.center.y = self.feedImageView.center.y - 86
                            }) { (finished: Bool) -> Void in
                                UIView.animateWithDuration(0.5, delay: 1, options: nil, animations: { () -> Void in
                                    self.feedImageView.center.y = self.feedImageView.center.y + 86
                                    }) { (Bool) -> Void in
                                }
                        }
                }
            } else if (offset > 260) {
                UIView.animateWithDuration(0.5, animations: { () -> Void in
                    self.messageImageView.center.x = 160
                    })  { (finished: Bool) -> Void in
                        UIView.animateWithDuration(0.5, delay: 0, options: nil, animations: { () -> Void in
                            self.feedImageView.center.y = self.feedImageView.center.y - 86
                            }) { (finished: Bool) -> Void in
                                UIView.animateWithDuration(0.5, delay: 1, options: nil, animations: { () -> Void in
                                    self.feedImageView.center.y = self.feedImageView.center.y + 86
                                    }) { (Bool) -> Void in
                                }
                        }
                }
            }
        }
    }
    
    
    @IBAction func didTapListImage(sender: AnyObject) {
        
        UIView.animateWithDuration(0.5, delay: 0, options: nil, animations: { () -> Void in
            self.listImageView.alpha = 0.0
            self.messageImageView.center.x = 160
            }) { (finished: Bool) -> Void in
                UIView.animateWithDuration(0.5, delay: 0, options: nil, animations: { () -> Void in
                    self.feedImageView.center.y = self.feedImageView.center.y - 86
                    }) { (finished: Bool) -> Void in
                        UIView.animateWithDuration(0.5, delay: 1, options: nil, animations: { () -> Void in
                            self.feedImageView.center.y = self.feedImageView.center.y + 86
                            }) { (Bool) -> Void in
                            }
                    }
            }
    }
    
    @IBAction func didTapRescheduleImage(sender: UITapGestureRecognizer) {
        UIView.animateWithDuration(0.5, delay: 0, options: nil, animations: { () -> Void in
            self.rescheduleImageView.alpha = 0.0
            self.messageImageView.center.x = 160
            }) { (finished: Bool) -> Void in
                UIView.animateWithDuration(0.5, delay: 0, options: nil, animations: { () -> Void in
                    self.feedImageView.center.y = self.feedImageView.center.y - 86
                    }) { (finished: Bool) -> Void in
                        UIView.animateWithDuration(0.5, delay: 1, options: nil, animations: { () -> Void in
                            self.feedImageView.center.y = self.feedImageView.center.y + 86
                            }) { (Bool) -> Void in
                        }
                }
        }
    }
    

    
    @IBAction func didPanMailbox(sender: UIPanGestureRecognizer) {
        var location = sender.locationInView(view)
        var translation = sender.translationInView(view)
        var velocity = sender.velocityInView(view)
        var offset = mailBoxPageView.center.x - mailBoxPageViewOriginalCenter.x

        println("mailBoxPageView.center.x: \(mailBoxPageView.center.x)")

        // transform
        if (sender.state == UIGestureRecognizerState.Began){
            
        } else if ((sender.state == UIGestureRecognizerState.Changed) && (mailBoxPageView.center.x >= 160)){
            mailBoxPageView.center = CGPoint(x: mailBoxPageViewOriginalCenter.x + translation.x, y: mailBoxPageViewOriginalCenter.y)
        } else if (sender.state == UIGestureRecognizerState.Ended){
            if (mailBoxPageView.center.x >= 320) {
                UIView.animateWithDuration(0.5, animations: { () -> Void in
                    self.mailBoxPageView.center.x = 480
                })
            } else if ((mailBoxPageView.center.x < 320)) {
                UIView.animateWithDuration(0.5, animations: { () -> Void in
                    self.mailBoxPageView.center.x = 160
                })
            }
            mailBoxPageViewOriginalCenter = mailBoxPageView.center
            
        }
    }
    
    
    func transformMessage(){
        var scaleTransform = CGAffineTransformMakeScale(scale, scale)
        var rotateTransform = CGAffineTransformMakeRotation(rotate)
        var concatTransform = CGAffineTransformConcat(scaleTransform, rotateTransform)
        messageImageView.transform = concatTransform
    }
    
    
    


}
