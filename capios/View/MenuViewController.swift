//
//  MenuViewController.swift
//  capios
//
//  Created by ALUNO on 14/06/19.
//  Copyright © 2019 Adriano. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
class MenuViewController: UIViewController {
    @IBOutlet weak var menuLabel: UILabel!{
        didSet{
            menuLabel.font = UIFont(name: R.string.main.menuTitleFont(), size: 40)
        }
    }
    @IBOutlet weak var contactButton: UIButton!
    
    let disposeBag : DisposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = R.string.main.menuViewTitle()
        contactButton.center = self.view.center
        contactButton.rx.tap.subscribe( onNext:{
            [weak self] in
            guard let `self` = self else {return}
            if let vc = R.storyboard.trainingExercises.contactTableViewController(){
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }).disposed(by: disposeBag)
        

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
