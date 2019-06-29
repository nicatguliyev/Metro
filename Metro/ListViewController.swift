//
//  ListViewController.swift
//  Metro
//
//  Created by Nicat Guliyev on 5/13/19.
//  Copyright © 2019 Nicat Guliyev. All rights reserved.
//

import UIKit

struct appealModel : Decodable {
    var r_date: String
    var from_metro: String
    var to_metro: String
}

struct appealData{
    var r_date = String()
    var from_metro = String()
    var to_metro = String()
}
//struct appealList: Decodable {
//    let array: []
//
//    init(from decoder: Decoder) throws {
//        var container = try decoder.unkeyedContainer()
//        array = try container.decode([].self)
//
//    }
//}

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
 
    
    
    @IBOutlet weak var appealTable: UITableView!
    var leftButton = UIButton()
    var emt = UIView()
    var appealArray = [appealData]()

    @IBOutlet weak var infLabel: UILabel!
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
        
        self.title = "Müraciətlər"
        appealTable.isHidden = true
        infLabel.isHidden = true
        
        if let emptyView = Bundle.main.loadNibNamed("WaitView", owner: self, options: nil)?.first as? WaitView {
            emptyView.frame.size.height = UIScreen.main.bounds.height
            
            emptyView.frame.size.width = UIScreen.main.bounds.width
            
            self.view.addSubview(emptyView); // Internet olmayanda vey zeif olanda CheckConection adli view-nu goturur ve onu ekrana elve edir
            emt = emptyView
            //emptyView.isHidden = true
            
        }
        
        getList()
        
    }
    
    @objc func backClicked(){
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appealArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let nib: [AppealViewCell] = Bundle.main.loadNibNamed("AppealViewCell", owner: self, options: nil) as! [AppealViewCell]
        let cell = nib[0]
        
        cell.mainView.layer.cornerRadius = 7
        cell.mainView.layer.borderColor = UIColor.white.cgColor
        cell.mainView.layer.borderWidth = 1.2
        
        cell.dateLbl.text = appealArray[indexPath.row].r_date
        cell.fromLbl.text = appealArray[indexPath.row].from_metro
        cell.toLbl.text = appealArray[indexPath.row].to_metro

        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func getList(){
        //8246
        //2591
        let urlString = "http://metro.s-h.az/web/index.php?r=restuser/listrequest"
        
        
        guard let url = URL(string: urlString)
            else {return}
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        
        urlRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let parameters: [String: Any] = [
           "token": UserDefaults.standard.string(forKey: "token")!
           // "token": "UserDefaults.standard.string(forK"
        ]
        urlRequest.httpBody = parameters.percentEscaped().data(using: .utf8)
        
        print(UserDefaults.standard.string(forKey: "token")!)
        
        
        let urlconfig = URLSessionConfiguration.default
        urlconfig.timeoutIntervalForRequest = 10
        urlconfig.timeoutIntervalForResource = 60
        let session = Foundation.URLSession(configuration: urlconfig, delegate: self as? URLSessionDelegate, delegateQueue: OperationQueue.main)
        
        
        let task =  session.dataTask(with: urlRequest){ (data, response, err) in
            
            self.emt.isHidden = true
            self.appealTable.isHidden = false
            
            if(err == nil){
                
                let dataString = String(NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!)
                if(dataString == "")
                {
                    self.view.makeToast("Xəta baş verdi")
                  //  self.infLabel.isHidden = false
                    
                }
                else{
                        do{
                            let appeals = try JSONDecoder().decode([appealModel].self, from: data!)
                            
                            if(appeals.count == 0){
                                self.infLabel.isHidden = false
                            }
                            
                            else{
                            for i in 0..<appeals.count{
                                var model = appealData()
                                
                                
                                let dateFormatter = DateFormatter()
                                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                                let date = dateFormatter.date(from: appeals[i].r_date)
                                dateFormatter.dateFormat = "dd-MM-yyyy / HH:mm"
                                
                                
                                model.r_date = dateFormatter.string(from: date!)
                                model.from_metro = appeals[i].from_metro
                                model.to_metro = appeals[i].to_metro
                                self.appealArray.append(model)
                            }
                            }
                            
                        }
                            
                        catch let jsonError {
                            print("Json error" , jsonError)
                        }
                    
                   
                 
                }
                
                self.appealTable.reloadData()
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
