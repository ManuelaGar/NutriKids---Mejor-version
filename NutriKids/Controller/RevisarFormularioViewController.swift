//
//  RevisarFormularioViewController.swift
//  NutriKids
//
//  Created by Manuela Garcia on 9/08/18.
//  Copyright © 2018 Manuela Garcia. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class RevisarFormularioViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var nombre: UITextField!
    @IBOutlet weak var apellidos: UITextField!
    @IBOutlet weak var ID: UITextField!
    @IBOutlet weak var fechaNacimiento: UITextField!
    @IBOutlet weak var sexo: UITextField!
    @IBOutlet weak var pesoKg: UITextField!
    
    var ref: DatabaseReference!
    let userID = Auth.auth().currentUser?.uid
    
    override func viewDidLoad() {
        super.viewDidLoad()
        retrieveUserInfo()
        SVProgressHUD.dismiss()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //Para esconder el teclado si toca por fuera de este
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //Para esconder el teclado si presiona enter
        nombre.resignFirstResponder()
        apellidos.resignFirstResponder()
        ID.resignFirstResponder()
        fechaNacimiento.resignFirstResponder()
        sexo.resignFirstResponder()
        pesoKg.resignFirstResponder()
        
        return true
    }
    
    @IBAction func salirPressed(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
        }
        catch {
            print("Error, hubo un problema al salir.")
        }
    }
    
    func retrieveUserInfo() {
        Database.database().reference().child("Usuarios").child(userID!).observeSingleEvent(of: .value) { (snapshot) in
            print("Informacion recuperada")
            self.nombre.text = snapshot.childSnapshot(forPath: "Nombre").value as? String
            self.apellidos.text = snapshot.childSnapshot(forPath: "Apellidos").value as? String
            self.ID.text = snapshot.childSnapshot(forPath: "ID").value as? String
            self.fechaNacimiento.text = snapshot.childSnapshot(forPath: "Fecha nacimiento").value as? String
            self.sexo.text = snapshot.childSnapshot(forPath: "Sexo").value as? String
            self.pesoKg.text = snapshot.childSnapshot(forPath: "PesoKg").value as? String
        }
    }
    
    
    @IBAction func editarPressed(_ sender: UIBarButtonItem) {
        nombre.isEnabled = true
        apellidos.isEnabled = true
        ID.isEnabled = true
        fechaNacimiento.isEnabled = true
        sexo.isEnabled = true
        pesoKg.isEnabled = true
        
        nombre.textColor = UIColor.black
        apellidos.textColor = UIColor.black
        ID.textColor = UIColor.black
        fechaNacimiento.textColor = UIColor.black
        sexo.textColor = UIColor.black
        pesoKg.textColor = UIColor.black
    }
    
    
    @IBAction func continuarPressed(_ sender: UIButton) {
        SVProgressHUD.show()
        
        nombre.isEnabled = false
        apellidos.isEnabled = false
        ID.isEnabled = false
        fechaNacimiento.isEnabled = false
        sexo.isEnabled = false
        pesoKg.isEnabled = false
        
        nombre.textColor = UIColor.gray
        apellidos.textColor = UIColor.gray
        ID.textColor = UIColor.gray
        fechaNacimiento.textColor = UIColor.gray
        sexo.textColor = UIColor.gray
        pesoKg.textColor = UIColor.gray
        
        Database.database().reference().child("Usuarios").child(userID!).updateChildValues(
            [
                "Nombre": nombre.text! as NSString,
                "Apellidos": apellidos.text! as NSString,
                "ID": ID.text! as NSString,
                "Fecha nacimiento": fechaNacimiento.text! as NSString,
                "Sexo": sexo.text! as NSString,
                "PesoKg": pesoKg.text! as NSString
            ])
        
        print("Usuario actualizado y guardado con exito")
        
        performSegue(withIdentifier: "goToMediciones", sender: self)
    }
    
}
