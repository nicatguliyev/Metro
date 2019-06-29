//
//  StationController.swift
//  Metro
//
//  Created by Nicat Guliyev on 5/13/19.
//  Copyright © 2019 Nicat Guliyev. All rights reserved.
//

import UIKit

class StationController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    var stationArray = ["Dərnəgül", "Azadlıq prospekti", "Nəsimi", "Memar Əcəmi", "Avtovağzal", "20 Yanvar", "İnşaatçılar", "Elmlər Akademiyası", "Nizami", "28 May", "Sahil", "İçərişəhər", "Xətai", "Gənclik", "Nəriman Nərimanov", "Ulduz", "Bakmil", "Koroğlu", "Qara Qarayev", "Neftçilər", "Xalqlar Dostluğu", "Həzi Aslanov"]
    var selectedStation = -1
    var setStation: ((String) -> ())!
    @IBOutlet weak var stationTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stationTable.layer.cornerRadius = 10
        if(selectedStation != -1){
        stationArray.remove(at: selectedStation)
        }

    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stationArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! StationCell
        
        cell.stationNameLabel.text = stationArray[indexPath.row]
        
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        setStation(stationArray[indexPath.row])
        dismiss(animated: true, completion: nil)
    }

}
