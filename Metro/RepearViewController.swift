//
//  RepearViewController.swift
//  Metro
//
//  Created by Nicat Guliyev on 5/11/19.
//  Copyright © 2019 Nicat Guliyev. All rights reserved.
//

import UIKit
import Toast_Swift

class RepearViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
 
    @IBOutlet weak var operatorBtn: UIButton!
    @IBOutlet weak var numberTextField: UITextField!
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var pickerTextField: UITextField!
    let operatorNumbers = ["50", "51", "55", "70", "77"]
    let pickerView = UIPickerView()
    var empt = UIView()
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    var setNumber : ((String, String)->())!
    
    var leftButton = UIButton()
    override func viewDidLoad() {
        super.viewDidLoad()

        setupDesign()
    }
    
    @IBAction func operatorBtnClicked(_ sender: Any) {
    pickerTextField.becomeFirstResponder()
    }
    
    @IBAction func sendBtnClicked(_ sender: Any) {
        view.endEditing(true)
        if((numberTextField.text?.count)! < 9){
            if(numberTextField.text == ""){
                self.view.makeToast("Nömrəni daxil edin")
            }
            else
            {
                 self.view.makeToast("Nömrəni tam daxil edin")
            }
        }
        else{
             repearPassword()
        }
     
    }
    
    func setupDesign(){
        
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
        
        
        let textFieldBackColor = UIColor(red: 72/255, green: 92/255, blue: 107/255, alpha: 1)
        let backColor = UIColor(red: 51/255, green: 69/255, blue: 81/255, alpha: 1)
        view.backgroundColor = backColor
        
        let leftView = UILabel(frame: CGRect(x: 10, y: 0, width: 12, height: 26))
        leftView.backgroundColor = .clear
        
        let leftView2 = UILabel(frame: CGRect(x: 10, y: 0, width: 12, height: 26))
        leftView2.backgroundColor = .clear
        
        
        
        operatorBtn.layer.borderWidth = 1.5
        operatorBtn.layer.borderColor = UIColor.white.cgColor
        operatorBtn.layer.cornerRadius = 5
        operatorBtn.backgroundColor = textFieldBackColor
        
        numberTextField.layer.borderWidth = 1.5
        numberTextField.layer.borderColor = UIColor.white.cgColor
        numberTextField.layer.cornerRadius = 5
        numberTextField.attributedPlaceholder = NSAttributedString(string: "Telefon nömrəsi", attributes: [NSAttributedString.Key.foregroundColor: UIColor(displayP3Red: 156/255, green: 203/255, blue: 60/255, alpha: 1)])
        numberTextField.leftView = leftView2
        numberTextField.leftViewMode = .always
        numberTextField.contentVerticalAlignment = .center
        
        sendBtn.layer.cornerRadius = 5
        
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        
        let doneBtn = UIBarButtonItem(title: "Bitdi", style: .done, target: self, action: #selector(self.doneClicked))
        
        toolbar.setItems([space, doneBtn], animated: false)
        
        numberTextField.inputAccessoryView = toolbar
        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.doneClicked))
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tapGesture)
        
        
        pickerView.delegate = self
        pickerTextField.inputView = pickerView
        
        dismissPickerView()
        
        
        if let emptyView = Bundle.main.loadNibNamed("EmptyView", owner: self, options: nil)?.first as? EmptyView {
            self.view.addSubview(emptyView); // Internet olmayanda vey zeif olanda CheckConection adli view-nu goturur ve onu ekrana elve edir
            emptyView.frame.size.height = UIScreen.main.bounds.height
            emptyView.frame.size.width = UIScreen.main.bounds.width
            empt = emptyView
            emptyView.isHidden = true
            
        }
        
        
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
    
    
    @objc func backClicked(){
        view.endEditing(true)
        dismiss(animated: true, completion: nil)
    }
    
    @objc func doneClicked(){
        if(pickerTextField.isEditing == false){
            view.endEditing(true)
        }
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
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if(textField == numberTextField){
            if((textField.text?.count == 3 || textField.text?.count == 6) && string != "")
            {
                textField.text = textField.text! + "-"
            }
            if(textField.text?.count == 8 && string != "")
            {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.001, execute: {
                    self.view.endEditing(true)
                })
            }
            if(textField.text?.count == 9 && string != "")
            {
                self.view.endEditing(true)
            }
        }
        return true
    }
    
    func repearPassword(){
        indicator.isHidden = false
        empt.isHidden = false
        var number = "994" + (operatorBtn.titleLabel?.text)! + numberTextField.text!
        let firstIndex = number.firstIndex(of: "-")
        number.remove(at: firstIndex!)
        let lastIndex = number.lastIndex(of: "-")
        number.remove(at: lastIndex!)
        
        
        let urlString = "http://metro.s-h.az/web/index.php?r=restuser/forget"
        
        guard let url = URL(string: urlString)
            else {return}
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        
        urlRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let parameters: [String: Any] = [
            "phone": number
        ]
        urlRequest.httpBody = parameters.percentEscaped().data(using: .utf8)
        print(number)
        
        let urlconfig = URLSessionConfiguration.default
        urlconfig.timeoutIntervalForRequest = 10
        urlconfig.timeoutIntervalForResource = 60
        let session = Foundation.URLSession(configuration: urlconfig, delegate: self as? URLSessionDelegate, delegateQueue: OperationQueue.main)
        
    
        let task =  session.dataTask(with: urlRequest){ (data, response, err) in
        
             self.indicator.isHidden = true
             self.empt.isHidden = true
            
            if(err == nil){
                
                let dataString = String(NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!)
                if(dataString == "true")
                {
                    print(self.numberTextField.text!)
                    self.view.makeToast("Kod göndərildi")
                    self.setNumber(self.numberTextField.text!, (self.operatorBtn.titleLabel?.text!)!)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                          self.dismiss(animated: true, completion: nil)
                    })
                  
                }
                else
                {
                   self.view.makeToast("Xəta baş verdi")
                    
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

extension Dictionary {
    func percentEscaped() -> String {
        return map { (key, value) in
            let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            return escapedKey + "=" + escapedValue
            }
            .joined(separator: "&")
    }
}

extension CharacterSet {
    static let urlQueryValueAllowed: CharacterSet = {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="
        
        var allowed = CharacterSet.urlQueryAllowed
        allowed.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        return allowed
    }()
}

