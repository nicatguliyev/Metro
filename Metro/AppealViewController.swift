//
//  AppealViewController.swift
//  Metro
//
//  Created by Nicat Guliyev on 5/11/19.
//  Copyright © 2019 Nicat Guliyev. All rights reserved.
//

import UIKit
import Toast_Swift


class AppealViewController: UIViewController {
    
    var rightButton = UIButton()
    @IBOutlet weak var firstStationView: UIView!
    @IBOutlet weak var secondStationView: UIView!
    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeTextField: UITextField!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var sendBtn: UIButton!
    
    let datePicker = UIDatePicker()
    let timePicker = UIDatePicker()
    var isToday = true
    var date = ""
    var dateForParameter = ""
    var stationArray = ["Dərnəgül", "Azadlıq prospekti", "Nəsimi", "Memar Əcəmi", "Avtovağzal", "20 Yanvar", "İnşaatçılar", "Elmlər Akademiyası", "Nizami", "28 May", "Sahil", "İçərişəhər", "Xətai", "Gənclik", "Nəriman Nərimanov", "Ulduz", "Bakmil", "Koroğlu", "Qara Qarayev", "Neftçilər", "Xalqlar Dostluğu", "Həzi Aslanov"]
    var selectedStation  = -1
    var clickedStation = 0
    var emt  = UIView()
    var x = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        let image = UIImage(named: "letter.png")
        let tintedImage = image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        
        rightButton.setImage(tintedImage, for: UIControl.State.normal)
        
       
        rightButton.translatesAutoresizingMaskIntoConstraints = false
        rightButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        rightButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        rightButton.imageEdgeInsets = UIEdgeInsets(top: 8, left: 15, bottom: 8, right: 0)
        rightButton.tintColor = UIColor(displayP3Red: 255/255, green: 253/255, blue: 83/255, alpha: 1)
        
        rightButton.addTarget(self, action: #selector(letterClicked), for: .touchUpInside)
        
        let barButton = UIBarButtonItem(customView: rightButton)
        self.navigationItem.rightBarButtonItem = barButton
        
        
        firstStationView.layer.cornerRadius = 5
        firstStationView.layer.borderWidth = 1.5
        firstStationView.layer.borderColor = UIColor.white.cgColor
        
        firstStationView.isUserInteractionEnabled = true
        let firstTapGesture = UITapGestureRecognizer(target: self, action: #selector(firstTapped))
        firstStationView.addGestureRecognizer(firstTapGesture)
        
        secondStationView.layer.cornerRadius = 5
        secondStationView.layer.borderWidth = 1.5
        secondStationView.layer.borderColor = UIColor.white.cgColor
        
        secondStationView.isUserInteractionEnabled = true
        let secondTapGesture = UITapGestureRecognizer(target: self, action: #selector(secondTapped))
        secondStationView.addGestureRecognizer(secondTapGesture)
        
        
        sendBtn.layer.cornerRadius = 5
        
        dateView.layer.cornerRadius = 5
        dateView.layer.borderWidth = 1.5
        dateView.layer.borderColor = UIColor.white.cgColor
        
        dateView.isUserInteractionEnabled = true
        let dateTapGesture = UITapGestureRecognizer(target: self, action: #selector(dateTapped))
        dateView.addGestureRecognizer(dateTapGesture)
        
        datePicker.datePickerMode = .date
        datePicker.locale = Locale(identifier: "az_Latn")
        datePicker.minimumDate = Date()
        datePicker.addTarget(self, action: #selector(dateChanged(datePicker:)), for: .valueChanged)
       // timePicker.addTarget(self, action: #selector(dateChanged(datePicker:)), for: .valueChanged)

        dateTextField.inputView = datePicker
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let titleButton = UIBarButtonItem(title: "Tarixi seçin", style: .done, target: self, action: #selector(self.nothing))
        
        
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        
        let doneBtn = UIBarButtonItem(title: "OK", style: .done, target: self, action: #selector(self.doneClicked))
        
        toolbar.setItems([titleButton, space, doneBtn], animated: false)
        
        dateTextField.inputAccessoryView = toolbar
        
        
        if let emptyView = Bundle.main.loadNibNamed("WaitView", owner: self, options: nil)?.first as? WaitView {
            emptyView.frame.size.height = UIScreen.main.bounds.height
            
            emptyView.frame.size.width = UIScreen.main.bounds.width
            
            self.view.addSubview(emptyView); // Internet olmayanda vey zeif olanda CheckConection adli view-nu goturur ve onu ekrana elve edir
            emt = emptyView
            emptyView.isHidden = true
            
        }
        

    }
    
    @objc func letterClicked(){
        performSegue(withIdentifier: "segueToList", sender: self)
    }
    
    @objc func nothing(){
        
    }
    
    @objc func doneClicked(){
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        var components = calendar.dateComponents([.day, .month, .year], from: date)
        var startDate = calendar.date(from: components)
        var endDate = calendar.date(from: components)
        if(isToday == true)
        {
            if(hour <= 5){
                components.hour = 6
                components.minute = 3
                startDate = calendar.date(from: components)
                components.hour = 23
                components.minute = 59
                endDate = calendar.date(from: components)
            }
            else
            {
                if(hour == 23){
                    components.hour = hour
                }
                else
                {
                    components.hour = hour + 1
                }
                components.minute = minutes + 3
                startDate = calendar.date(from: components)
                components.hour = 23
                components.minute = 59
                endDate = calendar.date(from: components)
            }
        }
        else{
            components.hour = 6
            components.minute = 0
            startDate = calendar.date(from: components)
            components.hour = 23
            components.minute = 59
            endDate = calendar.date(from: components)
        }
        
   
        
        timePicker.datePickerMode = .time
        timePicker.locale = Locale(identifier: "az_Latn")
        timePicker.minimumDate = startDate
        timePicker.maximumDate = endDate
        
        timeTextField.inputView = timePicker
        
        let toolbar2 = UIToolbar()
        toolbar2.sizeToFit()
        
        let space2 = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        
        let titleButton2 = UIBarButtonItem(title: "Saatı seçin", style: .done, target: self, action: #selector(self.nothing))
        
        
        let doneBtn2 = UIBarButtonItem(title: "OK", style: .done, target: self, action: #selector(self.doneClicked2))
        
        toolbar2.setItems([titleButton2, space2, doneBtn2], animated: false)
        
        timeTextField.inputAccessoryView = toolbar2
        
        timePicker.reloadInputViews()
        
        timeTextField.becomeFirstResponder()
        
        
    }
    
    @objc func doneClicked2(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let time = dateFormatter.string(from: timePicker.date)
        x = dateForParameter + " " + time
        dateLabel.text = date + " / " + time
        
        view.endEditing(true)
       // print(time)
    }
    
    @objc func firstTapped(){
        clickedStation = 1
        if(secondLabel.text == "Stansiyanı seçin"){
            selectedStation = -1
        }
        else
        {
            selectedStation = stationArray.firstIndex(of: secondLabel.text!)!
        }
        performSegue(withIdentifier: "segueToStations", sender: self)
    }
    
    @objc func secondTapped(){
        clickedStation = 2
        if(firstLabel.text == "Stansiyanı seçin"){
            selectedStation = -1
        }
        else
        {
            selectedStation = stationArray.firstIndex(of: firstLabel.text!)!
        }
        performSegue(withIdentifier: "segueToStations", sender: self)
    }
    
    @objc func dateTapped(){
        dateTextField.becomeFirstResponder()
        
        if(dateLabel.text == "00-00-0000 / 00:00"){
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            date = dateFormatter.string(from: Date())
            
            let dateFormatter2 = DateFormatter()
            dateFormatter2.dateFormat = "yyyy-MM-dd"
            dateForParameter = dateFormatter2.string(from: Date())
        }
    }
    
    @objc func dateChanged(datePicker: UIDatePicker){
      let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        date = dateFormatter.string(from: datePicker.date)
        
        
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat = "yyyy-MM-dd"
        dateForParameter = dateFormatter2.string(from: datePicker.date)
        
        if(dateFormatter.string(from: datePicker.date) == dateFormatter.string(from: Date())){
            isToday = true
        }
        else
        {
            isToday = false
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "segueToStations"){
            let vc = segue.destination as! StationController
            vc.selectedStation = self.selectedStation
            vc.setStation = self.setStation
        }
    }
    
    func setStation(station: String) -> () {
        if(clickedStation == 1){
            firstLabel.text = station
        }
        if(clickedStation == 2)
        {
            secondLabel.text = station
        }
    }
    
    
    @IBAction func sendBtnClicked(_ sender: Any) {
        self.view.endEditing(true)
        if(firstLabel.text == "Stansiyanı seçin" || secondLabel.text == "Stansiyanı seçin"){
            self.view.makeToast("Stansiyaları seçin")
        }
        if(dateLabel.text == "00-00-0000 / 00:00" && firstLabel.text != "Stansiyanı seçin" && secondLabel.text != "Stansiyanı seçin")
        {
            self.view.makeToast("Gediş saatını seçin")
        }
        if(dateLabel.text != "00-00-0000 / 00:00" && firstLabel.text != "Stansiyanı seçin" && secondLabel.text != "Stansiyanı seçin")
        {
            
            sendAppeal()
        }
    }
    
    func sendAppeal(){
        //16723de8b5d251744c1a2919fe50151c"
        emt.isHidden = false
        print(dateForParameter)
        
        
        
        let urlString = "http://metro.s-h.az/web/index.php?r=restuser/request"
        
        guard let url = URL(string: urlString)
            else {return}
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        
        urlRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let parameters: [String: Any] = [
            "token": UserDefaults.standard.string(forKey: "token")!,
            "from_metro": firstLabel.text!,
            "to_metro": secondLabel.text!,
            "r_date": x
        ]
        
        print(dateForParameter)
        print(firstLabel.text!)
        print(secondLabel.text!)
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
                    self.view.makeToast("Xəta baş verdi.")

                }
                else
                {
                    self.view.makeToast("Sifarişiniz qəbul olundu.")

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
