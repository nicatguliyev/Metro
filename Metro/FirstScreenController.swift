//
//  FirstScreenController.swift
//  Metro
//
//  Created by Nicat Guliyev on 5/6/19.
//  Copyright © 2019 Nicat Guliyev. All rights reserved.
//

import UIKit

class FirstScreenController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource{


    @IBOutlet weak var operatorBtn: UIButton!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var pickerTextField: UITextField!
    let operatorNumbers = ["50", "51", "55", "70", "77"]
    let pickerView = UIPickerView()
    var selectedPickerRow = 0
    var emt = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(UserDefaults.standard.string(forKey: "token") != nil){
            print("tototot")
            UIApplication.shared.keyWindow?.rootViewController = AppealViewController()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.001, execute: {
               // self.performSegue(withIdentifier: "segueToInformation", sender: self)
            })
            
        }
        
        setupDeisgn()

    }
    
    func setupDeisgn(){
        let textFieldBackColor = UIColor(red: 72/255, green: 92/255, blue: 107/255, alpha: 1)
        let leftView = UILabel(frame: CGRect(x: 10, y: 0, width: 12, height: 26))
        leftView.backgroundColor = .clear
        
        let leftView2 = UILabel(frame: CGRect(x: 10, y: 0, width: 12, height: 26))
        leftView2.backgroundColor = .clear
        
        let backColor = UIColor(red: 51/255, green: 69/255, blue: 81/255, alpha: 1)
        view.backgroundColor = backColor
        
       
        
        operatorBtn.backgroundColor = textFieldBackColor
        operatorBtn.layer.borderWidth = 1.5
        operatorBtn.layer.borderColor = UIColor.white.cgColor
        operatorBtn.layer.cornerRadius = 5
        
        phoneTextField.backgroundColor = textFieldBackColor
        phoneTextField.layer.borderWidth = 1.5
        phoneTextField.layer.borderColor = UIColor.white.cgColor
        phoneTextField.layer.cornerRadius = 5
        phoneTextField.attributedPlaceholder = NSAttributedString(string: "Telefon nömrəsi", attributes: [NSAttributedString.Key.foregroundColor: UIColor(displayP3Red: 156/255, green: 203/255, blue: 60/255, alpha: 1)])
        phoneTextField.leftView = leftView
        phoneTextField.leftViewMode = .always
        phoneTextField.contentVerticalAlignment = .center
        
        
        passwordTextField.backgroundColor = textFieldBackColor
       // passwordTextField.layer.backgroundColor = UIColor.red
        passwordTextField.layer.borderWidth = 1.5
        passwordTextField.layer.borderColor = UIColor.white.cgColor
        passwordTextField.layer.cornerRadius = 5
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Şifrə", attributes: [NSAttributedString.Key.foregroundColor: UIColor(displayP3Red: 156/255, green: 203/255, blue: 60/255, alpha: 1)])
        passwordTextField.leftView = leftView2
        passwordTextField.leftViewMode = .always
        passwordTextField.contentVerticalAlignment = .center

        loginBtn.layer.cornerRadius = 5
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        
        let doneBtn = UIBarButtonItem(title: "Bitdi", style: .done, target: self, action: #selector(self.doneClicked))
        
        toolbar.setItems([space, doneBtn], animated: false)
        
        phoneTextField.inputAccessoryView = toolbar
        passwordTextField.inputAccessoryView = toolbar
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tapGesture)
        
        
        
        pickerView.delegate = self
        pickerTextField.inputView = pickerView
        
        dismissPickerView()
        
        
        if let emptyView = Bundle.main.loadNibNamed("WaitView", owner: self, options: nil)?.first as? WaitView {
            emptyView.frame.size.height = UIScreen.main.bounds.height
            
            emptyView.frame.size.width = UIScreen.main.bounds.width
            
            self.view.addSubview(emptyView); // Internet olmayanda vey zeif olanda CheckConection adli view-nu goturur ve onu ekrana elve edir
            emt = emptyView
            emptyView.isHidden = true
            
        }
        
        
    }
    
    @objc func viewTapped(){
        if(pickerTextField.isEditing == false)
        {
            self.view.endEditing(true)
        }
        
    }
    
   @objc func doneClicked(){
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if(textField == phoneTextField){
            if((textField.text?.count == 3 || textField.text?.count == 6) && string != "")
            {
                textField.text = textField.text! + "-"
            }
            if(textField.text?.count == 8 && string != "")
            {
              DispatchQueue.main.asyncAfter(deadline: .now() + 0.001, execute: {
                if(self.passwordTextField.text == ""){
                    self.phoneTextField.resignFirstResponder()
                    self.passwordTextField.becomeFirstResponder()
                  
                }
                else
                {
                    self.view.endEditing(true)
                }
              })
            }
            if(textField.text?.count == 9 && string != "")
            {
               view.endEditing(true)
            }
        }
        return true
    }
    
    func dismissPickerView(){
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        
        let doneBtn = UIBarButtonItem(title: "Bitdi", style: .done, target: self, action: #selector(self.pickerDoneClicked))
        
        toolbar.setItems([space, doneBtn], animated: false)
        
        pickerTextField.inputAccessoryView = toolbar
    }
    
    @objc func pickerDoneClicked(){
        operatorBtn.setTitle(operatorNumbers[pickerView.selectedRow(inComponent: 0)], for: .normal)
        view.endEditing(true)
    }
    
    
    @IBAction func operatorClicked(_ sender: Any) {
        pickerTextField.becomeFirstResponder()
        
    }
    
    
    @IBAction func loginClicked(_ sender: Any) {
        view.endEditing(true)
        if((phoneTextField.text?.count)! < 9){
            if(phoneTextField.text == ""){
               self.view.makeToast("Nömrəni daxil edin")
            }
            else
            {
                self.view.makeToast("Nömrəni tam daxil edin")
            }
        }
        if(passwordTextField.text == "" &&  ((phoneTextField.text?.count)!) == 9)
        {
             self.view.makeToast("Şifrə daxil edin")
        }
        
        if(phoneTextField.text?.count == 9 && passwordTextField.text != ""){
            dismiss(animated: true, completion: nil)
            logIn()
        }
    }
    
    @IBAction func registerClicked(_ sender: Any) {
    }
    @IBAction func repairClciked(_ sender: Any) {
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 5
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return operatorNumbers[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
         operatorBtn.setTitle(operatorNumbers[pickerView.selectedRow(inComponent: 0)], for: .normal)
    }
    
    func setNumber(number: String, ope: String) -> (){
        phoneTextField.text = number
        passwordTextField.becomeFirstResponder()
        passwordTextField.text = ""
        operatorBtn.setTitle(ope, for: .normal)
        //self.view.makeToast("Kod göndərildi")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "segueToRepear")
        {
            let navC = segue.destination as! RepearNavigationController
            var arr = navC.viewControllers
            let vc = arr[0] as! RepearViewController
            print(arr)
            vc.setNumber = self.setNumber
        }
    }
    
    func logIn(){
        emt.isHidden = false
        var number = "994" + (self.operatorBtn.titleLabel?.text)! + self.phoneTextField.text!
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
            "password": passwordTextField.text!
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
                    self.view.makeToast("Şifrə yanlışdır.")
                    
                }
                else{
                    do{
                        let userModel = try JSONDecoder().decode(User.self, from: data!)
                        UserDefaults.standard.set(userModel.token, forKey: "token")
                        
                        self.dismiss(animated: true, completion: nil)
                        self.performSegue(withIdentifier: "segueToInformation", sender: self)
                        
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
