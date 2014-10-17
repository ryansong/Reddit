//
//  InitialViewController.swift
//  Reddit
//
//  Created by Vamston Yang on 10/17/14.
//  Copyright (c) 2014 Vamston Yang. All rights reserved.
//

import UIKit

// Constants
private let kUserNameTextFieldPlaceholder = "User Name"
private let kPasswordTextFieldPlaceholder = "Password"

class InitialViewController: UIViewController {
    
    // Views
    @IBOutlet weak var textFieldsContainerView: UIView!
    @IBOutlet weak var textFieldsWithConstraint: NSLayoutConstraint!
    
    // Controls
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var seeButton: UIButton!
    let tap: UITapGestureRecognizer
    
    // MARK: - Initializers
    // MARK: -
    
    // MARK:   Designated Initializers
    
    required init(coder aDecoder: NSCoder) {
        tap = UITapGestureRecognizer()
        
        super.init(coder: aDecoder)
        
        tap.addTarget(self, action: Selector("handleTap:"))
    }
    
    // MARK: - View Controller life-cycle

    // MARK: - Target Actions
    
    @IBAction func loginButtonTapped(sender: AnyObject) {
        self.animateTextFieldsContainerView(isAssignLogin: true)
    }
    
    func handleTap(sender: AnyObject) {
        self.animateTextFieldsContainerView(isAssignLogin: false)
    }
    
    // MARK: - Screen Updates
    
    func animateTextFieldsContainerView(isAssignLogin flag: Bool) {
        let textFieldsContainerNewFrame = self.calculateNewTextFieldsFrame(isAssignLogin: flag)
        
        flag ? (self.textFieldsContainerView.alpha = 1.0) : self.shouldAddTextFieldsToContainer(isAssignLogin: flag, inView: self.textFieldsContainerView)
        
        UIView.animateWithDuration(0.3,
            delay: 0,
            usingSpringWithDamping: 1,
            initialSpringVelocity: 20,
            options: UIViewAnimationOptions.BeginFromCurrentState,
            animations: { () -> Void in
                self.textFieldsContainerView.frame = textFieldsContainerNewFrame
                if flag { self.textFieldsContainerView.alpha = 1.0 }
            })
            { (finished: Bool) -> Void in
                flag ? self.view.addGestureRecognizer(self.tap) : self.view.removeGestureRecognizer(self.tap)
                flag ? self.shouldAddTextFieldsToContainer(isAssignLogin: flag, inView: self.textFieldsContainerView)
                    : (self.textFieldsContainerView.alpha = 0.0)
        }
    }
    
    func shouldAddTextFieldsToContainer(isAssignLogin flag: Bool, inView view: UIView) {
        flag ? self.addTextFields(toView: view) : self.removeTextFields(inView: view)
    }
    
    func addTextFields(toView view: UIView) {
        self.addUserNameTextField(toView: view)
        self.addPasswordTextField(toView: view)
    }
    
    func addUserNameTextField(toView view: UIView) {
        var userNameTextFieldFrame = view.bounds
        userNameTextFieldFrame.size.width -= view.layer.cornerRadius * 2
        userNameTextFieldFrame.size.height /= 2
        userNameTextFieldFrame.origin.x += view.layer.cornerRadius
        
        let userNameTextField = UITextField(frame: userNameTextFieldFrame)
        userNameTextField.textColor = self.loginButton.tintColor
        userNameTextField.placeholder = kUserNameTextFieldPlaceholder
        view.addSubview(userNameTextField)
    }
    
    func addPasswordTextField(toView view: UIView) {
        var passwordTextFieldFrame = view.bounds
        passwordTextFieldFrame.size.width -= view.layer.cornerRadius * 2
        passwordTextFieldFrame.size.height /= 2
        passwordTextFieldFrame.origin.x += view.layer.cornerRadius
        passwordTextFieldFrame.origin.y += CGRectGetHeight(passwordTextFieldFrame)
        
        let passwordTextField = UITextField(frame: passwordTextFieldFrame)
        passwordTextField.textColor = self.loginButton.tintColor
        passwordTextField.secureTextEntry = true;
        passwordTextField.placeholder = kPasswordTextFieldPlaceholder
        view.addSubview(passwordTextField)
    }
    
    func removeTextFields(inView view: UIView) {
        for subview in view.subviews {
            if subview is UITextField {
                let textField = subview as UITextField
                textField.removeFromSuperview()
            }
        }
    }
    
    func calculateNewTextFieldsFrame(isAssignLogin flag: Bool) -> CGRect {
        var textFieldsContainerNewFrame = self.loginButton.frame
        
        if flag {
            textFieldsContainerNewFrame.size.width = CGRectGetMaxX(self.seeButton.frame) - CGRectGetMinX(self.loginButton.frame)
        }
        
        self.textFieldsWithConstraint.constant = CGRectGetWidth(textFieldsContainerNewFrame)
        
        return textFieldsContainerNewFrame
    }
    
}
