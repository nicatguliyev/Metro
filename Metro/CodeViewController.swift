//
//  CodeViewController.swift
//  Metro
//
//  Created by Nicat Guliyev on 5/14/19.
//  Copyright © 2019 Nicat Guliyev. All rights reserved.
//

import UIKit


struct User:Decodable {
    var userid: Int
    var phone: String
    var token: String
    
}

class CodeViewController: UIViewController, UITextFieldDelegate {
    
    var leftButton = UIButton()
    @IBOutlet weak var codeTextField: UITextField!
    @IBOutlet weak var confirmButton: UIButton!
    var phone = ""
    var emt = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let image = UIImage(named: "backArrow.png")
        let tintedImage = image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        
        leftButton.setImage(tintedImage, for: UIControl.State.normal)
        
        leftButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        leftButton.translatesAutoresizingMaskIntoConstraints = false
        leftButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        leftButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        leftButton.imageEdgeInsets = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 20)
        leftButton.tintColor = UIColor.yellow
        
        leftButton.addTarget(self, action: #selector(backClicked), for: .touchUpInside)
        
        let barButton = UIBarButtonItem(customView: leftButton)
        self.navigationItem.leftBarButtonItem = barButton
        
        let leftView2 = UILabel(frame: CGRect(x: 10, y: 0, width: 12, height: 26))
        leftView2.backgroundColor = .clear
        
        codeTextField.layer.borderWidth = 1.5
        codeTextField.layer.borderColor = UIColor.white.cgColor
        codeTextField.layer.cornerRadius = 5
        codeTextField.attributedPlaceholder = NSAttributedString(string: "Kod", attributes: [NSAttributedString.Key.foregroundColor: UIColor(displayP3Red: 156/255, green: 203/255, blue: 60/255, alpha: 1)])
        codeTextField.leftView = leftView2
        codeTextField.leftViewMode = .always
        codeTextField.contentVerticalAlignment = .center
        
        confirmButton.layer.cornerRadius = 5
        
        
        if let emptyView = Bundle.main.loadNibNamed("WaitView", owner: self, options: nil)?.first as? WaitView {
            emptyView.frame.size.height = UIScreen.main.bounds.height
            
            emptyView.frame.size.width = UIScreen.main.bounds.width
            
            self.view.addSubview(emptyView); // Internet olmayanda vey zeif olanda CheckConection adli view-nu goturur ve onu ekrana elve edir
            emt = emptyView
            emptyView.isHidden = true
            
        }

    }
    
    @objc func backClicked(){
        self.navigationController?.popViewController(animated: true)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if(textField.text?.count == 3 && string != "")
        {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.001, execute: {
                self.view.endEditing(true)
            })
        }
        if(textField.text?.count == 4 && string != "")
        {
           self.view.endEditing(true)
        }
        return true
    }
    
    
    @IBAction func confirmClicked(_ sender: Any) {
        logIn()
    }
    
    
    func logIn(){
        emt.isHidden = false
        var number = "994" + self.phone
        let firstIndex = number.firstIndex(of: "-")
        number.remove(at: firstIndex!)
        let lastIndex = number.lastIndex(of: "-")
        number.remove(at: lastIndex!)
        
        let urlString = "http://metro.s-h.az/web/index.php?r=restuser/login"
        
        guard let url = URL(string: urlString)
            else {return}
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        
        urlRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let parameters: [String: Any] = [
            "phone": number,
            "password": codeTextField.text!
        ]
        urlRequest.httpBody = parameters.percentEscaped().data(using: .utf8)
        
        
        let urlconfig = URLSessionConfiguration.default
        urlconfig.timeoutIntervalForRequest = 10
        urlconfig.timeoutIntervalForResource = 60
        let session = Foundation.URLSession(configuration: urlconfig, delegate: self as? URLSessionDelegate, delegateQueue: OperationQueue.main)
        
        
        let task =  session.dataTask(with: urlRequest){ (data, response, err) in
            
            self.emt.isHidden = true
            
            if(err == nil){
                
                let dataString = String(NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!)
                if(dataString == "false")
                {
                    self.view.makeToast("Xəta baş verdi")
                    
                }
                else{
                    do{
                        let userModel = try JSONDecoder().decode(User.self, from: data!)
                        UserDefaults.standard.set(userModel.token, forKey: "token")
                        self.performSegue(withIdentifier: "segueToAppeal", sender: self)
                        
                    }
                        
                    catch let jsonError {
                        print("Json error" , jsonError)
                    }
                }
            }
            else
            {
                if let error = err as NSError?
                {
                    if error.code == NSURLErrorNotConnectedToInternet || error.code == NSURLErrorCannotConnectToHost{
                        
                        self.view.makeToast("İnternet əlaqəsini yoxlayın")
                    }
                    if(error.code == NSURLErrorTimedOut){
                        
                        self.view.makeToast("İnternet əlaqəsi zəifdir yada yoxdur")
                    }
                }
                
            }
            
        }
        
        task.resume()
        
    }
}
