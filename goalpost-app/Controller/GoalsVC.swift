//
//  ViewController.swift
//  goalpost-app
//
//  Created by Andrea on 28/08/2017.
//  Copyright © 2017 Andrea. All rights reserved.
//

import UIKit
import CoreData

let appDelegate = UIApplication.shared.delegate as? AppDelegate

class GoalsVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var undoBtn: UIButton!
    @IBOutlet weak var undoView: UIView!
    
    var goals: [Goal] = []
    var undoBtnIsPressed = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isHidden = false
        undoView.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchCoreDataObjects()
        tableView.reloadData()
    }

    
    func fetchCoreDataObjects() {
        self.fetch { (complete) in
            if complete {
                if goals.count >= 1 {
                    tableView.isHidden = false
                } else {
                    tableView.isHidden = true
                }
            }
        }
    }
    
    @IBAction func undoBtnWasPressed(_ sender: Any) {
        undoBtnIsPressed = true
    }
    
    
    @IBAction func addGoalButtonWasPressed(_ sender: Any) {
        guard let createGoalVC = storyboard?.instantiateViewController(withIdentifier: "CreateGoalVC") else { return }
        presentDetail(createGoalVC)
    }
    

}

//Implementing the tableViewDelegate and tableViewDataSource
extension GoalsVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return goals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "goalCell") as? GoalCell else { return UITableViewCell() }
        let goal = goals[indexPath.row]
        
        cell.configureCell(goal: goal)
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .none
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "DELETE") { (rowAction, indexPath) in
            //WAIT HERE FOR 3 SECONDS IF THE USER PRESS THE UNDO BUTTON
//            self.removeGoal(atIndexPath: indexPath)
//            self.fetchCoreDataObjects()
//            tableView.deleteRows(at: [indexPath], with: .automatic)
            self.undoView.isHidden = false
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                if self.undoBtnIsPressed {
                    self.undoBtnIsPressed = false
                } else {
                    self.removeGoal(atIndexPath: indexPath)
                    self.fetchCoreDataObjects()
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                    
                }
                
                self.undoView.isHidden = true
            })
            

            
            
        }
        
        let addAction = UITableViewRowAction(style: .normal, title: "ADD 1") { (rowAction, indexPath) in
            self.setProgress(atIndexPath: indexPath)
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        
        deleteAction.backgroundColor = #colorLiteral(red: 1, green: 0.009946824187, blue: 0, alpha: 1)
        addAction.backgroundColor = #colorLiteral(red: 0.9771530032, green: 0.7062081099, blue: 0.1748393774, alpha: 1)
        return [deleteAction, addAction]
    }
    
}

//Fetch data from the persistent storage
extension GoalsVC {
    func setProgress(atIndexPath indexPath: IndexPath) {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        
        let chosenGoal = goals[indexPath.row]
        
        if chosenGoal.goalProgress < chosenGoal.goalCompletionValue {
            chosenGoal.goalProgress = chosenGoal.goalProgress + 1
        } else {
            return
        }
        
        do {
            try managedContext.save()
            print("Successfully set progress!")
        } catch {
            debugPrint("Could not set progress: \(error.localizedDescription)")
        }
    }
    
    

    func removeGoal(atIndexPath indexPath: IndexPath) {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        
        managedContext.delete(goals[indexPath.row])
        
        do {
            try managedContext.save()
            print("Successfully removed goal!")
        } catch {
            debugPrint("Could not remove: \(error.localizedDescription)")
        }
    }
    
    
    
    func fetch(completion: (_ complete: Bool) -> ()) {
        //Creating a managedContext that permits us to talk with the persistent storage
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        let fetchRequest = NSFetchRequest<Goal>(entityName: "Goal")
        do {
            goals = try managedContext.fetch(fetchRequest)
            print("Successfully fetched data.")
            completion(true)
        } catch {
            debugPrint("Could not fetch: \(error.localizedDescription)")
            completion(false)
        }
    }
    

    
}
