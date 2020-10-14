//
//  ContactUsViewController.swift
//  VtronixApp
//
//  Created by samstag on 28.04.2020.
//  Copyright © 2020 Vtronix. All rights reserved.
//

import UIKit
import MessageUI
import MBProgressHUD


// MARK: - ContactUsViewController

class ContactUsViewController: UIViewController {
    
    @IBOutlet var textLabel: UILabel!
    @IBOutlet var phoneButton: UIButton!
    @IBOutlet var phoneLabel: UILabel!
    @IBOutlet var messageButton: UIButton!
    @IBOutlet var messageLabel: UILabel!
    @IBOutlet var emailButton: UIButton!
    @IBOutlet var emailLabel: UILabel!
    
    lazy var hud: MBProgressHUD = {
        let mbph = MBProgressHUD(view: self.view)
        self.view.addSubview(mbph)
        return mbph
    }()
    
    private let phoneNo = "305-471-7600"
    private let emails = [ "mobile@classic-america.com" ]

    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        self.sharedInit()
    }
    

    required init?(coder: NSCoder) {

        super.init(coder: coder)
        
        self.sharedInit()
    }
    
    
    private func sharedInit() {
        
        self.title = "Contact Us"
        self.tabBarItem.image = #imageLiteral(resourceName: "tab-contact-us")
    }
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.navigationController?.applySharedNavigationBarStyle()
        
        self.textLabel.font = UIFont.appFontMedium(ofSize: 18.0)
        self.textLabel.textColor = .darkGray
        self.phoneLabel.font = UIFont.appFontMedium(ofSize: 21.0)
        self.phoneLabel.textColor = UIColor.vtronixBlue
        self.messageLabel.font = UIFont.appFontMedium(ofSize: 21.0)
        self.messageLabel.textColor = UIColor.vtronixBlue
        self.emailLabel.font = UIFont.appFontMedium(ofSize: 21.0)
        self.emailLabel.textColor = UIColor.vtronixBlue
        
        self.phoneButton.addTarget(self, action: #selector(self.phoneButtonPressed(_:)), for: .touchUpInside)
        self.messageButton.addTarget(self, action: #selector(self.messageButtonPressed(_:)), for: .touchUpInside)
        self.emailButton.addTarget(self, action: #selector(self.emailButtonPressed(_:)), for: .touchUpInside)
    }
    
    
    @objc private func phoneButtonPressed(_ sender: Any) {
        
        self.openPhoneNumberURL()
    }
    
    
    private func openPhoneNumberURL() {
        
        guard let url = URL(string: "tel://\(self.phoneNo)")
        else {
            let msg = "An error occurred. Please try again or call the following number manually: \(self.phoneNo)"
            UIAlertController.presentPlainAlertIn(self, title: "Info", message: msg)
            return
        }

        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    
    @objc private func messageButtonPressed(_ sender: Any) {
            
        self.openTextMessageForm()
    }
    
    
    private func openTextMessageForm() {
        
        guard MFMessageComposeViewController.canSendText()
        else {
            let msg = "An error occurred. Please try again or send a message to following number manually: \(self.phoneNo)"
            UIAlertController.presentPlainAlertIn(self, title: "Info", message: msg)
            return
        }
        
        let controller = MFMessageComposeViewController.init()
        controller.body = "Greetings! I want to buy a product from Vtronix."
        controller.recipients = [ self.phoneNo ]
        controller.messageComposeDelegate = self
        
        self.hud.show(animated: true)
        self.present(controller, animated: true) { [weak self] in
            self?.hud.hide(animated: true)
        }
    }
    
    
    @objc private func emailButtonPressed(_ sender: Any) {
                
        self.openEmailForm()
    }
    
    
    private func openEmailForm() {
        
        guard MFMailComposeViewController.canSendMail()
        else {
            var msg = "An error occurred. Please try again."
            if let email = self.emails.first {
                msg += "You can send an email to following address manually if issue persists: \(email)"
            }
            UIAlertController.presentPlainAlertIn(self, title: "Info", message: msg)
            return
        }
        
        let mailVC = MFMailComposeViewController.init()
        mailVC.mailComposeDelegate = self
        mailVC.setToRecipients(self.emails)
        mailVC.setSubject("Message from Vtronix iOS App")
        mailVC.setMessageBody("Greetings! I want to buy a product from Vtronix.", isHTML: false)

        self.hud.show(animated: true)
        self.present(mailVC, animated: true) { [weak self] in
            self?.hud.hide(animated: true)
        }
    }
    
}


// MARK: - MFMailComposeViewControllerDelegate

extension ContactUsViewController: MFMailComposeViewControllerDelegate {

    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult,
                               error: Error?)
    {
        switch result {
        case .cancelled:
            print("Mail cancelled")
        case .saved:
            print("Mail saved")
        case .sent:
            print("Mail sent")
        case .failed:
            if let description = error?.localizedDescription {
                print("Mail send failure: \(description)")
            } else {
                print("Mail send failed")
            }
        @unknown default:
            print("MFMailComposeViewControllerDelegate didFinishWith unknown case")
        }
        self.dismiss(animated: true, completion: nil)
    }
}


// MARK: - MFMessageComposeViewControllerDelegate

extension ContactUsViewController: MFMessageComposeViewControllerDelegate {
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController,
                                      didFinishWith result: MessageComposeResult)
    {
        switch result {
        case .cancelled:
            print("Text message cancelled")
        case .sent:
            print("Text message sent")
        case .failed:
            print("Text message send failed")
        @unknown default:
            print("MFMessageComposeViewControllerDelegate didFinishWith unknown case")
        }
        self.dismiss(animated: true, completion: nil)
    }
    
}
