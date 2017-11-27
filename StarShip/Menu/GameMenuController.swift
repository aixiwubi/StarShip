//
//  GameMenuController.swift
//  StarShip
//
//  Created by Wendong Yang on 11/27/17.
//  Copyright © 2017 Wendong Yang. All rights reserved.
//

import UIKit

class GameMenuController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var gameScenes:[String]?
    var progress: GameProgressManager = GameProgressManager.sharedInstance
    override func viewDidLoad() {
        super.viewDidLoad()
        gameScenes = progress.getProgress()
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gameScenes?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "basic", for: indexPath)
        if let gameScenes = gameScenes{
            cell.textLabel?.text = gameScenes[indexPath.row]
        }
        return cell
       
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
