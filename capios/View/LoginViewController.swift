//
//  LoginViewController.swift
//  capios
//
//  Created by ALUNO on 12/06/19.
//  Copyright © 2019 Adriano. All rights reserved.
//

import UIKit
import Valet
import RxCocoa
import RxSwift

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameTxtField: UITextField!
    @IBOutlet weak var passwordTxtField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    var fieldsAreValid: Variable<Bool> = Variable<Bool>(false)
    var disposeBag : DisposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButton.rx.tap.subscribe(onNext: {
            guard let identifier = Identifier(nonEmpty: "Database") else {
                return
            }
            let  valet = Valet.valet(with: identifier, accessibility: .whenUnlocked)
            if let username = valet.string(forKey: R.string.main.valetUsername()),
                let password = valet.string(forKey: R.string.main.valetPassword()),
                username == self.usernameTxtField.text,
                password == self.passwordTxtField.text{
                //let vc = R.storyboard.trainingExercises.
                if let vc = R.storyboard.trainingExercises.menuViewController(){
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                
            }else{
                let alert : UIAlertController = UIAlertController(title: R.string.main.loginAlertTitle(), message: R.string.main.loginAlertFail(), preferredStyle: .alert)
                let alertAction : UIAlertAction = UIAlertAction(title: R.string.main.okAlertTitle(), style: .default, handler: { _ in})
                alert.addAction(alertAction)
                self.present(alert, animated: true)
            }
        }).disposed(by: disposeBag)
        
        self.bindUI()

    }
    
    
    func bindUI() {
        
        //Bind da variável fieldsAreValid, com a atributo hidden da label ErrorMessageLabel
        fieldsAreValid.asObservable().bind(to: self.loginButton.rx.isHidden).disposed(by: self.disposeBag)
        
        //Criação de um observable, para monitorar se os campos username e password estão com a contagem mínima de carateres necessária, para criar a conta em nosso ambiente simulado
        Observable.combineLatest(usernameTxtField.rx.text,
                                 passwordTxtField.rx.text) {
                                    username, password -> Bool in
                                    //Esse bloco de código será chamado, sempre que houver uma alteração nos valores 'text', dos textfields, usernameTxtField e passwordTxtField
                                    //Nesse if é verificado se o campo 'text' dos textFields é válido, ou seja, 'not nil'
                                    if let _username = username,
                                        let _password = password {
                                        //Se os valores não forem nulos, então nós verificamos se os campos estão respeitando as regras de criação de conta que foi estipulada
                                        return _username.count < 6 || _password.count < 6
                                    }
                                    return false
            }.bind(to: fieldsAreValid)
            .disposed(by: self.disposeBag)
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
