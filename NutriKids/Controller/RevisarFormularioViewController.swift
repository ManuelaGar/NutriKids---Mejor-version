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
    @IBOutlet weak var edadDD: UITextField!
    @IBOutlet weak var edadMM: UITextField!
    @IBOutlet weak var edadA: UITextField!
    @IBOutlet weak var sexo: UITextField!
    @IBOutlet weak var pesoKg: UITextField!
    @IBOutlet weak var estatura: UITextField!
    @IBOutlet weak var perimetroBraquial: UITextField!
    @IBOutlet weak var continuarBtn: UIButton!
    @IBOutlet weak var medicion1: UIButton!
    @IBOutlet weak var medicion2: UIButton!
    @IBOutlet weak var MasculinoBtn: UIButton!
    @IBOutlet weak var FemeninoBtn: UIButton!
    @IBOutlet weak var stackFecha: UIStackView!
    
    
    var tipoMedida = 0
    var MUAC: Float = 0
    var cmX: Float = 0
    var cmY: Float = 0
    var edadMeses = 0
    var fechaDeNacimiento = ""
    var sexoMF = ""
    var aux = 0
    var ref: DatabaseReference!
    let userID = Auth.auth().currentUser?.uid
    
    override func viewDidLoad() {
        super.viewDidLoad()
        retrieveUserInfo()
        
        continuarBtn.isEnabled = true
        continuarBtn.backgroundColor = UIColor(red:0.00, green:0.10, blue:0.58, alpha:1.0)
        
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
        if (self.aux == 0) {
            aux = 1
        } else {
            MUAC = UserDefaults.standard.float(forKey: "MUAC")/10
            cmX = UserDefaults.standard.float(forKey: "mmEnX")/10
            cmY = UserDefaults.standard.float(forKey: "mmEnY")/10
            if cmX != 0 && cmY != 0 {
                estatura.text = "\(cmX)"
            }
            if MUAC != 0 {
                perimetroBraquial.text = "\(MUAC)"
            }
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
            let resultados = segue.destination as! ResultadosViewController
            resultados.pesoKgMedido = Float(self.pesoKg.text!) ?? 0
            resultados.estaturaMedida = Float(self.estatura.text!) ?? 0
            resultados.perimetroBraquialMedido = Float(self.perimetroBraquial.text!) ?? 0
            resultados.edadEnMeses = self.edadMeses
            resultados.sexo = self.sexoMF
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
            self.sexoMF = (snapshot.childSnapshot(forPath: "Sexo").value as? String ?? "")
            self.pesoKg.text = snapshot.childSnapshot(forPath: "PesoKg").value as? String
            self.estatura.text = snapshot.childSnapshot(forPath: "Estatura").value as? String
            self.perimetroBraquial.text = snapshot.childSnapshot(forPath: "MUAC").value as? String
            self.edadMeses = snapshot.childSnapshot(forPath: "Edad meses").value as? Int ?? 0
            self.fechaDeNacimiento = snapshot.childSnapshot(forPath: "Fecha nacimiento").value as? String ?? ""
        }
        SVProgressHUD.dismiss()
    }
    
    func check() {
        if nombre.hasText && apellidos.hasText && ID.hasText && edadMM.hasText && edadA.hasText && edadDD.hasText && sexoMF != "" && pesoKg.hasText && estatura.hasText && perimetroBraquial.hasText {
            continuarBtn.isEnabled = true
            continuarBtn.backgroundColor = UIColor(red:0.00, green:0.10, blue:0.58, alpha:1.0)
        }
        else {
            continuarBtn.isEnabled = false
            continuarBtn.backgroundColor = UIColor.lightGray
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == nombre || textField == apellidos || textField == ID || textField == edadDD || textField == edadMM || textField == edadA || textField == pesoKg || textField == estatura || textField == perimetroBraquial {
            check()
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
    
    
    @IBAction func sexoBtnPressed(_ sender: UIButton) {
        if sender.tag == 1 {
            sexoMF = "Masculino"
            MasculinoBtn.backgroundColor = UIColor(red:0.00, green:0.10, blue:0.58, alpha:1.0)
            FemeninoBtn.backgroundColor = UIColor.lightGray
        } else if sender.tag == 2 {
            sexoMF = "Femenino"
            FemeninoBtn.backgroundColor = UIColor(red:0.00, green:0.10, blue:0.58, alpha:1.0)
            MasculinoBtn.backgroundColor = UIColor.lightGray
        }
    }
    
    @IBAction func editarPressed(_ sender: UIBarButtonItem) {
        let fecha = fechaDeNacimiento.components(separatedBy: "/")
        edadDD.text = fecha[0]
        edadMM.text = fecha[1]
        edadA.text = fecha[2]
        
        if sexoMF == "Masculino" {
            MasculinoBtn.backgroundColor = UIColor(red:0.00, green:0.10, blue:0.58, alpha:1.0)
            FemeninoBtn.backgroundColor = UIColor.lightGray
        } else if sexoMF == "Femenino" {
            FemeninoBtn.backgroundColor = UIColor(red:0.00, green:0.10, blue:0.58, alpha:1.0)
            MasculinoBtn.backgroundColor = UIColor.lightGray
        }
        
        nombre.isEnabled = true
        apellidos.isEnabled = true
        ID.isEnabled = true
        fechaNacimiento.isHidden = true
        stackFecha.isHidden = false
        sexo.isHidden = true
        MasculinoBtn.isHidden = false
        FemeninoBtn.isHidden = false
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
        pesoKg.isEnabled = false
        estatura.isEnabled = false
        perimetroBraquial.isEnabled = false
        
        nombre.textColor = UIColor.gray
        apellidos.textColor = UIColor.gray
        ID.textColor = UIColor.gray
        pesoKg.textColor = UIColor.gray
        estatura.textColor = UIColor.gray
        perimetroBraquial.textColor = UIColor.gray
        
        let currentDate = NSCalendar.init(calendarIdentifier: NSCalendar.Identifier.gregorian)
        let currentYear = (currentDate?.component(NSCalendar.Unit.year, from: Date()) ?? 0)
        let currentMonth = currentDate?.component(NSCalendar.Unit.month, from: Date()) ?? 0
        print(currentYear)
        print(currentMonth)
        edadMeses = (currentMonth - Int(edadMM.text!)!) + (currentYear - Int(edadA.text!)!)*12
        fechaDeNacimiento = "\(edadDD.text!)/\(edadMM.text!)/\(edadA.text!)"
        
        Database.database().reference().child("Usuarios").child(userID!).updateChildValues(
            [
                "Nombre": nombre.text! as NSString,
                "Apellidos": apellidos.text! as NSString,
                "ID": ID.text! as NSString,
                "Fecha nacimiento": fechaDeNacimiento,
                "Edad meses": String(edadMeses),
                "Sexo": sexoMF,
                "PesoKg": pesoKg.text! as NSString,
                "Estatura": estatura.text! as NSString,
                "MUAC": perimetroBraquial.text! as NSString
            ])
        
        print("Usuario actualizado y guardado con exito")
        
        performSegue(withIdentifier: "goToResultados", sender: self)
    }
    
}
