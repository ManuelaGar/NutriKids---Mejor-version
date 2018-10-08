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
    @IBOutlet weak var estatura: UITextField!
    @IBOutlet weak var perimetroCefalico: UITextField!
    @IBOutlet weak var perimetroBraquial: UITextField!
    @IBOutlet weak var continuarBtn: UIButton!
    
    
    var sexo = ""
    var edadMeses = ""
    var fechaDeNacimiento = ""
    var tipoMedida = 0
    var estaturaMedida: Float = 0
    var MUAC: Float = 0
    var perimetroC: Float = 0
    var cmX: Float = 0
    var cmY: Float = 0
    var aux = 0
    
    var ref: DatabaseReference!
    let userID = Auth.auth().currentUser?.uid
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        continuarBtn.isEnabled = false
        
        self.nombreBtn.delegate = self
        self.apellidosBtn.delegate = self
        self.ID.delegate = self
        self.edadDD.delegate = self
        self.edadMM.delegate = self
        self.edadA.delegate = self
        self.estatura.delegate = self
        self.perimetroBraquial.delegate = self
        
        SVProgressHUD.dismiss()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if (self.aux == 0) {
            self.estatura.text = ""
            self.perimetroBraquial.text = ""
            aux = 1
        } else {
            perimetroC = UserDefaults.standard.float(forKey: "PerCef")/10
            MUAC = UserDefaults.standard.float(forKey: "MUAC")/10
            cmX = UserDefaults.standard.float(forKey: "mmEnX")/10
            cmY = UserDefaults.standard.float(forKey: "mmEnY")/10
            
            if cmX != 0 && cmY != 0 {
                estatura.text = "\(cmX)"
            }
            if MUAC != 0 {
                perimetroBraquial.text = "\(MUAC)"
            }
            if perimetroC != 0 {
                perimetroCefalico.text = "\(perimetroC)"
            }
        }
        check()
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
            resultados.pesoKgMedido = Float(self.PesoKg.text!) ?? 0
            resultados.estaturaMedida = Float(self.estatura.text!) ?? 0
            resultados.perimetroBraquialMedido = Float(self.perimetroBraquial.text!) ?? 0
            resultados.edadEnMeses = Int(self.edadMeses) ?? 0
            resultados.sexo = self.sexo
            resultados.pCefMedido = Float(self.perimetroCefalico.text!) ?? 0
        }
    }
    
    func check() {
        if nombreBtn.hasText && apellidosBtn.hasText && ID.hasText && edadDD.hasText && edadMM.hasText && edadA.hasText && sexo != "" && PesoKg.hasText && estatura.hasText && perimetroBraquial.hasText && perimetroCefalico.hasText {
            continuarBtn.isEnabled = true
            continuarBtn.backgroundColor = UIColor(red:0.00, green:0.10, blue:0.58, alpha:1.0)
        }
        else {
            continuarBtn.isEnabled = false
            continuarBtn.backgroundColor = UIColor.lightGray
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == nombreBtn || textField == apellidosBtn || textField == ID || textField == edadDD || textField == edadMM
            || textField == edadA || textField == PesoKg || textField == estatura || textField == perimetroBraquial || textField == perimetroCefalico {
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
        } else if sender.tag == 2 {
            print("Perimetro cefalico")
            tipoMedida = 3
            performSegue(withIdentifier: "goToMediciones", sender: self)
        }
    }
    
    
    //TODO: Terminar las condiciones de esta view (fecha de edad no mas de 60...)
    func verificacion() {
        
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
        estatura.isEnabled = false
        perimetroBraquial.isEnabled = false

        let currentDate = NSCalendar.init(calendarIdentifier: NSCalendar.Identifier.gregorian)

        if edadMM.hasText && edadA.hasText && edadDD.hasText {
            let currentYear = (currentDate?.component(NSCalendar.Unit.year, from: Date()) ?? 0)
            let currentMonth = currentDate?.component(NSCalendar.Unit.month, from: Date()) ?? 0
            print(currentYear)
            print(currentMonth)
            edadMeses = String((currentMonth - Int(edadMM.text!)!) + (currentYear - Int(edadA.text!)!)*12)
        }

        fechaDeNacimiento = "\(edadDD.text!)/\(edadMM.text!)/\(edadA.text!)"
        
        Database.database().reference().child("Usuarios").child(userID!).updateChildValues(
            [
                "Nombre": nombreBtn.text! as NSString,
                "Apellidos": apellidosBtn.text! as NSString,
                "ID": ID.text! as NSString,
                "Fecha nacimiento": fechaDeNacimiento,
                "Edad meses": String(edadMeses),
                "Sexo": sexo,
                "PesoKg": PesoKg.text! as NSString,
                "Estatura": estatura.text! as NSString,
                "MUAC": perimetroBraquial.text! as NSString,
                "P Cefalico": perimetroCefalico.text! as NSString
            ])

        performSegue(withIdentifier: "goToResultados", sender: self)
    }
    
}
