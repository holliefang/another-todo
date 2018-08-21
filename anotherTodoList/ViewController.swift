//
//  ViewController.swift
//  anotherTodoList
//
//  Created by 方思涵 on 2018/8/9.
//  Copyright © 2018年 SihanFang. All rights reserved.
//
//
import UIKit

//☑️Function Upload List: Checked(Completed)Section, ☑️Moving around Rows(Actually moved in file), ☑️UserDefaults(data saving)//☑️stopUserEnteringEmptyContent

class ViewController: UITableViewController {
    
    let defaults = UserDefaults.standard

    var todos: [String] = [] //var todos = [String]()
    var completedTodo: [String] = []
    var selected = false
    
    @IBAction func addTodo(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Add New Todo", message: nil, preferredStyle: .alert)
        
        alert.addTextField { (todoTF) in
            todoTF.placeholder = "What do you want to do next?"
        }
        let action = UIAlertAction(title: "+++", style: .default) { (_) in

            guard let todo = alert.textFields?.first?.text else { return  }
            print(todo)
            self.add(todo)

            //This will also update the data to tableview however, not in the latest order.
            //self.todos.append(todo)
            //self.tableView.reloadData()
            
        }
      
        
        alert.addAction(action)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
        
    }
    
    
   
    
    //Long Press && Edit
    
    @objc func longPress(sender:UILongPressGestureRecognizer){
        
        //找出資料位置
        let point = sender.location(in: tableView)
        
        guard let indexPath = tableView.indexPathForRow(at: point) else {
            return
        }
        
        let alert = UIAlertController(title: "Modify the text:", message: nil, preferredStyle: .alert)
        alert.addTextField { (todoTF) in
            todoTF.text = self.todos[indexPath.row]
            todoTF.clearButtonMode = UITextFieldViewMode.always
   
//            func textFieldDidBeginEditing(_ todoTF: UITextField)
//            {
//                todoTF.selectedTextRange = todoTF.textRange(from: todoTF.beginningOfDocument, to: todoTF.endOfDocument)
//            }
            //call keybaordfirst
            todoTF.becomeFirstResponder()
            
        }
        let action = UIAlertAction(title: "Save", style: .default) { (_) in
            
            guard let new = alert.textFields?.first?.text else { return }
            if new != ""{
            self.todos[indexPath.row] = new
            self.defaults.set(self.todos, forKey: "SavedTodo")
            self.tableView.reloadData()
            }
        }
        
        alert.addAction(action)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)

    }
    
    
    // add function, to make the latest todo on top
    func add (_ todo: String) {
        
        if todo != ""{
            todos.insert(todo, at: 0)
            
            let indexPath = IndexPath(row: 0, section: 0)
            tableView.insertRows(at: [indexPath], with: .middle)
            
            defaults.set(todos, forKey: "SavedTodo")
        }
    }
    
   
    
    //TableView section && row
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return todos.count
        } else {
            return completedTodo.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell", for: indexPath)
        //selected cell style
        cell.selectionStyle = .blue
        cell.setSelected(true, animated: true)
        
        // let cell = UITableViewCell is another way to do it, at which the cell is not reusable
        cell.textLabel?.text = todos[indexPath.row]
     
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPress))
        longPressGesture.minimumPressDuration = 1
        
        cell.addGestureRecognizer(longPressGesture)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Uncompleted task"
        } else {
            return "Completed task"
        }
    }
    
    //swipe and delete
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        //delete the file in the model/data
        guard editingStyle == .delete else { return }
        todos.remove(at: indexPath.row)

        //delete the row on the tableView (on the screen) or use tableView.reloadData()
        tableView.deleteRows(at: [indexPath], with: .automatic)
        
        self.defaults.set(self.todos, forKey: "SavedTodo")
    }
    

    
    //Moving row
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let todosMove = todos[sourceIndexPath.row]
        
        //move todosMove to destination todos.
        todos.remove(at: sourceIndexPath.row)
        todos.insert(todosMove, at: destinationIndexPath.row)
        
        
        }
    

    
    
     //Deselect Row
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        

//        if selected == false
//        {
//            selected = true
//        }
//        else {
//            tableView.deselectRow(at: indexPath, animated: false)
//            selected = false
//        }
//
//        let alert = UIAlertController(title: "Modify the text:", message: nil, preferredStyle: .alert)
//        alert.addTextField { (todoTF) in
//            todoTF.text = self.todos[indexPath.row]
//            todoTF.clearButtonMode = UITextFieldViewMode.always
////            todoTF.selectedTextRange = todoTF.textRange(from: todoTF.beginningOfDocument, to: todoTF.endOfDocument)
//            //
//            //        todoTF.selectAll(self)
//            func textFieldDidBeginEditing(_ todoTF: UITextField)
//            {
//                todoTF.selectedTextRange = todoTF.textRange(from: todoTF.beginningOfDocument, to: todoTF.endOfDocument)
//            }
//            //call keybaordfirst
//            todoTF.becomeFirstResponder()
//
//        }
//        let action = UIAlertAction(title: "Save", style: .default) { (_) in
//
//            guard let new = alert.textFields?.first?.text else { return }
//            self.todos[indexPath.row] = new
//            self.tableView.reloadData()
//        }
//
//
//        alert.addAction(action)
//        present(alert, animated: true, completion: nil)

        
    }
        override func viewDidLoad() {
        super.viewDidLoad()
            
            if let savedTodo = defaults.object(forKey: "SavedTodo") as? [String] {
                todos = savedTodo
            } else {
                print("It's not saved")
            }

        navigationItem.leftBarButtonItem = editButtonItem
        editButtonItem.tintColor = .white
            
        // Do any additional setup after loading the view, typically from a nib.
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(true)
//        self.tableView.reloadData()
//    }
//    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


//****
//  ViewController.swift
//  ExUITableView
//
//  Created by joe feng on 2016/5/20.
//  Copyright © 2016年 hsin. All rights reserved.
//
//
////import UIKit
//
//class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
//    // 取得螢幕的尺寸
//    let fullScreenSize = UIScreen.main.bounds.size
//
//    var info = [
//        ["林書豪","陳信安"],
//        ["陳偉殷","王建民","陳金鋒","林智勝"]
//    ]
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        // 建立 UITableView 並設置原點及尺寸
//        let myTableView = UITableView(frame: CGRect(x: 0, y: 20, width: fullScreenSize.width, height: fullScreenSize.height - 20), style: .grouped)
//
//        // 註冊 cell 的樣式及名稱
//        myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
//
//        // 設置委任對象
//        myTableView.delegate = self
//        myTableView.dataSource = self
//
//        // 分隔線的樣式
//        myTableView.separatorStyle = .singleLine
//
//        // 分隔線的間距 四個數值分別代表 上、左、下、右 的間距
//        myTableView.separatorInset = UIEdgeInsetsMake(0, 20, 0, 20)
//
//        // 是否可以點選 cell
//        myTableView.allowsSelection = true
//
//        // 是否可以多選 cell
//        myTableView.allowsMultipleSelection = false
//
//        // 加入到畫面中
//        self.view.addSubview(myTableView)
//
//    }
//
//    // 必須實作的方法：每一組有幾個 cell
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return info[section].count
//    }
//
//    // 必須實作的方法：每個 cell 要顯示的內容
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        // 取得 tableView 目前使用的 cell
//        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as UITableViewCell
//
//        // 設置 Accessory 按鈕樣式
//        if indexPath.section == 1 {
//            if indexPath.row == 0 {
//                cell.accessoryType = .checkmark
//            } else if indexPath.row == 1 {
//                cell.accessoryType = .detailButton
//            } else if indexPath.row == 2 {
//                cell.accessoryType = .detailDisclosureButton
//            } else if indexPath.row == 3 {
//                cell.accessoryType = .disclosureIndicator
//            }
//        }
//
//        // 顯示的內容
//        if let myLabel = cell.textLabel {
//            myLabel.text = "\(info[indexPath.section][indexPath.row])"
//        }
//
//        return cell
//    }
//
//    // 點選 cell 後執行的動作
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        // 取消 cell 的選取狀態
//        tableView.deselectRow(at: indexPath, animated: true)
//
//        let name = info[indexPath.section][indexPath.row]
//        print("選擇的是 \(name)")
//    }
//
//    // 點選 Accessory 按鈕後執行的動作
//    // 必須設置 cell 的 accessoryType
//    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
//        let name = info[indexPath.section][indexPath.row]
//        print("按下的是 \(name) 的 detail")
//    }
//
//    // 有幾組 section
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return info.count
//    }
//
//    // 每個 section 的標題
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        let title = section == 0 ? "籃球" : "棒球"
//        return title
//    }
//
//    /*
//     // 設置每個 section 的 title 為一個 UIView
//     // 如果實作了這個方法 會蓋過單純設置文字的 section title
//     func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//     return UIView()
//     }
//
//     // 設置 section header 的高度
//     func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//     return 80
//     }
//
//     // 每個 section 的 footer
//     func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
//     return "footer"
//     }
//
//     // 設置每個 section 的 footer 為一個 UIView
//     // 如果實作了這個方法 會蓋過單純設置文字的 section footer
//     func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//     return UIView()
//     }
//
//     // 設置 section footer 的高度
//     func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//     return 80
//     }
//
//     // 設置 cell 的高度
//     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//     return 80
//     }
//     */
//
//}
//
