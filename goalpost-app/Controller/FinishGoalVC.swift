//
//  FinishGoalVC.swift
//  goalpost-app
//
//  Created by Andrea on 29/08/2017.
//  Copyright © 2017 Andrea. All rights reserved.
//

import UIKit

class FinishGoalVC: UIViewController {

    @IBOutlet weak var createGoalBtn: UIButton!
    @IBOutlet weak var pointsTextField: UITextField!
    
    var goalDescription: String!
    var goalType: GoalType!
    
    
    func initData(description: String, type: GoalType) {
        self.goalDescription = description
        self.goalType = type
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createGoalBtn.bindToKeyboard()
    }

    @IBAction func createGoalBtnWasPressed(_ sender: Any) {
        //Pass data into the Core Data Goal Model
    }
    
}
