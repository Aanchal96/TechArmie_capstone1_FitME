//
//  SettingsViewController.swift
//  TechArmie_capstone1_FitME
//
//  Created by Macbbok Pro on 2022-07-25.
//

import UIKit

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func toAccountSettings(_ sender: UIButton) {
        let storyboard = self.storyboard?.instantiateViewController(withIdentifier: "ASettings") as! ASettings
        self.navigationController?.pushViewController(vc, animated: true)
        //
        //    self.present(vc, animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
