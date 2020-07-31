//
//  AddTaksViewController.swift
//  School Tasks
//
//  Created by Marcin Bartminski on 29/07/2020.
//  Copyright © 2020 Marcin Bartminski. All rights reserved.
//

import UIKit
import CoreData

class NewTaskViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var section1Array = ["Deadline"]
    var section2Array = ["Switch"]
    var section3Array = ["Class"]
    
    var classesArray = ["------", "Matma", "Polski"]
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    // MARK: - UITableViewDelegate functions
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        } else if section == 1 {
            return section1Array.count
        } else if section == 2 {
            return section2Array.count
        } else {
            return section3Array.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            
            switch indexPath.item {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "textFieldCell") as! TextFieldCell
                cell.textField.placeholder = "Title"
                
                cell.textField.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
                
                cell.textField.becomeFirstResponder()
                
                return cell
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "textFieldCell") as! TextFieldCell
                cell.textField.placeholder = "Description"
                
                return cell
            default:
                return UITableViewCell()
            }
            
        case 1:
            
            switch self.section1Array[indexPath.item] {
            case "Deadline":
                let cell = tableView.dequeueReusableCell(withIdentifier: "dateCell") as! DateCell
                cell.titleLabel.text = "Deadline"

                let date = getDateFullTime()
                let dateString = formatDateString(date: date)
                let timeString = formatTimeString(date: date)
                
                cell.dateLabel.text = dateString
                cell.timeLabel.text = timeString
                
                return cell
            case "Picker":
                let cell = tableView.dequeueReusableCell(withIdentifier: "datePickerCell") as! DatePickerCell
                
                cell.datePicker.minimumDate = Date()
                
                let dateCell = tableView.cellForRow(at: IndexPath(item: 0, section: 1)) as! DateCell
                
                let date = formatDateForPicker(date: dateCell.dateLabel.text!, time: dateCell.timeLabel.text!)
                cell.datePicker.date = date
                
                return cell
            default:
                return UITableViewCell()
            }
            
        case 2:
            switch section2Array[indexPath.item] {
            case "Switch":
                let cell = tableView.dequeueReusableCell(withIdentifier: "switchCell") as! SwitchCell
                cell.titleLabel.text = "Notification"
                cell.switchh.addTarget(self, action: #selector(valueChanged), for: .valueChanged)
                
                return cell
                
            case "Time":
                let cell = tableView.dequeueReusableCell(withIdentifier: "dateCell") as! DateCell
                cell.titleLabel.text = "Time"

                let date = getDateFullTime()
                let dateString = formatDateString(date: date)
                let timeString = formatTimeString(date: date)
                
                cell.dateLabel.text = dateString
                cell.dateLabel.textColor = .label
                cell.timeLabel.text = timeString
                cell.timeLabel.textColor = .label
                
                return cell
                
            case "Picker":
                let cell = tableView.dequeueReusableCell(withIdentifier: "datePickerCell") as! DatePickerCell
                
                cell.datePicker.minimumDate = Date()
                
                let dateCell = tableView.cellForRow(at: IndexPath(item: 1, section: 2)) as! DateCell
                
                let date = formatDateForPicker(date: dateCell.dateLabel.text!, time: dateCell.timeLabel.text!)
                cell.datePicker.date = date
                
                return cell
            default:
                return UITableViewCell()
            }
            
        case 3:
            
            switch section3Array[indexPath.item] {
            case "Class":
                let cell = tableView.dequeueReusableCell(withIdentifier: "dateCell") as! DateCell
                cell.titleLabel.text = "Class"
                cell.dateLabel.text = ""
                cell.timeLabel.text = "------"
                
                return cell
                
            case "Picker":
                let cell = tableView.dequeueReusableCell(withIdentifier: "pickerCell") as! PickerCell
                cell.pickerView.delegate = self
                
                return cell
            default:
                return UITableViewCell()
            }
            
        default:
            return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 18
    }
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 18
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .systemGray6
        return view
    }
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .systemGray6
        return view
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 1 {
            if indexPath.item == 0 {
                tableView.deselectRow(at: indexPath, animated: true)
                
                let dateCell = tableView.cellForRow(at: indexPath) as? DateCell
                if dateCell?.dateLabel.textColor == UIColor.label {
                    dateCell?.dateLabel.textColor = .link
                    dateCell?.timeLabel.textColor = .link
                    
                    self.section1Array.insert("Picker", at: 1)
                    
                    tableView.beginUpdates()
                    tableView.insertRows(at: [IndexPath(item: 1, section: 1)], with: .bottom)
                    tableView.endUpdates()
                } else {
                    let datePickerCell = tableView.cellForRow(at: IndexPath(item: 1, section: 1)) as? DatePickerCell
                    
                    dateCell?.dateLabel.textColor = .label
                    dateCell?.timeLabel.textColor = .label
                    dateCell?.dateLabel.text = formatDateString(date: datePickerCell!.datePicker.date)
                    dateCell?.timeLabel.text = formatTimeString(date: datePickerCell!.datePicker.date)
                    
                    self.section1Array.remove(at: 1)
                    
                    tableView.beginUpdates()
                    tableView.deleteRows(at: [IndexPath(item: 1, section: 1)], with: .top)
                    tableView.endUpdates()
                }
            }
        } else if indexPath.section == 2 {
            if indexPath.item == 1 {
                tableView.deselectRow(at: indexPath, animated: true)
                
                let dateCell = tableView.cellForRow(at: indexPath) as? DateCell
                if dateCell?.dateLabel.textColor == UIColor.label {
                    dateCell?.dateLabel.textColor = .link
                    dateCell?.timeLabel.textColor = .link
                    
                    self.section2Array.insert("Picker", at: 2)
                    
                    tableView.beginUpdates()
                    tableView.insertRows(at: [IndexPath(item: 2, section: 2)], with: .bottom)
                    tableView.endUpdates()
                } else {
                    let datePickerCell = tableView.cellForRow(at: IndexPath(item: 2, section: 2)) as? DatePickerCell
                    
                    dateCell?.dateLabel.textColor = .label
                    dateCell?.timeLabel.textColor = .label
                    dateCell?.dateLabel.text = formatDateString(date: datePickerCell!.datePicker.date)
                    dateCell?.timeLabel.text = formatTimeString(date: datePickerCell!.datePicker.date)
                    
                    self.section2Array.remove(at: 2)
                    
                    tableView.beginUpdates()
                    tableView.deleteRows(at: [IndexPath(item: 2, section: 2)], with: .top)
                    tableView.endUpdates()
                }
            }
        } else if indexPath.section == 3 {
            if indexPath.item == 0 {
                tableView.deselectRow(at: indexPath, animated: true)
                
                let classCell = tableView.cellForRow(at: indexPath) as? DateCell
                if classCell?.timeLabel.textColor == UIColor.label {
                    classCell?.timeLabel.textColor = .link
                    
                    self.section3Array.insert("Picker", at: 1)
                    
                    tableView.beginUpdates()
                    tableView.insertRows(at: [IndexPath(item: 1, section: 3)], with: .bottom)
                    tableView.endUpdates()
                } else {
                    //let datePickerCell = tableView.cellForRow(at: IndexPath(item: 2, section: 2)) as? PickerCell
                    
                    classCell?.timeLabel.textColor = .label
                    
                    self.section3Array.remove(at: 1)
                    
                    tableView.beginUpdates()
                    tableView.deleteRows(at: [IndexPath(item: 1, section: 3)], with: .top)
                    tableView.endUpdates()
                }
            }
        }
    }
    
    // MARK: - UIPickerViewDelegate and DataSource methods
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return classesArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return classesArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let classCell = tableView.cellForRow(at: IndexPath(item: 0, section: 3)) as? DateCell
        
        classCell?.timeLabel.text = classesArray[row]
    }
    
    // MARK: - func()tions
    
    func getDateFullTime() -> Date {
        let gregorian = Calendar(identifier: .gregorian)
        let now = Date()
        var components = gregorian.dateComponents([.year, .month, .day, .hour, .minute, .second], from: now)

        components.hour = components.hour! + 1
        components.minute = 0
        components.second = 0

        return gregorian.date(from: components)!
    }
    
    func formatDateString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        return dateFormatter.string(from: date)
    }
    
    func formatTimeString(date: Date) -> String {
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "hh:mm a"
        return timeFormatter.string(from: date)
    }
    
    func formatDateForPicker(date: String, time: String) -> Date {
        let string = "\(date), \(time)"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy, hh:mm a"
        
        return dateFormatter.date(from: string)!
    }
    
    // MARK: - CoreData methods
    
    func saveItems() {
        
        do {
            try context.save()
            print("Task added!")
        } catch {
            print("Error saving context \(error)")
        }
    }
    
    // MARK: - UIButton Outlets
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: nil, message: "Are you sure you want to discard this new task?", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Discard Changes", comment: "Discard action"), style: .destructive, handler: { _ in
            NSLog("Discarded Changes")
            self.dismiss(animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Keep Editing", comment: "Cancel"), style: .cancel, handler: { _ in
            NSLog("Alert Canceled")
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let newTask = Task(context: self.context)
        
        let titleCell = tableView.cellForRow(at: IndexPath(item: 0, section: 0)) as? TextFieldCell
        newTask.title = titleCell?.textField.text
        
        let descriptionCell = tableView.cellForRow(at: IndexPath(item: 1, section: 0)) as? TextFieldCell
        newTask.taskDescription = descriptionCell?.textField.text
        
        let deadlineCell = tableView.cellForRow(at: IndexPath(item: 0, section: 1)) as? DateCell
        let deadline = formatDateForPicker(date: deadlineCell!.dateLabel.text!, time: deadlineCell!.timeLabel.text!)
        newTask.deadlineDate = deadline
        
        let notificationCell = tableView.cellForRow(at: IndexPath(item: 0, section: 2)) as? SwitchCell
        newTask.notify = notificationCell!.switchh.isOn
        
        if newTask.notify {
            let notificationTimeCell = tableView.cellForRow(at: IndexPath(item: 1, section: 2)) as? DateCell
            let notificationTime = formatDateForPicker(date: notificationTimeCell!.dateLabel.text!, time: notificationTimeCell!.timeLabel.text!)
            newTask.notificationDate = notificationTime
        }
        
        let classesCell = tableView.cellForRow(at: IndexPath(item: 0, section: 3)) as? DateCell
        newTask.taskClass = classesCell?.timeLabel.text
        print(newTask)
        
        saveItems()
        
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - @objc functions
    
    @objc func editingChanged(_ textField: UITextField) {
        let vc = self
        
        guard
            textField.text!.isEmpty
        else {
            vc.isModalInPresentation = true
            return
        }
        vc.isModalInPresentation = false
    }
    
    @objc func valueChanged(_ switchh: UISwitch) {
        let notiCell = tableView.cellForRow(at: IndexPath(item: 0, section: 2)) as! SwitchCell
        if switchh == notiCell.switchh {
            if switchh.isOn {
                section2Array.insert("Time", at: 1)
                
                tableView.beginUpdates()
                tableView.insertRows(at: [IndexPath(item: 1, section: 2)], with: .bottom)
                tableView.endUpdates()
            } else {
                if section2Array.count == 2 {
                    section2Array.remove(at: 1)
                    
                    tableView.beginUpdates()
                    tableView.deleteRows(at: [IndexPath(item: 1, section: 2)], with: .top)
                    tableView.endUpdates()
                } else if section2Array.count == 3 {
                    section2Array.remove(at: 2)
                    section2Array.remove(at: 1)
                    
                    tableView.beginUpdates()
                    tableView.deleteRows(at: [IndexPath(item: 1, section: 2), IndexPath(item: 2, section: 2)], with: .top)
                    tableView.endUpdates()
                }
            }
        }
    }
    
}

// MARK: - Cell classes

class TextFieldCell: UITableViewCell {
    @IBOutlet weak var textField: UITextField!
}

class DateCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
}

class DatePickerCell: UITableViewCell {
    @IBOutlet weak var datePicker: UIDatePicker!
}

class SwitchCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var switchh: UISwitch!
    @IBAction func switchSwitched(_ sender: UISwitch) {
    }
}

class PickerCell: UITableViewCell {
    @IBOutlet weak var pickerView: UIPickerView!
}
