//
//  IniciarSesionViewController.swift
//  NutriKids
//
//  Created by Manuela Garcia on 9/08/18.
//  Copyright © 2018 Manuela Garcia. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class IniciarSesionViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var inicioSesionBtn: UIButton!
    @IBOutlet weak var mensaje: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        passwordTextField.delegate = self
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
            inicioSesionBtn.isEnabled = false
            inicioSesionBtn.backgroundColor = UIColor.lightGray
        }
        if emailTextField.hasText && passwordTextField.hasText {
            self.inicioSesionBtn.isEnabled = true
            self.mensaje.isHidden = true
            self.inicioSesionBtn.backgroundColor = UIColor(red:0.00, green:0.10, blue:0.58, alpha:1.0)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == emailTextField || textField == passwordTextField {
            verificacion()
        }
    }
    
    @IBAction func iniciarSesionPressed(_ sender: AnyObject) {
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            if error != nil {
//                print(error!)
                let a = error?.localizedDescription
                print(a!)
                if a == "The email address is badly formatted." {
                    self.mensaje.text = "*Escriba un correo válido"
                } else if a == "The password is invalid or the user does not have a password." {
                    self.mensaje.text = "*Contraseña invalida"
                }
                self.mensaje.isHidden = false
            } else {
                print("Inicio de sesion exitosa")
                SVProgressHUD.show()
                self.performSegue(withIdentifier: "goToFormulario2", sender: self)
            }
        }
        
    }
    
}
