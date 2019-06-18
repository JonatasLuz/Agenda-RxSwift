//
//  CreateAccountViewController.swift
//  capios
//
//  Created by Francisco de Carvalho Costa Neto on 07/06/19.
//  Copyright © 2019 Adriano. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Valet

class CreateAccountViewController: UIViewController {
    @IBOutlet weak var usernameTxtField: UITextField!
    
    @IBOutlet weak var passwordTxtField: UITextField!
    
    @IBOutlet weak var errorMessageLabel: UILabel!
    
    @IBOutlet weak var createAccountButton: UIButton!
    
    let disposeBag: DisposeBag = DisposeBag()
    
    var observableValidateTextFields: Observable<Bool>?
    
    var fieldsAreValid: Variable<Bool> = Variable<Bool>(false)
    
    //Inicialização do Valet usando o construtor padrão valet, informando qual no 'identifier' o nome do sandbox que será criado e qual a 'accessibility' necessária para que o valet tenha acesso ao Keychain, nesse caso, o valet só terá acesso enquanto o device estiver desbloqueado.
    let valet: Valet = Valet.valet(with: Identifier(nonEmpty: "Database")!,
                                   accessibility: .whenUnlocked)

    override func viewDidLoad() {
        super.viewDidLoad()
        // Definição do título da tela na navigationBar
        self.title = R.string.main.createAccountViewTitle()
        
        //Função onde são realizados os binds de Rx
        self.bindUI()
    }
    
    func createAccount() -> Bool {
        if let username = usernameTxtField.text,
            let password = passwordTxtField.text{
            if valet.set(string: username, forKey: R.string.main.valetUsername()) == true,
                valet.set(string: password, forKey: R.string.main.valetPassword()) == true{
                return true
            }
        }
        return false
        //Se os campos estiverem válidos, essa função será chamada e é aqui que nós faremos o armazenamento dos dados no valet.
        
    }
    
    func createAccountAllert(alertText : String){
        let alert : UIAlertController = UIAlertController(title: R.string.main.newAccount(), message: alertText, preferredStyle: .alert)
        let okAction : UIAlertAction
        if alertText == R.string.main.creatAccountSucess(){
                okAction = UIAlertAction(title: R.string.main.okAlertTitle(), style: .default) { _ in
                    if let vc = R.storyboard.trainingExercises.homeViewController(){
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
            }
        }else{
                okAction  = UIAlertAction(title: R.string.main.okAlertTitle(), style: .default) { _ in}
        }
        alert.addAction(okAction)
        self.present(alert, animated: true)
    }
    
    func bindUI() {
        createAccountButton.rx.tap.subscribe(onNext: {
            //a declaração de weak self em closures, é necessária para evitar possível 'memory leak'
            [weak self] in
            // Um pequeno guard para garantir que o self ainda está disponível para uso
            guard let `self` = self else { return }
            
            if self.fieldsAreValid.value {
                if self.createAccount() == true{
                 self.createAccountAllert(alertText: R.string.main.creatAccountSucess())
                }else{
                    self.createAccountAllert(alertText: R.string.main.createAccountFail())
                }
            }else{
                self.createAccountAllert(alertText: R.string.main.createAccountFail())
            }
        }).disposed(by: self.disposeBag)
        
        //Bind da variável fieldsAreValid, com a atributo hidden da label ErrorMessageLabel
        fieldsAreValid.asObservable().bind(to: self.errorMessageLabel.rx.isHidden).disposed(by: self.disposeBag)
        
        //Criação de um observable, para monitorar se os campos username e password estão com a contagem mínima de carateres necessária, para criar a conta em nosso ambiente simulado
        Observable.combineLatest(usernameTxtField.rx.text,
                                 passwordTxtField.rx.text) {
            username, password -> Bool in
            //Esse bloco de código será chamado, sempre que houver uma alteração nos valores 'text', dos textfields, usernameTxtField e passwordTxtField
            //Nesse if é verificado se o campo 'text' dos textFields é válido, ou seja, 'not nil'
            if let _username = username,
                let _password = password {
                //Se os valores não forem nulos, então nós verificamos se os campos estão respeitando as regras de criação de conta que foi estipulada
                return _username.count >= 6 && _password.count >= 6
            }
            return false
        }.bind(to: fieldsAreValid)
        .disposed(by: self.disposeBag)
    }
}
