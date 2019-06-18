//
//  ContactTableViewController.swift
//  capios
//
//  Created by ALUNO on 14/06/19.
//  Copyright © 2019 Adriano. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ContactTableViewController: UITableViewController {
    @IBOutlet weak var contactTableView: UITableView! {
        didSet {
            contactTableView.delegate = self
            contactTableView.dataSource = self
            contactTableView.register(R.nib.contactTableViewCell)
        }
    }
    
    var contactList : [Contact] = []
    var  indicator : UIActivityIndicatorView!
    let disposeBag : DisposeBag = DisposeBag()
    let api : ContactAPI = ContactAPI()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contactTableView.rx.itemSelected.subscribe( onNext: {
            [weak self] contactList in
        guard let `self` = self else{return}
            if let vc = R.storyboard.trainingExercises.contactViewController(){
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        }, onError: { [weak self] error  in
        guard let `self` = self else {return}
        }).disposed(by: disposeBag)
        
        self.title = R.string.main.contactViewTitle()
        self.createIndicator()
        indicator.startAnimating()
        api.rx_getContactData().subscribe(onNext: {
            [weak self] contactList in
            guard let `self` = self else{return}
            self.indicator.stopAnimating()
            self.contactList = contactList
            self.tableView.reloadData()
        }, onError: { [weak self] error  in
            guard let `self` = self else {return}
            self.indicator.stopAnimating()
        }).disposed(by: disposeBag)
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    func createIndicator(){
        indicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        indicator.hidesWhenStopped = true
        indicator.center = self.view.center
        indicator.transform = CGAffineTransform(scaleX: 3, y: 3)
        self.view.addSubview(indicator)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return contactList.count
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.contactTableViewCell.identifier, for: indexPath) as? ContactTableViewCell {
            cell.contactNameLabel.text = contactList[indexPath.row].contactName
            cell.contactPhoneNumberLabel.text = contactList[indexPath.row].contactPhoneNumber
            cell.contactAvatarImageView.image = contactList[indexPath.row].contactAvatar
            return cell
        }
        return UITableViewCell()
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
