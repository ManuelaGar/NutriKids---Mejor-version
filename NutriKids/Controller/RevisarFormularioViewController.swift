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
    @IBOutlet weak var estatura: UITextField!
    @IBOutlet weak var perimetroBraquial: UITextField!
    @IBOutlet weak var continuarBtn: UIButton!
    @IBOutlet weak var medicion1: UIButton!
    @IBOutlet weak var medicion2: UIButton!
    
    var tipoMedida = 0
    var MUAC: Float = 0
    var mmX: Float = 0
    var mmY: Float = 0
    var ref: DatabaseReference!
    let userID = Auth.auth().currentUser?.uid
    
    override func viewDidLoad() {
        super.viewDidLoad()
        retrieveUserInfo()
        SVProgressHUD.dismiss()
        continuarBtn.isEnabled = false
        medicion1.isEnabled = false
        medicion2.isEnabled = false
        
        nombre.delegate = self
        apellidos.delegate = self
        ID.delegate = self
        fechaNacimiento.delegate = self
        sexo.delegate = self
        pesoKg.delegate = self
        estatura.delegate = self
        perimetroBraquial.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        MUAC = UserDefaults.standard.float(forKey: "MUAC")
        mmX = UserDefaults.standard.float(forKey: "mmEnX")
        mmY = UserDefaults.standard.float(forKey: "mmEnY")
        
        if mmX != 0 && mmY != 0 {
            estatura.text = "\(mmX)"
        }
        if MUAC != 0 {
            perimetroBraquial.text = "\(MUAC)"
        }
        
        if check() {
            continuarBtn.isEnabled = true
            continuarBtn.backgroundColor = UIColor(red:0.00, green:0.10, blue:0.58, alpha:1.0)
        }
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
        estatura.resignFirstResponder()
        perimetroBraquial.resignFirstResponder()
        
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToMediciones" {
            let vc = segue.destination as! SeleccionarMedidaViewController
            
            vc.tipoMedida = self.tipoMedida
        } else if segue.identifier == "goToResultados" {
            // cuando esten todos los campos llenos
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
            self.estatura.text = snapshot.childSnapshot(forPath: "Estatura").value as? String
            self.perimetroBraquial.text = snapshot.childSnapshot(forPath: "MUAC").value as? String
        }
    }
    
    func check() -> Bool {
        if nombre.text != "" && apellidos.text != "" && ID.text != "" && fechaNacimiento.text != "" && sexo.text != "" && pesoKg.text != "" && estatura.text != "" && perimetroBraquial.text != "" {
            return true
        }
        else {
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if check() {
            continuarBtn.isEnabled = true
            continuarBtn.backgroundColor = UIColor(red:0.00, green:0.10, blue:0.58, alpha:1.0)
        }
    }
    
    @IBAction func medirPressed(_ sender: UIButton) {
        if sender.tag == 0 {
            // estatura
            print("Estatura")
            tipoMedida = 1
            performSegue(withIdentifier: "goToMediciones", sender: self)
        } else if sender.tag == 1 {
            // MUAC
            print("MUAC")
            tipoMedida = 2
            performSegue(withIdentifier: "goToMediciones", sender: self)
        }
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
    
    @IBAction func editarPressed(_ sender: UIBarButtonItem) {
        nombre.isEnabled = true
        apellidos.isEnabled = true
        ID.isEnabled = true
        fechaNacimiento.isEnabled = true
        sexo.isEnabled = true
        pesoKg.isEnabled = true
        estatura.isEnabled = true
        perimetroBraquial.isEnabled = true
        
        medicion1.isEnabled = true
        medicion2.isEnabled = true
        medicion1.backgroundColor = UIColor(red:0.00, green:0.10, blue:0.58, alpha:1.0)
        medicion2.backgroundColor = UIColor(red:0.00, green:0.10, blue:0.58, alpha:1.0)
        
        nombre.textColor = UIColor.black
        apellidos.textColor = UIColor.black
        ID.textColor = UIColor.black
        fechaNacimiento.textColor = UIColor.black
        sexo.textColor = UIColor.black
        pesoKg.textColor = UIColor.black
        estatura.textColor = UIColor.black
        perimetroBraquial.textColor = UIColor.black
    }
    
    
    @IBAction func continuarPressed(_ sender: UIButton) {
        SVProgressHUD.show()
        
        nombre.isEnabled = false
        apellidos.isEnabled = false
        ID.isEnabled = false
        fechaNacimiento.isEnabled = false
        sexo.isEnabled = false
        pesoKg.isEnabled = false
        estatura.isEnabled = false
        perimetroBraquial.isEnabled = false
        
        nombre.textColor = UIColor.gray
        apellidos.textColor = UIColor.gray
        ID.textColor = UIColor.gray
        fechaNacimiento.textColor = UIColor.gray
        sexo.textColor = UIColor.gray
        pesoKg.textColor = UIColor.gray
        estatura.textColor = UIColor.gray
        perimetroBraquial.textColor = UIColor.gray
        Database.database().reference().child("Usuarios").child(userID!).updateChildValues(
            [
                "Nombre": nombre.text! as NSString,
                "Apellidos": apellidos.text! as NSString,
                "ID": ID.text! as NSString,
                "Fecha nacimiento": fechaNacimiento.text! as NSString,
                "Sexo": sexo.text! as NSString,
                "PesoKg": pesoKg.text! as NSString,
                "Estatura": estatura.text! as NSString,
                "MUAC": perimetroBraquial.text! as NSString
            ])
        
        print("Usuario actualizado y guardado con exito")
        
        performSegue(withIdentifier: "goToResultados", sender: self)
    }
    
}
