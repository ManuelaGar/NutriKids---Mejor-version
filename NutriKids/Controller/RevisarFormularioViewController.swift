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
    @IBOutlet weak var edadDD: UITextField!
    @IBOutlet weak var edadMM: UITextField!
    @IBOutlet weak var edadA: UITextField!
    @IBOutlet weak var alertaEdad: UILabel!
    @IBOutlet weak var pesoKg: UITextField!
    @IBOutlet weak var estatura: UITextField!
    @IBOutlet weak var perimetroBraquial: UITextField!
    @IBOutlet weak var perimetroCefalico: UITextField!
    @IBOutlet weak var continuarBtn: UIButton!
    @IBOutlet weak var medicion1: UIButton!
    @IBOutlet weak var medicion2: UIButton!
    @IBOutlet weak var medicion3: UIButton!
    @IBOutlet weak var MasculinoBtn: UIButton!
    @IBOutlet weak var FemeninoBtn: UIButton!
    @IBOutlet weak var stackFecha: UIStackView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var loc : [String : String] = [:]
    var date = ""
    
    var tipoMedida = 0
    var MUAC: Float = 0
    var perimetroC: Float = 0
    
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
        
        SVProgressHUD.dismiss()
        print(loc)
        
        self.scrollView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(keyBoardHideOnTap))
        tap.numberOfTapsRequired = 1
        self.scrollView.addGestureRecognizer(tap)
        
        continuarBtn.isEnabled = true
        continuarBtn.backgroundColor = UIColor(red:0.00, green:0.10, blue:0.58, alpha:1.0)
        
        medicion1.isEnabled = false
        medicion2.isEnabled = false
        medicion3.isEnabled = false
        
        nombre.delegate = self
        apellidos.delegate = self
        ID.delegate = self
        edadDD.delegate = self
        edadMM.delegate = self
        edadA.delegate = self
        pesoKg.delegate = self
        estatura.delegate = self
        perimetroBraquial.delegate = self
        perimetroCefalico.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        alertaEdad.isHidden = true
        retrieveUserInfo()
        addObservers()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if (self.aux == 0) {
            aux = 1
        } else {
            perimetroC = UserDefaults.standard.float(forKey: "PerCef")/10
            MUAC = UserDefaults.standard.float(forKey: "MUAC")/10
            cmX = UserDefaults.standard.float(forKey: "mmEnX")/10
            cmY = UserDefaults.standard.float(forKey: "mmEnY")/10
            if cmX != 0 && cmY != 0 {
                estatura.text = "\(cmY)"
            }
            if MUAC != 0 {
                perimetroBraquial.text = "\(MUAC)"
            }
            if perimetroC != 0 {
                perimetroCefalico.text = "\(perimetroC)"
            }
        }
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //Para esconder el teclado si presiona enter
        nombre.resignFirstResponder()
        apellidos.resignFirstResponder()
        ID.resignFirstResponder()
        pesoKg.resignFirstResponder()
        estatura.resignFirstResponder()
        edadDD.resignFirstResponder()
        edadMM.resignFirstResponder()
        edadA.resignFirstResponder()
        perimetroBraquial.resignFirstResponder()
        perimetroCefalico.resignFirstResponder()
        
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
            resultados.pCefMedido = Float(self.perimetroCefalico.text!) ?? 0
        }
    }
    
    func retrieveUserInfo() {
        Database.database().reference().child("Usuarios").child(userID!).observeSingleEvent(of: .value) { (snapshot) in
            print("Informacion recuperada")
            self.nombre.text = snapshot.childSnapshot(forPath: "Nombre").value as? String
            self.apellidos.text = snapshot.childSnapshot(forPath: "Apellidos").value as? String
            self.ID.text = snapshot.childSnapshot(forPath: "ID").value as? String
            self.sexoMF = (snapshot.childSnapshot(forPath: "Sexo").value as? String ?? "")
            self.pesoKg.text = snapshot.childSnapshot(forPath: "PesoKg").value as? String
            self.estatura.text = snapshot.childSnapshot(forPath: "Estatura").value as? String
            self.perimetroBraquial.text = snapshot.childSnapshot(forPath: "MUAC").value as? String
            self.perimetroCefalico.text = snapshot.childSnapshot(forPath: "P Cefalico").value as? String
            self.edadMeses = Int(snapshot.childSnapshot(forPath: "Edad meses").value as? String ?? "") ?? 0
            self.fechaDeNacimiento = snapshot.childSnapshot(forPath: "Fecha nacimiento").value as? String ?? ""
            self.date = snapshot.childSnapshot(forPath: "Fecha examen").value as? String ?? ""
            
            if self.sexoMF == "Masculino"{
                self.MasculinoBtn.backgroundColor = UIColor.darkGray
                self.FemeninoBtn.backgroundColor = UIColor.lightGray
            } else if self.sexoMF == "Femenino" {
                self.FemeninoBtn.backgroundColor = UIColor.darkGray
                self.MasculinoBtn.backgroundColor = UIColor.lightGray
            }
            let fecha = self.fechaDeNacimiento.components(separatedBy: "/")
            if fecha[0] != "" {
                self.edadDD.text = fecha[0]
                self.edadMM.text = fecha[1]
                self.edadA.text = fecha[2]
            }
        }
    }
    
    func check() {
        if nombre.hasText && apellidos.hasText && ID.hasText && fechaDeNacimiento != "" && sexoMF != "" && pesoKg.hasText && estatura.hasText {
            continuarBtn.isEnabled = true
            continuarBtn.backgroundColor = UIColor(red:0.00, green:0.10, blue:0.58, alpha:1.0)
        }
        else {
            continuarBtn.isEnabled = false
            continuarBtn.backgroundColor = UIColor.lightGray
        }
    }
    
    func checkEditar() {
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
            print("Edad en meses \(edadMeses)")
            if edadMeses <= 60 {
                alertaEdad.isHidden = true
                if nombre.hasText && apellidos.hasText && ID.hasText && edadMM.hasText && edadA.hasText && edadDD.hasText && sexoMF != "" && pesoKg.hasText && estatura.hasText {
                    continuarBtn.isEnabled = true
                    continuarBtn.backgroundColor = UIColor(red:0.00, green:0.10, blue:0.58, alpha:1.0)
                }
                else {
                    continuarBtn.isEnabled = false
                    continuarBtn.backgroundColor = UIColor.lightGray
                }
            } else {
                alertaEdad.isHidden = false
                alertaEdad.text = "*El usuario debe ser menor a 5 años"
                continuarBtn.isEnabled = false
                continuarBtn.backgroundColor = UIColor.lightGray
            }
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == nombre || textField == apellidos || textField == ID || textField == pesoKg || textField == estatura || textField == edadDD || textField == edadMM || textField == edadA {
            checkEditar()
        }
    }
    
    func edadEnMeses() {
        let currentDate = NSCalendar.init(calendarIdentifier: NSCalendar.Identifier.gregorian)
        
        if edadMM.hasText && edadA.hasText && edadDD.hasText {
            let currentYear = currentDate?.component(NSCalendar.Unit.year, from: Date()) ?? 0
            let currentMonth = currentDate?.component(NSCalendar.Unit.month, from: Date()) ?? 0
            let currentDay = currentDate?.component(NSCalendar.Unit.day, from: Date()) ?? 0
            date = "\(currentDay)/\(currentMonth)/\(currentYear)"
            edadMeses = (currentMonth - Int(edadMM.text!)!) + (currentYear - Int(edadA.text!)!)*12
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
            // Perimetro cefalico
            print("Perimetro Cefalico")
            tipoMedida = 3
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
        let currentDate = NSCalendar.init(calendarIdentifier: NSCalendar.Identifier.gregorian)
        let currentYear = currentDate?.component(NSCalendar.Unit.year, from: Date()) ?? 0
        let currentMonth = currentDate?.component(NSCalendar.Unit.month, from: Date()) ?? 0
        let currentDay = currentDate?.component(NSCalendar.Unit.day, from: Date()) ?? 0
        date = "\(currentDay)/\(currentMonth)/\(currentYear)"
        
        let fecha = fechaDeNacimiento.components(separatedBy: "/")
        if fecha[0] != "" {
            edadDD.text = fecha[0]
            edadMM.text = fecha[1]
            edadA.text = fecha[2]
        }
        
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
        edadDD.isEnabled = true
        edadMM.isEnabled = true
        edadA.isEnabled = true
        MasculinoBtn.isEnabled = true
        FemeninoBtn.isEnabled = true
        pesoKg.isEnabled = true
        estatura.isEnabled = true
        perimetroBraquial.isEnabled = true
        perimetroCefalico.isEnabled = true
        
        medicion1.isEnabled = true
        medicion2.isEnabled = true
        medicion3.isEnabled = true
        medicion1.backgroundColor = UIColor(red:0.00, green:0.10, blue:0.58, alpha:1.0)
        medicion2.backgroundColor = UIColor(red:0.00, green:0.10, blue:0.58, alpha:1.0)
        medicion3.backgroundColor = UIColor(red:0.00, green:0.10, blue:0.58, alpha:1.0)
        
        nombre.textColor = UIColor.black
        apellidos.textColor = UIColor.black
        ID.textColor = UIColor.black
        edadDD.textColor = UIColor.black
        edadMM.textColor = UIColor.black
        edadA.textColor = UIColor.black
        pesoKg.textColor = UIColor.black
        estatura.textColor = UIColor.black
        perimetroBraquial.textColor = UIColor.black
        perimetroCefalico.textColor = UIColor.black
        
        checkEditar()
    }
    
    
    @IBAction func continuarPressed(_ sender: UIButton) {
        SVProgressHUD.show()
        
        nombre.isEnabled = false
        apellidos.isEnabled = false
        ID.isEnabled = false
        edadDD.isEnabled = false
        edadMM.isEnabled = false
        edadA.isEnabled = false
        MasculinoBtn.isEnabled = false
        FemeninoBtn.isEnabled = false
        pesoKg.isEnabled = false
        estatura.isEnabled = false
        perimetroBraquial.isEnabled = false
        perimetroCefalico.isEnabled = false
        
        nombre.textColor = UIColor.gray
        apellidos.textColor = UIColor.gray
        ID.textColor = UIColor.gray
        edadDD.textColor = UIColor.gray
        edadMM.textColor = UIColor.gray
        edadA.textColor = UIColor.gray
        pesoKg.textColor = UIColor.gray
        estatura.textColor = UIColor.gray
        perimetroBraquial.textColor = UIColor.gray
        perimetroCefalico.textColor = UIColor.gray
        
        edadEnMeses()
        
        Database.database().reference().child("Usuarios").child(userID!).updateChildValues(
            [
                "Nombre": nombre.text! as NSString,
                "Apellidos": apellidos.text! as NSString,
                "ID": ID.text! as NSString,
                "Fecha nacimiento": fechaDeNacimiento,
                "Fecha examen": date,
                "Edad meses": String(edadMeses),
                "Sexo": sexoMF,
                "PesoKg": pesoKg.text! as NSString,
                "Estatura": estatura.text! as NSString,
                "MUAC": perimetroBraquial.text! as NSString,
                "P Cefalico": perimetroCefalico.text! as NSString,
                "Ubicacion": self.loc as NSDictionary
            ])
        
        print("Usuario actualizado y guardado con exito")
        
        performSegue(withIdentifier: "goToResultados", sender: self)
    }
    
}
