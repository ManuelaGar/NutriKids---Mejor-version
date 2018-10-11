//
//  LlenarFormularioViewController.swift
//  NutriKids
//
//  Created by Manuela Garcia on 9/08/18.
//  Copyright © 2018 Manuela Garcia. All rights reserved.
//

import UIKit
import WebKit
import Firebase
import SVProgressHUD

class LlenarFormularioViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var nombreBtn: UITextField!
    @IBOutlet weak var apellidosBtn: UITextField!
    @IBOutlet weak var ID: UITextField!
    @IBOutlet weak var edadDD: UITextField!
    @IBOutlet weak var edadMM: UITextField!
    @IBOutlet weak var edadA: UITextField!
    @IBOutlet weak var alertaEdad: UILabel!
    @IBOutlet weak var PesoKg: UITextField!
    @IBOutlet weak var masculinoBtn: UIButton!
    @IBOutlet weak var femeninoBtn: UIButton!
    @IBOutlet weak var estatura: UITextField!
    @IBOutlet weak var perimetroCefalico: UITextField!
    @IBOutlet weak var perimetroBraquial: UITextField!
    @IBOutlet weak var continuarBtn: UIButton!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    var sexo = ""
    var edadMeses = ""
    var fechaDeNacimiento = ""
    var date = ""
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
        
        self.scrollView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(keyBoardHideOnTap))
        tap.numberOfTapsRequired = 1
        self.scrollView.addGestureRecognizer(tap)
        
        continuarBtn.isEnabled = false
        
        self.nombreBtn.delegate = self
        self.apellidosBtn.delegate = self
        self.ID.delegate = self
        self.edadDD.delegate = self
        self.edadMM.delegate = self
        self.edadA.delegate = self
        self.PesoKg.delegate = self
        self.estatura.delegate = self
        self.perimetroBraquial.delegate = self
        self.perimetroCefalico.delegate = self
        
        SVProgressHUD.dismiss()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addObservers()
        alertaEdad.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeObservers()
    }

    func addObservers() {
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: nil) { (notification) in
            self.keyboardWillShow(notification: notification)
        }
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: nil) { (notification) in
            self.keyboardWillHide(notification: notification)
        }
    }
    
    func removeObservers() {
        NotificationCenter.default.removeObserver(self)
    }
    
    func keyboardWillShow(notification: Notification) {
        guard let userInfo = notification.userInfo,
            let frame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
                return
        }
        let contentInset = UIEdgeInsets(top: 0, left: 0, bottom: frame.height, right: 0)
        scrollView.contentInset = contentInset
    }
    
    func keyboardWillHide(notification: Notification) {
        scrollView.contentInset = UIEdgeInsets.zero
    }
    
    @objc func keyBoardHideOnTap() {
        // do something cool here
        self.scrollView.endEditing(true)
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
        if edadDD.hasText {
            print(edadDD.text!)
            if (Int(edadDD.text!) ?? 0) >= 32 {
                edadDD.text = ""
                alertaEdad.isHidden = false
                alertaEdad.text = "*El día no puede ser mayor a 31"
            } else {
                alertaEdad.isHidden = true
            }
        }
        if edadMM.hasText {
            print(edadMM.text!)
            if (Int(edadMM.text!) ?? 0) >= 13 {
                edadMM.text = ""
                alertaEdad.isHidden = false
                alertaEdad.text = "*El mes no puede ser mayor a 12"
            } else {
                alertaEdad.isHidden = true
            }
        }
        if edadA.hasText {
            let currentYear = NSCalendar.init(calendarIdentifier: NSCalendar.Identifier.gregorian)?.component(NSCalendar.Unit.year, from: Date()) ?? 0
            if ((Int(edadA.text!) ?? 0) < (currentYear - 5)) || ((Int(edadA.text!) ?? 0) > currentYear) {
                edadA.text = ""
                alertaEdad.isHidden = false
                alertaEdad.text = "*El año no puede ser menor a \(currentYear - 5) o mayor al actual"
            }
        }
        if edadDD.hasText && edadMM.hasText && edadA.hasText {
            edadEnMeses()
            if edadA.isEditing == false {
                if (Int(edadMeses) ?? 0) <= 60 {
                    alertaEdad.isHidden = true
                } else {
                    alertaEdad.text = "*El usuario debe ser menor a 5 años"
                    alertaEdad.isHidden = false
                }
            }
        }
        if nombreBtn.hasText && apellidosBtn.hasText && ID.hasText && edadDD.hasText && edadMM.hasText && edadA.hasText && sexo != "" && PesoKg.hasText && estatura.hasText {
            continuarBtn.isEnabled = true
            continuarBtn.backgroundColor = UIColor(red:0.00, green:0.10, blue:0.58, alpha:1.0)
            alertaEdad.isHidden = true
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
    
    func edadEnMeses() {
        let currentDate = NSCalendar.init(calendarIdentifier: NSCalendar.Identifier.gregorian)
        
        if edadMM.hasText && edadA.hasText && edadDD.hasText {
            let currentYear = currentDate?.component(NSCalendar.Unit.year, from: Date()) ?? 0
            let currentMonth = currentDate?.component(NSCalendar.Unit.month, from: Date()) ?? 0
            let currentDay = currentDate?.component(NSCalendar.Unit.day, from: Date()) ?? 0
            date = "\(currentDay)/\(currentMonth)/\(currentYear)"
            edadMeses = String((currentMonth - Int(edadMM.text!)!) + (currentYear - Int(edadA.text!)!)*12)
        }
        
        fechaDeNacimiento = "\(edadDD.text!)/\(edadMM.text!)/\(edadA.text!)"
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

        edadEnMeses()
        Database.database().reference().child("Usuarios").child(userID!).updateChildValues(
            [
                "Nombre": nombreBtn.text! as NSString,
                "Apellidos": apellidosBtn.text! as NSString,
                "ID": ID.text! as NSString,
                "Fecha nacimiento": fechaDeNacimiento,
                "Fecha examen": date,
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
