//
//  RegistroViewController.swift
//  NutriKids
//
//  Created by Manuela Garcia on 9/08/18.
//  Copyright © 2018 Manuela Garcia. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class RegistroViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var registrarseBtn: UIButton!
    @IBOutlet weak var mensaje: UILabel!
    
    var loc : [String : String] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        passwordTextField.delegate = self
//        registrarseBtn.isEnabled = false
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
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        
        return true
    }

    
    @IBAction func registrarsePressed(_ sender: AnyObject) {
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            if error != nil {
                //print(error!)
                let a = error?.localizedDescription
                print("\(a ?? "nada")")
                if a == "The email address is already in use by another account." {
                    // correo ya existente
                    self.mensaje.text = "*Este correo ya está en uso"
                } else if a == "The email address is badly formatted." {
                    // escriba un correo valido
                    self.mensaje.text = "*Escriba un correo válido"
                } else if a == "The password must be 6 characters long or more." {
                    // la contraseña debe tener al menos 6 caracteres
                    self.mensaje.text = "*La contraseña debe tener al menos 6 caracteres"
                }
                self.mensaje.isHidden = false
            }
            else {
                print("Registro Exitoso")
                print(self.loc)
                
                let usuariosDB = Database.database().reference().child("Usuarios")
                let usuarioDiccionario =
                    [
                        "Email": Auth.auth().currentUser?.email! as Any,
                        "Nombre": "",
                        "Apellidos": "",
                        "ID": "",
                        "Sexo": "",
                        "Fecha nacimiento": "",
                        "Fecha examen": "",
                        "Edad meses": "",
                        "PesoKg": "",
                        "Estatura": "",
                        "MUAC": "",
                        "IMC": "",
                        "P Cefalico": "",
                        "Imagen": "",
                        "Resultado": "",
                        "Ubicacion": self.loc
                        ] as [String : Any]
                let userID = Auth.auth().currentUser?.uid
                usuariosDB.child(userID!).setValue(usuarioDiccionario) {
                    (error, reference) in
                    
                    if error != nil {
                        print(error!)
                    } else {
                        print("Usuario creado con exito")
                    }
                }
                
                SVProgressHUD.show()
                self.mensaje.isHidden = true
                self.performSegue(withIdentifier: "goToFormulario", sender: self)
            }
        }
    }
}
