//
//  ViewController.swift
//  Учет финансов
//
//  Created by mac on 06.08.2020.
//  Copyright © 2020 Sofya Zakharova. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController {
    
    var spendingsArray : Results<Speng>!

    @IBOutlet weak var availableForSpending: UILabel!
    
    @IBOutlet weak var spendingsForPeriod: UILabel!
    
    @IBOutlet weak var allSpendings: UILabel!
    
    @IBOutlet weak var availableLable: UILabel!
    
    @IBOutlet weak var spendingsTF: UITextField!
    
    @IBOutlet weak var tableView: UITableView!
    
    var categoryName = ""
    var valueOfTF : Double = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        spendingsArray = realm.objects(Speng.self).sorted(byKeyPath: "date", ascending: false)
        setupLabeles()
        
        tableView.rowHeight = 60
    }


    @IBAction func categoryPressed(_ sender: UIButton) {
        
        categoryName = sender.currentTitle!
        valueOfTF = Double(spendingsTF.text!) ?? 100
        
        let spending = Speng(value: [categoryName, valueOfTF])
        
        StorageManager.saveObject(spending)
        tableView.reloadData()
        
        spendingsTF.text = ""
        
        setupLabeles()
    }
    
    @IBAction func limitPressed(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Установить лимит", message: nil, preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "Установить", style: .default) { (action) in
            let tfsum = alertController.textFields?[0].text
            let tfday = alertController.textFields?[1].text
            
            //self.availableForSpending.text = tfsum
            
            guard tfday != "" && tfsum != "" else {return}
            
            if let day = tfday {
                let dayNow = Date()
                let lastDay : Date = dayNow.addingTimeInterval(60*60*24*Double(day)!)
                
                let limit = realm.objects(Limit.self)
                
                if limit.isEmpty {
                    let object = Limit(value: [tfsum!, dayNow, lastDay ])
                    StorageManager.saveLimit(object)
                } else {
                    try! realm.write{
                        limit[0].limitSum = tfsum!
                        limit[0].limitDate = dayNow as NSDate
                        limit[0].limitLastDate = lastDay as NSDate
                    }
                }
                
            }
        }
        
        let alertActionCancel = UIAlertAction(title: "Отмена", style: .destructive, handler: nil)
        
        alertController.addAction(alertAction)
        alertController.addAction(alertActionCancel)
        
        alertController.addTextField { (money) in
            money.placeholder = "Введите сумму"
            money.keyboardType = .asciiCapableNumberPad
        }
        
        alertController.addTextField { (day) in
            day.placeholder = "Введите колличество дней"
            day.keyboardType = .asciiCapableNumberPad
        }
        
        present(alertController, animated: true, completion: nil)
        
        setupLabeles()
    
    }
    
    func setupLabeles() {
        let limit =  realm.objects(Limit.self)
        
        guard limit.isEmpty == false else {return}
        
        availableForSpending.text = limit[0].limitSum
        
        print(limit[0].limitDate)
        print(limit[0].limitLastDate)
        
        let startDate = limit[0].limitDate
        let endDate = limit[0].limitLastDate
        
        let filteredLimit: Int = realm.objects(Speng.self).filter("self.date >= %@ && self.date <= %@", startDate, endDate).sum(ofProperty: "sum")
        
        spendingsForPeriod.text = String(filteredLimit)
        
        availableLable.text = "\(Int(limit[0].limitSum)! - filteredLimit)"
        
        let allSpending : Int = realm.objects(Speng.self).sum(ofProperty: "sum")
        allSpendings.text = "\(allSpending)"
    }
    
    
}



extension ViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return spendingsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        
        let spending = spendingsArray[indexPath.row]
        
        cell.recordCategory.text = spending.category
        cell.recordCost.text = String(spending.sum)
        
        switch spending.category {
        case "Еда": cell.recordImage.image = #imageLiteral(resourceName: "food")
        case "Одежда": cell.recordImage.image = #imageLiteral(resourceName: "hoodie")
        case "Связь": cell.recordImage.image = #imageLiteral(resourceName: "tower")
        case "Досуг": cell.recordImage.image = #imageLiteral(resourceName: "theater")
        case "Красота": cell.recordImage.image = #imageLiteral(resourceName: "hair")
        case "Другое": cell.recordImage.image = #imageLiteral(resourceName: "internet")
        default: cell.recordImage.image = #imageLiteral(resourceName: "clean")
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

    let editingRow = spendingsArray[indexPath.row]

    let deleteAction = UIContextualAction(style: .destructive, title: "Удалить") { (_, _, completionHandler) in

        StorageManager.deliteObject(editingRow)
        
        self.setupLabeles()

        tableView.reloadData()

        }

        return UISwipeActionsConfiguration(actions: [deleteAction])

    }
}
