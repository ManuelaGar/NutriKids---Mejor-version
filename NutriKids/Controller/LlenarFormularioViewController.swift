//
//  LlenarFormularioViewController.swift
//  NutriKids
//
//  Created by Manuela Garcia on 9/08/18.
//  Copyright © 2018 Manuela Garcia. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class LlenarFormularioViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var nombreBtn: UITextField!
    @IBOutlet weak var apellidosBtn: UITextField!
    @IBOutlet weak var ID: UITextField!
    @IBOutlet weak var edadDD: UITextField!
    @IBOutlet weak var edadMM: UITextField!
    @IBOutlet weak var edadA: UITextField!
    @IBOutlet weak var PesoKg: UITextField!
    @IBOutlet weak var masculinoBtn: UIButton!
    @IBOutlet weak var femeninoBtn: UIButton!
    
    
    var sexo = ""
    var edadMeses = ""
    var fechaDeNacimiento = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.nombreBtn.delegate = self
        self.apellidosBtn.delegate = self
        self.ID.delegate = self
        self.edadDD.delegate = self
        self.edadMM.delegate = self
        self.edadA.delegate = self
        
        SVProgressHUD.dismiss()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func salirPressed(_ sender: AnyObject) {
        do {
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
        }
        catch {
            print("Error, hubo un problema al salir.")
        }
    }
    
    @IBAction func masculinoPressed(_ sender: UIButton) {
        sexo = "Masculino"
        masculinoBtn.backgroundColor = UIColor(red:0.00, green:0.10, blue:0.58, alpha:1.0)
        femeninoBtn.backgroundColor = UIColor.lightGray
    }
    
    @IBAction func femeninoPressed(_ sender: UIButton) {
        sexo = "Femenino"
        femeninoBtn.backgroundColor = UIColor(red:0.00, green:0.10, blue:0.58, alpha:1.0)
        masculinoBtn.backgroundColor = UIColor.lightGray
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //Para esconder el teclado si toca por fuera de este
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //Para esconder el teclado si presiona enter
        nombreBtn.resignFirstResponder()
        apellidosBtn.resignFirstResponder()
        ID.resignFirstResponder()
        edadDD.resignFirstResponder()
        edadMM.resignFirstResponder()
        edadA.resignFirstResponder()
        PesoKg.resignFirstResponder()
        
        return true
    }
    
    @IBAction func continuarPressed(_ sender: UIButton) {
        SVProgressHUD.show()
        
        nombreBtn.isEnabled = false
        apellidosBtn.isEnabled = false
        ID.isEnabled = false
        edadDD.isEnabled = false
        edadMM.isEnabled = false
        edadA.isEnabled = false
        PesoKg.isEnabled = false
        
        
        let currentDate = NSCalendar.init(calendarIdentifier: NSCalendar.Identifier.gregorian)
        
        if edadMM.hasText && edadA.hasText && edadDD.hasText {
            let currentYear = (currentDate?.component(NSCalendar.Unit.year, from: Date()) ?? 0)
            let currentMonth = currentDate?.component(NSCalendar.Unit.month, from: Date()) ?? 0
            print(currentYear)
            print(currentMonth)
            edadMeses = String((currentMonth - Int(edadMM.text!)!) + (currentYear - Int(edadA.text!)!)*12)
        }
        
        fechaDeNacimiento = "\(edadDD.text!)/\(edadMM.text!)/\(edadA.text!)"
        
        let usuariosDB = Database.database().reference().child("Usuarios")
        let usuarioDiccionario =
            [
                "Email": Auth.auth().currentUser?.email,
                "Nombre": nombreBtn.text!,
                "Apellidos": apellidosBtn.text!,
                "ID": ID.text!,
                "Sexo": sexo,
                "Fecha nacimiento": fechaDeNacimiento,
                "Edad meses": edadMeses,
                "PesoKg": PesoKg.text!,
                "mmX": "",
                "mmY": "",
                "h": ""
            ]
        let userID = Auth.auth().currentUser?.uid
        usuariosDB.child(userID!).setValue(usuarioDiccionario) {
            (error, reference) in
            
            if error != nil {
                print(error!)
            } else {
                print("Usuario guardado con exito")
                self.nombreBtn.isEnabled = true
                self.apellidosBtn.isEnabled = true
                self.ID.isEnabled = true
                self.edadDD.isEnabled = true
                self.edadMM.isEnabled = true
                self.edadA.isEnabled = true
                
                self.nombreBtn.text = ""
                self.apellidosBtn.text = ""
                self.ID.text = ""
                self.edadDD.text = ""
                self.edadMM.text = ""
                self.edadA.text = ""
            }
        }
        performSegue(withIdentifier: "goToMediciones", sender: self)
    }
    
}
