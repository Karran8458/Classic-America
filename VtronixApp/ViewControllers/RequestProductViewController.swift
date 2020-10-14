//
//  RequestProductViewController.swift
//  VtronixApp
//
//  Created by samstag on 16.05.2020.
//  Copyright © 2020 Vtronix. All rights reserved.
//

import Eureka
import MBProgressHUD


class RequestProductViewController: FormViewController {
    
    var productName: String
    lazy var hud: MBProgressHUD = {
        let mbph = MBProgressHUD(view: self.view)
        self.view.addSubview(mbph)
        return mbph
    }()
    

    init(productName: String) {
        
        self.productName = productName
        
        super.init(nibName: nil, bundle: nil)
    }
    

    required init?(coder aDecoder: NSCoder) {
        
        self.productName = ""

        super.init(coder: aDecoder)
    }
    

    override func viewDidLoad() {

        super.viewDidLoad()
        
        self.title = "Request Product"
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "Submit",
                                                                      style: .done,
                                                                      target: self,
                                                                      action: #selector(self.btnSubmitTapped(_:)))
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "Close",
                                                                     style: .plain,
                                                                     target: self,
                                                                     action: #selector(self.btnCloseTapped(_:)))
        
        var textRules = RuleSet<String>()
        textRules.add(rule: RuleRequired())
        
        var emailRules = RuleSet<String>()
        emailRules.add(rule: RuleRequired())
        emailRules.add(rule: RuleEmail())

        self.form
        +++ Section("Product request form")
            <<< TextRow() {
                $0.title = "Your name"
                $0.placeholder = "Enter here"
                $0.tag = ProductFormFieldName.name
                $0.value = self.getStoredFormValue(for: ProductFormFieldName.name)
                $0.add(ruleSet: textRules)
            }
            <<< PhoneRow() {
                $0.title = "Your contact number"
                $0.placeholder = "Enter here"
                $0.tag = ProductFormFieldName.contactNumber
                $0.value = self.getStoredFormValue(for: ProductFormFieldName.contactNumber)
                $0.add(ruleSet: textRules)
            }
            <<< TextRow() {
                $0.title = "Your email"
                $0.placeholder = "Enter here"
                $0.tag = ProductFormFieldName.email
                $0.value = self.getStoredFormValue(for: ProductFormFieldName.email)
                $0.add(ruleSet: textRules)
                $0.validationOptions = .validatesOnChangeAfterBlurred
            }
            <<< TextRow() {
                $0.title = "Chosen product"
                $0.value = self.productName
                $0.add(ruleSet: textRules)
                $0.baseCell.isUserInteractionEnabled = false
            }
            <<< TextAreaRow() {
                $0.placeholder = "Your message (optional)"
                $0.tag = ProductFormFieldName.message
                $0.add(ruleSet: textRules)
            }
    }


    @objc private func btnSubmitTapped(_ sender: Any) {
        
        let name = self.form.rowBy(tag: ProductFormFieldName.name)?.baseValue as? String ?? ""
        let contactNumber = self.form.rowBy(tag: ProductFormFieldName.contactNumber)?.baseValue as? String ?? ""
        let email = self.form.rowBy(tag: ProductFormFieldName.email)?.baseValue as? String ?? ""
        let message = self.form.rowBy(tag: ProductFormFieldName.message)?.baseValue as? String ?? ""
        let df = DateFormatter.init()
        df.dateFormat = "yyyy-MM-dd HH:mm"
        let clientDate = df.string(from: Date())
        
        UserDefaults.standard.set(name, forKey: ProductFormFieldName.name)
        UserDefaults.standard.set(contactNumber, forKey: ProductFormFieldName.contactNumber)
        UserDefaults.standard.set(email, forKey: ProductFormFieldName.email)

        let mapDict = [
            "Messages": [
                [
                    "From": [
                        "Email": "mobile@vtronix.com",
                        "Name": "Vtronix Mobile"
                    ],
                    "To": [
                        [
                            "Email": "sales@vtronix.com",
                            "Name": "Vtronix Sales"
                        ]
                    ],
                    "Subject": "New product request from iOS app | Product: \(self.productName)",
                    "HTMLPart":
                    """
                    <h2>Product Request</h2>
                    <p><b>Product</b>: \(self.productName)</p>
                    <p><b>Name</b> \(name)</p>
                    <p><b>Contact Number:</b> \(contactNumber)</p>
                    <p><b>Email:</b> \(email)</p>
                    <p><b>Message:</b> \(message)</p>
                    <p><b>Client date:</b> \(clientDate)</p>
                    """
                ]
            ]
        ]
        
        if  let jsonData = try? JSONSerialization.data(withJSONObject: mapDict, options: []),
            let url = URL(string: "https://api.mailjet.com/v3.1/send")
        {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.httpBody = jsonData
            
            let tokenString = "YjkxODMyNzI0YzIwNGMyZjE2MWE3MjI0NmUyM2Q5YTA6OTFhY2Y5YmQ3YmY2OTFjMjFlZmFlMzVlYjI3ZDExNjQ="
            request.addValue("Basic \(tokenString)", forHTTPHeaderField: "Authorization")
            
            self.hud.show(animated: true)
            let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
                
                DispatchQueue.main.async {
                    self?.hud.hide(animated: true)
                }
                
                var hasError = false
                if error != nil {
                    hasError = true
                }
                if  let d = data,
                    let responseRoot = try? JSONSerialization.jsonObject(with: d, options : .allowFragments) as? [String: Any],
                    let responseArr = responseRoot["Messages"] as? [[String: Any]],
                    let firstResponse = responseArr.first,
                    let strStatus = firstResponse["Status"] as? String,
                    strStatus == "error" || strStatus == "Error"
                {
                    print("Error when submitting product form:")
                    print(String(data: d, encoding: .utf8) ?? "")
                    hasError = true
                }
                
                if hasError {
                    DispatchQueue.main.async {
                        if let self = self {
                            let msg = "An error occurred. Please try again or contact us through the Contact tab."
                            UIAlertController.presentPlainAlertIn(self, title: "Info", message: msg)
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        if let self = self {
                            let msg = "Thank you, your message was submitted successfully. We'll be in touch as quick as possible."
                            UIAlertController.presentPlainAlertIn(self, title: "Info", message: msg) { [weak self] (_) in
                                self?.dismiss(animated: true, completion: nil)
                            }
                        }
                    }
                }
            }
            
            task.resume()
        }
    }
    
    
    @objc private func btnCloseTapped(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    private func getStoredFormValue(for fieldName: String) -> String? {
        
        return UserDefaults.standard.string(forKey: fieldName)
    }
    
}


extension RequestProductViewController {
    enum ProductFormFieldName {
        static let name = "ProductFormName"
        static let contactNumber = "ProductFormContactNumber"
        static let email = "ProductFormEmail"
        static let message = "ProductFormMessage"
    }
}
