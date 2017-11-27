import UIKit
class CreatorController: UIViewController, UITableViewDataSource,
UITableViewDelegate, UITextViewDelegate, UITextFieldDelegate {
    //----------------- @IBOutlet ------------
    @IBOutlet weak var studentNameLabel: UILabel!
    @IBOutlet weak var courseField: UITextField!
    @IBOutlet weak var gradeField: UITextField!
    @IBOutlet weak var infoTableView: UITableView!
    
    
    
    typealias studentName = String
    typealias course = String
    typealias grade = Double
    //-----------------
    let userDefaultsObj = UserDefaultsManager()
    var studentGrades: [studentName: [course: grade]]!
    var arrayOfCourses: [course]!
    var arrayOfGrades: [grade]!
    //-----------------
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUserDefaults()
        studentNameLabel.text = userDefaultsObj.getValue(theKey: "name") as? String
    }
    //-----------------
    func fillUpArray() {
        let name = studentNameLabel.text
        let coursesAndGrades = studentGrades[name!]
        arrayOfCourses = [course](coursesAndGrades!.keys)
        arrayOfGrades = [grade](coursesAndGrades!.values)
    }
    
    //-----------------
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) ->
        Int {
            return arrayOfCourses.count
    }
    //-----------------
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) ->
        UITableViewCell {
            let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier:
                "protoCell")!
            
            if let aCourse = cell.viewWithTag(100) as! UILabel! {
                aCourse.text = arrayOfCourses[indexPath.row]
            }
            
            if let aValue = cell.viewWithTag(101) as! UILabel! {
                aValue.text = String(arrayOfGrades[indexPath.row])
            }
            return cell
    }
    //-----------------
    func tableView(_ tableView: UITableView, commit editingStyle:
        UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            let name = [studentName](studentGrades.keys)[indexPath.row]
            studentGrades[name] = nil
            userDefaultsObj.setKey(theValue: studentGrades as AnyObject, theKey:
                "grade")
            tableView.deleteRows(at: [indexPath as IndexPath], with:
                UITableViewRowAnimation.automatic)
        }
    }
    //-----------------
    func loadUserDefaults() {
        if userDefaultsObj.doesKeyExist(theKey: "grades") {
            studentGrades = userDefaultsObj.getValue(theKey: "grades") as!
                [studentName: [course: grade]]
        } else {
            studentGrades = [studentName: [course: grade]]()
        }
    }
    //-----------------
    @IBAction func add(_ sender: UIButton) {
        let name = studentNameLabel.text!
        var studentCourses = studentGrades[name]!
        studentCourses[courseField.text!] = Double(gradeField.text!)
        studentGrades[name] = studentCourses
        userDefaultsObj.setKey(theValue: studentGrades as AnyObject, theKey:
            "grades")
        fillUpArray()
        infoTableView.reloadData()
    }
}
