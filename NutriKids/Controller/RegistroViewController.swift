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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        passwordTextField.delegate = self
        registrarseBtn.isEnabled = false
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

    func verificacion() {
        if emailTextField.text == "" || passwordTextField.text == "" {
            registrarseBtn.isEnabled = false
            registrarseBtn.backgroundColor = UIColor.lightGray
        }
        if emailTextField.hasText && passwordTextField.hasText {
            self.registrarseBtn.isEnabled = true
            self.mensaje.isHidden = true
            self.registrarseBtn.backgroundColor = UIColor(red:0.00, green:0.10, blue:0.58, alpha:1.0)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == emailTextField || textField == passwordTextField {
            verificacion()
        }
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
                
                let usuariosDB = Database.database().reference().child("Usuarios")
                let usuarioDiccionario =
                    [
                        "Email": Auth.auth().currentUser?.email! as Any,
                        "Nombre": "",
                        "Apellidos": "",
                        "ID": "",
                        "Sexo": "",
                        "Fecha nacimiento": "",
                        "Edad meses": "",
                        "PesoKg": "",
                        "Estatura": "",
                        "MUAC": "",
                        "P Cefalico": "",
                        "Imagen": "",
                        "Resultado": ""
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
