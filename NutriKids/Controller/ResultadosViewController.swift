//
//  ResultadosViewController.swift
//  NutriKids
//
//  Created by Manuela Garcia on 9/08/18.
//  Copyright © 2018 Manuela Garcia. All rights reserved.
//

import UIKit
import SVProgressHUD
import Firebase

class ResultadosViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (Indicador.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ResultadosViewControllerTableViewCell
        cell.indicador.text = Indicador[indexPath.row]
        cell.sd.text = puntoDeCorte[indexPath.row]
        cell.clasificacion.text = clasificacion[indexPath.row]
        return (cell)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75.857
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    var estaturaMedida: Float = 0
    var estaturaTeo_sd0: Float = 0
    var estaturaTeo_sd1: Float = 0
    var estaturaTeo_sd2: Float = 0
    var estaturaTeo_sd3: Float = 0
    var estaturaTeo_nsd1: Float = 0
    var estaturaTeo_nsd2: Float = 0
    var estaturaTeo_nsd3: Float = 0
    
    var pesoKgMedido: Float = 0
    var pesoKgTeo_sd0: Float = 0
    var pesoKgTeo_sd1: Float = 0
    var pesoKgTeo_sd2: Float = 0
    var pesoKgTeo_sd3: Float = 0
    var pesoKgTeo_nsd1: Float = 0
    var pesoKgTeo_nsd2: Float = 0
    var pesoKgTeo_nsd3: Float = 0
    
    var pCefMedido: Float = 0
    var pCefTeo_sd0: Float = 0
    var pCefTeo_sd1: Float = 0
    var pCefTeo_sd2: Float = 0
    var pCefTeo_sd3: Float = 0
    var pCefTeo_nsd1: Float = 0
    var pCefTeo_nsd2: Float = 0
    var pCefTeo_nsd3: Float = 0
    
    var IMCMedido: Float = 0
    var IMCTeo_sd0: Float = 0
    var IMCTeo_sd1: Float = 0
    var IMCTeo_sd2: Float = 0
    var IMCTeo_sd3: Float = 0
    var IMCTeo_nsd1: Float = 0
    var IMCTeo_nsd2: Float = 0
    var IMCTeo_nsd3: Float = 0
    
    var perimetroBraquialMedido: Float = 0
    var MUACTeo_sd0: Float = 0
    var MUACTeo_sd1: Float = 0
    var MUACTeo_sd2: Float = 0
    var MUACTeo_sd3: Float = 0
    var MUACTeo_nsd1: Float = 0
    var MUACTeo_nsd2: Float = 0
    var MUACTeo_nsd3: Float = 0
    
    var a: String = ""
    var b: String = ""
    var c: String = ""
    var d: String = ""
    var e: String = ""
    var f: String = ""
    
    var sd1 = ""
    var sd2 = ""
    var sd3 = ""
    var sd4 = ""
    var sd5 = ""
    var sd6 = ""
    
    var edadEnMeses = 0
    var sexo = ""
    var mensaje = ""
    
    var ref: DatabaseReference!
    let userID = Auth.auth().currentUser?.uid
    
    let Indicador = ["Indicador", "Peso para la talla", "Talla para la edad", "P. cefálico para la edad", "IMC para la edad", "Peso para la edad", "P. brazo para la edad"]
    var puntoDeCorte = ["Punto de corte (desviaciones estandar DE)", "sd1", "sd2", "sd3", "sd4", "sd5", "sd6"]
    var clasificacion = ["Clasificación antropométrica", "a", "b", "c", "d", "e", "f"]

    override func viewDidLoad() {
        super.viewDidLoad()
        SVProgressHUD.dismiss()
        IMCMedido = IMC(peso: pesoKgMedido, altura: estaturaMedida)
        tableView.tableFooterView = UIView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        calculos()
        tableView.reloadData()
        recomendacion()
        saveUserInfo()
    }
    
    func IMC(peso: Float, altura: Float) -> Float {
        let variable = peso/(powf((altura/100), 2))
        return variable
    }
    
    func recomendacion() {
        if (c == "Obesidad" || c == "Sobrepeso") {
            mensaje = "El usuario podría tener un peso para la talla por encima de lo normal. Se recomienda acudir a un profesional de la salud para realizar un examen más especializado y descartar un problema nutricional."
        } else if (c == "Desnutrición Aguda Moderada" || c == "Desnutrición Aguda Severa") {
            mensaje = "El usuario podría tener un peso para la talla por debajo de lo normal. Se recomienda acudir a un profesional de la salud para realizar un examen más especializado y descartar un posible caso de desnutrición."
        } else {
            mensaje = "El usuario tiene un peso para la talla normal. En caso de duda, se recomienda acudir a un profesional de la salud para realizar un examen más especializado y descartar un problema nutricional."
        }
        createAlert(title: "Recomendación", message: mensaje)
    }
    
    func saveUserInfo() {
        let resultado = ["Indicadores": Indicador, "Punto de corte": puntoDeCorte, "Clasificación": clasificacion]
        Database.database().reference().child("Usuarios").child(userID!).updateChildValues(
            [ "Resultado": resultado as NSDictionary,
              "IMC": IMCMedido
            ])
        print("Resultado actualizado y guardado con exito")
    }
    
    func createAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Entiendo", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: Funciones para Mujeres
    
    func estaturaParaLaEdad0_24F(edad: Float) -> (sd0: Float,nsd1: Float,nsd2: Float,nsd3: Float,sd1: Float,sd2: Float, sd3: Float) {
        let aux_sd0 = ((-1.213*powf(10, -6))*powf(edad, 6)) + ((0.0001053)*powf(edad, 5)) + ((-0.003672)*powf(edad, 4)) + ((0.06613)*powf(edad, 3)) + ((-0.6722)*powf(edad, 2)) + ((5.08)*edad) + (49.14)
        let aux_nsd1 = ((-9.256*powf(10, -7))*powf(edad, 6)) + ((8.308*powf(10, -5))*powf(edad, 5)) + ((-0.003012)*powf(edad, 4)) + ((0.05674)*powf(edad, 3)) + ((-0.608)*powf(edad, 2)) + ((4.846)*edad) + (47.34)
        let aux_nsd2 = ((-1.053*powf(10, -6))*powf(edad, 6)) + ((9.289*powf(10, -5))*powf(edad, 5)) + ((-0.003295)*powf(edad, 4)) + ((0.0605)*powf(edad, 3)) + ((-0.6299)*powf(edad, 2)) + ((4.828)*edad) + (45.45)
        let aux_nsd3 = ((-1.067*powf(10, -6))*powf(edad, 6)) + ((9.224*powf(10, -5))*powf(edad, 5)) + ((-0.003217)*powf(edad, 4)) + ((0.0584)*powf(edad, 3)) + ((-0.6069)*powf(edad, 2)) + ((4.674)*edad) + (43.63)
        let aux_sd1 = ((-1.073*powf(10, -6))*powf(edad, 6)) + ((9.488*powf(10, -5))*powf(edad, 5)) + ((-0.003384)*powf(edad, 4)) + ((0.06256)*powf(edad, 3)) + ((-0.6542)*powf(edad, 2)) + ((5.119)*edad) + (51.03)
        let aux_sd2 = ((-9.603*powf(10, -7))*powf(edad, 6)) + ((8.732*powf(10, -5))*powf(edad, 5)) + ((-0.003194)*powf(edad, 4)) + ((0.0604)*powf(edad, 3)) + ((-0.6441)*powf(edad, 2)) + ((5.166)*edad) + (52.94)
        let aux_sd3 = ((-1.144*powf(10, -6))*powf(edad, 6)) + ((0.0001012)*powf(edad, 5)) + ((-0.003607)*powf(edad, 4)) + ((0.0665)*powf(edad, 3)) + ((-0.6895)*powf(edad, 2)) + ((5.368)*edad) + (54.72)
        
        return (aux_sd0,aux_nsd1,aux_nsd2,aux_nsd3,aux_sd1,aux_sd2,aux_sd3)
    }
    
    func estaturaParaLaEdad24_60F(edad: Float) -> (sd0: Float,nsd1: Float,nsd2: Float,nsd3: Float,sd1: Float,sd2: Float, sd3: Float) {
        let aux_sd0 = ((7.103*powf(10, -5))*powf(edad, 3)) + ((-0.01341)*powf(edad, 2)) + ((1.386)*edad) + (59.22)
        let aux_nsd1 = ((6.626*powf(10, -5))*powf(edad, 3)) + ((-0.01259)*powf(edad, 2)) + ((1.302)*edad) + (57.61)
        let aux_nsd2 = ((6.05*powf(10, -5))*powf(edad, 3)) + ((-0.01162)*powf(edad, 2)) + ((1.21)*edad) + (56.11)
        let aux_nsd3 = ((5.784*powf(10, -5))*powf(edad, 3)) + ((-0.0111)*powf(edad, 2)) + ((1.138)*edad) + (54.36)
        let aux_sd1 = ((6.96*powf(10, -5))*powf(edad, 3)) + ((-0.0135)*powf(edad, 2)) + ((1.444)*edad) + (61.15)
        let aux_sd2 = ((7.057*powf(10, -5))*powf(edad, 3)) + ((-0.01391)*powf(edad, 2)) + ((1.515)*edad) + (62.89)
        let aux_sd3 = ((8.155*powf(10, -5))*powf(edad, 3)) + ((-0.01545)*powf(edad, 2)) + ((1.627)*edad) + (64.14)
        
        return (aux_sd0,aux_nsd1,aux_nsd2,aux_nsd3,aux_sd1,aux_sd2,aux_sd3)
    }
    
    func pesoParaLaEdadF(edad: Float) -> (sd0: Float,nsd1: Float,nsd2: Float,nsd3: Float,sd1: Float,sd2: Float, sd3: Float) {
        let aux_sd0 = ((1.598*powf(10, -10))*powf(edad, 7)) + ((-3.935*powf(10, -8))*powf(edad, 6)) + ((3.96*powf(10, -6))*powf(edad, 5)) + ((-0.0002095)*powf(edad, 4)) + ((0.00624)*powf(edad, 3)) + ((-0.1044)*powf(edad, 2)) + ((1.121)*edad) + (3.207)
        let aux_nsd1 = ((1.627*powf(10, -10))*powf(edad, 7)) + ((-3.97*powf(10, -8))*powf(edad, 6)) + ((3.959*powf(10, -6))*powf(edad, 5)) + ((-0.0002072)*powf(edad, 4)) + ((0.006089)*powf(edad, 3)) + ((-0.1001)*powf(edad, 2)) + ((1.039)*edad) + (2.764)
        let aux_nsd2 = ((1.102*powf(10, -10))*powf(edad, 7)) + ((-2.799*powf(10, -8))*powf(edad, 6)) + ((2.906*powf(10, -6))*powf(edad, 5)) + ((-0.0001585)*powf(edad, 4)) + ((0.004853)*powf(edad, 3)) + ((-0.08338)*powf(edad, 2)) + ((0.9116)*edad) + (2.389)
        let aux_nsd3 = ((1.384*powf(10, -10))*powf(edad, 7)) + ((-3.371*powf(10, -8))*powf(edad, 6)) + ((3.359*powf(10, -6))*powf(edad, 5)) + ((-0.0001758)*powf(edad, 4)) + ((0.005161)*powf(edad, 3)) + ((-0.08493)*powf(edad, 2)) + ((0.8772)*edad) + (1.965)
        let aux_sd1 = ((1.62*powf(10, -10))*powf(edad, 7)) + ((-4.01*powf(10, -8))*powf(edad, 6)) + ((4.064*powf(10, -6))*powf(edad, 5)) + ((-0.0002171)*powf(edad, 4)) + ((0.006557)*powf(edad, 3)) + ((-0.1116)*powf(edad, 2)) + ((1.231)*edad) + (3.714)
        let aux_sd2 = ((1.853*powf(10, -10))*powf(edad, 7)) + ((-4.551*powf(10, -8))*powf(edad, 6)) + ((4.575*powf(10, -6))*powf(edad, 5)) + ((-0.0002426)*powf(edad, 4)) + ((0.007293)*powf(edad, 3)) + ((-0.1238)*powf(edad, 2)) + ((1.376)*edad) + (4.245)
        let aux_sd3 = ((2.049*powf(10, -10))*powf(edad, 7)) + ((-5.013*powf(10, -8))*powf(edad, 6)) + ((5.018*powf(10, -6))*powf(edad, 5)) + ((-0.0002654)*powf(edad, 4)) + ((0.007987)*powf(edad, 3)) + ((-0.1365)*powf(edad, 2)) + ((1.546)*edad) + (4.829)
        
        return (aux_sd0,aux_nsd1,aux_nsd2,aux_nsd3,aux_sd1,aux_sd2,aux_sd3)
    }
    
    func pesoParaLaLongitud0_24F(longitud: Float) -> (sd0: Float,nsd1: Float,nsd2: Float,nsd3: Float,sd1: Float,sd2: Float, sd3: Float) {
        let aux_sd0 = ((3.324*powf(10, -5))*powf(longitud, 3)) + ((-0.007228)*powf(longitud, 2)) + ((0.7346)*longitud) + (-19.35)
        let aux_nsd1 = ((2.853*powf(10, -5))*powf(longitud, 3)) + ((-0.006206)*powf(longitud, 2)) + ((0.6439)*longitud) + (-17.08)
        let aux_nsd2 = ((2.457*powf(10, -5))*powf(longitud, 3)) + ((-0.005346)*powf(longitud, 2)) + ((0.5667)*longitud) + (-15.14)
        let aux_nsd3 = ((2.122*powf(10, -5))*powf(longitud, 3)) + ((-0.004618)*powf(longitud, 2)) + ((0.5005)*longitud) + (-13.47)
        let aux_sd1 = ((3.887*powf(10, -5))*powf(longitud, 3)) + ((-0.008451)*powf(longitud, 2)) + ((0.8419)*longitud) + (-22.03)
        let aux_sd2 = ((4.563*powf(10, -5))*powf(longitud, 3)) + ((-0.009918)*powf(longitud, 2)) + ((0.9693)*longitud) + (-25.19)
        let aux_sd3 = ((5.38*powf(10, -5))*powf(longitud, 3)) + ((-0.01169)*powf(longitud, 2)) + ((1.122)*longitud) + (-28.96)
        
        return (aux_sd0,aux_nsd1,aux_nsd2,aux_nsd3,aux_sd1,aux_sd2,aux_sd3)
    }
    
    func pesoParaLaLongitud24_60F(longitud: Float) -> (sd0: Float,nsd1: Float,nsd2: Float,nsd3: Float,sd1: Float,sd2: Float, sd3: Float) {
        let aux_sd0 = ((3.774*powf(10, -5))*powf(longitud, 3)) + ((-0.007964)*powf(longitud, 2)) + ((0.7597)*longitud) + (-18.82)
        let aux_nsd1 = ((3.383*powf(10, -5))*powf(longitud, 3)) + ((-0.007257)*powf(longitud, 2)) + ((0.7055)*longitud) + (-17.87)
        let aux_nsd2 = ((2.794*powf(10, -5))*powf(longitud, 3)) + ((-0.005888)*powf(longitud, 2)) + ((0.584)*longitud) + (-14.66)
        let aux_nsd3 = ((2.415*powf(10, -5))*powf(longitud, 3)) + ((-0.005053)*powf(longitud, 2)) + ((0.5092)*longitud) + (-12.77)
        let aux_sd1 = ((4.583*powf(10, -5))*powf(longitud, 3)) + ((-0.009823)*powf(longitud, 2)) + ((0.9212)*longitud) + (-22.99)
        let aux_sd2 = ((5.314*powf(10, -5))*powf(longitud, 3)) + ((-0.01138)*powf(longitud, 2)) + ((1.052)*longitud) + (-26.13)
        let aux_sd3 = ((6.229*powf(10, -5))*powf(longitud, 3)) + ((-0.01332)*powf(longitud, 2)) + ((1.21)*longitud) + (-29.8)
        
        return (aux_sd0,aux_nsd1,aux_nsd2,aux_nsd3,aux_sd1,aux_sd2,aux_sd3)
    }
    
    func IMCParaLaEdad0_24F(edad: Float) -> (sd0: Float,nsd1: Float,nsd2: Float,nsd3: Float,sd1: Float,sd2: Float, sd3: Float) {
        let aux_sd0 = ((-4.489*powf(10, -8))*powf(edad, 7)) + ((3.513*powf(10, -6))*powf(edad, 6)) + ((-9.744*powf(10, -5))*powf(edad, 5)) + ((0.0008795)*powf(edad, 4)) + ((0.008803)*powf(edad, 3)) + ((-0.2475)*powf(edad, 2)) + ((1.745)*edad) + (12.95)
        let aux_nsd1 = ((-6.628*powf(10, -8))*powf(edad, 7)) + ((5.434*powf(10, -6))*powf(edad, 6)) + ((-0.0001664)*powf(edad, 5)) + ((0.002148)*powf(edad, 4)) + ((-0.004085)*powf(edad, 3)) + ((-0.1745)*powf(edad, 2)) + ((1.532)*edad) + (11.77)
        let aux_nsd2 = ((-6.745*powf(10, -8))*powf(edad, 7)) + ((5.655*powf(10, -6))*powf(edad, 6)) + ((-0.0001796)*powf(edad, 5)) + ((0.002517)*powf(edad, 4)) + ((-0.009519)*powf(edad, 3)) + ((-0.1313)*powf(edad, 2)) + ((1.376)*edad) + (10.64)
        let aux_nsd3 = ((-1.191*powf(10, -7))*powf(edad, 7)) + ((1*powf(10, -5))*powf(edad, 6)) + ((-0.0003249)*powf(edad, 5)) + ((0.004975)*powf(edad, 4)) + ((-0.03171)*powf(edad, 3)) + ((-0.02756)*powf(edad, 2)) + ((1.165)*edad) + (9.56)
        let aux_sd1 = ((-5.023*powf(10, -8))*powf(edad, 7)) + ((3.842*powf(10, -6))*powf(edad, 6)) + ((-0.0001025)*powf(edad, 5)) + ((0.0008062)*powf(edad, 4)) + ((0.01205)*powf(edad, 3)) + ((-0.2876)*powf(edad, 2)) + ((1.948)*edad) + (14.2)
        let aux_sd2 = ((-6.551*powf(10, -8))*powf(edad, 7)) + ((5.176*powf(10, -6))*powf(edad, 6)) + ((-0.0001485)*powf(edad, 5)) + ((0.001583)*powf(edad, 4)) + ((0.005785)*powf(edad, 3)) + ((-0.2742)*powf(edad, 2)) + ((2.039)*edad) + (15.63)
        let aux_sd3 = ((-7.795*powf(10, -8))*powf(edad, 7)) + ((6.364*powf(10, -6))*powf(edad, 6)) + ((-0.0001926)*powf(edad, 5)) + ((0.002368)*powf(edad, 4)) + ((-0.0005273)*powf(edad, 3)) + ((-0.2654)*powf(edad, 2)) + ((2.184)*edad) + (17.1)
        
        return (aux_sd0,aux_nsd1,aux_nsd2,aux_nsd3,aux_sd1,aux_sd2,aux_sd3)
    }
    
    func IMCParaLaEdad24_60F(edad: Float) -> (sd0: Float,nsd1: Float,nsd2: Float,nsd3: Float,sd1: Float,sd2: Float, sd3: Float) {
        
        var aux_sd0: Float = 0
        var aux_nsd1: Float = 0
        var aux_nsd2: Float = 0
        var aux_nsd3: Float = 0
        var aux_sd1: Float = 0
        var aux_sd2: Float = 0
        var aux_sd3: Float = 0
        
        if edad < 26 {
            aux_sd0 = 15.7
        } else if (26 <= edad) && (edad <= 29) {
            aux_sd0 = 15.6
        } else if (30 <= edad) && (edad <= 33) {
            aux_sd0 = 15.5
        } else if (34 <= edad) && (edad <= 38) {
            aux_sd0 = 15.4
        } else if ((39 <= edad) && (edad <= 51)) || ((53 <= edad) && (edad <= 60)) {
            aux_sd0 = 15.3
        } else if edad == 52 {
            aux_sd0 = 15.2
        }
        
        if edad < 28 {
            aux_nsd1 = 14.4
        } else if (28 <= edad) && (edad <= 32) {
            aux_nsd1 = 14.3
        } else if (33 <= edad) && (edad <= 36) {
            aux_nsd1 = 14.2
        } else if (37 <= edad) && (edad <= 41) {
            aux_nsd1 = 14.1
        } else if (42 <= edad) && (edad <= 48) {
            aux_nsd1 = 14
        } else if 48 < edad {
            aux_nsd1 = 13.9
        }
        
        if edad < 29 {
            aux_nsd2 = 13.3
        } else if (29 <= edad) && (edad <= 32) {
            aux_nsd2 = 13.2
        } else if (33 <= edad) && (edad <= 37) {
            aux_nsd2 = 13.1
        } else if (38 <= edad) && (edad <= 41) {
            aux_nsd2 = 13
        } else if (42 <= edad) && (edad <= 46) {
            aux_nsd2 = 12.9
        } else if (47 <= edad) && (edad <= 52) {
            aux_nsd2 = 12.8
        } else if 52 < edad {
            aux_nsd2 = 12.7
        }
        
        if edad < 26 {
            aux_nsd3 = 12.4
        } else if (26 <= edad) && (edad <= 30) {
            aux_nsd3 = 12.3
        } else if (31 <= edad) && (edad <= 34) {
            aux_nsd3 = 12.2
        } else if (35 <= edad) && (edad <= 38) {
            aux_nsd3 = 12.1
        } else if (39 <= edad) && (edad <= 42) {
            aux_nsd3 = 12
        } else if (43 <= edad) && (edad <= 46) {
            aux_nsd3 = 11.9
        } else if (47 <= edad) && (edad <= 51) {
            aux_nsd3 = 11.8
        } else if (52 <= edad) && (edad <= 58) {
            aux_nsd3 = 11.7
        } else if 58 < edad {
            aux_nsd3 = 11.6
        }
        
        if edad < 26 {
            aux_sd1 = 17.1
        } else if (26 <= edad) && (edad <= 29) {
            aux_sd1 = 17
        } else if ((30 <= edad) && (edad <= 33)) || (56 < edad) {
            aux_sd1 = 16.9
        } else if (34 <= edad) && (edad <= 56) {
            aux_sd1 = 16.8
        }
        
        if edad < 27 {
            aux_sd2 = 18.7
        } else if (27 <= edad) && (edad <= 30) {
            aux_sd2 = 18.6
        } else if (31 <= edad) && (edad <= 34) || (44 <= edad) && (edad <= 49) {
            aux_sd2 = 18.5
        } else if (35 <= edad) && (edad <= 43) {
            aux_sd2 = 18.4
        } else if (50 <= edad) && (edad <= 53) {
            aux_sd2 = 18.6
        } else if (54 <= edad) && (edad <= 57) {
            aux_sd2 = 18.7
        } else if 57 < edad {
            aux_sd2 = 18.8
        }
        
        if edad < 27 || edad == 48 || edad == 49 {
            aux_sd3 = 20.6
        } else if (edad == 27) || (edad == 28) || (45 <= edad) && (edad <= 47)  {
            aux_sd3 = 20.5
        } else if (29 <= edad) && (edad <= 32) || (41 <= edad) && (edad <= 44) {
            aux_sd3 = 20.4
        } else if (33 <= edad) && (edad <= 40) {
            aux_sd3 = 20.3
        } else if (50 <= edad) && (edad <= 52) {
            aux_sd3 = 20.7
        } else if (edad == 53) || (edad == 54) {
            aux_sd3 = 20.8
        } else if (edad == 55) || (edad == 56) {
            aux_sd3 = 20.9
        } else if (57 <= edad) && (edad <= 59) {
            aux_sd3 = 21
        } else if edad == 60 {
            aux_sd3 = 21.1
        }
        
        return (aux_sd0,aux_nsd1,aux_nsd2,aux_nsd3,aux_sd1,aux_sd2,aux_sd3)
    }
    
    func MUACparaLaEdad3_60F(edad: Float) -> (sd0: Float,nsd1: Float,nsd2: Float,nsd3: Float,sd1: Float,sd2: Float, sd3: Float) {
        let aux_sd0 = ((-4.433*powf(10, -9))*powf(edad, 6)) + ((9.075*powf(10, -7))*powf(edad, 5)) + ((-7.23*powf(10, -5))*powf(edad, 4)) + ((0.002818)*powf(edad, 3)) + ((-0.05544)*powf(edad, 2)) + ((0.5681)*edad) + (11.81)
        let aux_nsd1 = ((-3.614*powf(10, -9))*powf(edad, 6)) + ((7.389*powf(10, -7))*powf(edad, 5)) + ((-5.877*powf(10, -5))*powf(edad, 4)) + ((0.002287)*powf(edad, 3)) + ((-0.04516)*powf(edad, 2)) + ((0.4769)*edad) + (10.98)
        let aux_nsd2 = ((-3.643*powf(10, -9))*powf(edad, 6)) + ((7.385*powf(10, -7))*powf(edad, 5)) + ((-5.811*powf(10, -5))*powf(edad, 4)) + ((0.002231)*powf(edad, 3)) + ((-0.0434)*powf(edad, 2)) + ((0.4507)*edad) + (10.1)
        let aux_nsd3 = ((-3.248*powf(10, -9))*powf(edad, 6)) + ((6.563*powf(10, -7))*powf(edad, 5)) + ((-5.152*powf(10, -5))*powf(edad, 4)) + ((0.001976)*powf(edad, 3)) + ((-0.03855)*powf(edad, 2)) + ((0.4049)*edad) + (9.363)
        let aux_sd1 = ((-4.523*powf(10, -9))*powf(edad, 6)) + ((9.301*powf(10, -7))*powf(edad, 5)) + ((-7.466*powf(10, -5))*powf(edad, 4)) + ((0.002941)*powf(edad, 3)) + ((-0.05849)*powf(edad, 2)) + ((0.6048)*edad) + (12.88)
        let aux_sd2 = ((-5.493*powf(10, -9))*powf(edad, 6)) + ((1.13*powf(10, -6))*powf(edad, 5)) + ((-9.087*powf(10, -5))*powf(edad, 4)) + ((0.003587)*powf(edad, 3)) + ((-0.07131)*powf(edad, 2)) + ((0.7234)*edad) + (13.84)
        let aux_sd3 = ((-6.098*powf(10, -9))*powf(edad, 6)) + ((1.258*powf(10, -6))*powf(edad, 5)) + ((-0.0001014)*powf(edad, 4)) + ((0.004009)*powf(edad, 3)) + ((-0.07966)*powf(edad, 2)) + ((0.8012)*edad) + (15.08)
        
        return (aux_sd0,aux_nsd1,aux_nsd2,aux_nsd3,aux_sd1,aux_sd2,aux_sd3)
    }
    
    func pCefalicoParaLaEdad0_60F(edad: Float) -> (sd0: Float,nsd1: Float,nsd2: Float,nsd3: Float,sd1: Float,sd2: Float, sd3: Float) {
        let aux_sd0 = ((3.32*powf(10, -10))*powf(edad, 7)) + ((-7.943*powf(10, -8))*powf(edad, 6)) + ((7.815*powf(10, -6))*powf(edad, 5)) + ((-0.0004087)*powf(edad, 4)) + ((0.01229)*powf(edad, 3)) + ((-0.2164)*powf(edad, 2)) + ((2.285)*edad) + (34.15)
        let aux_nsd1 = ((3.154*powf(10, -10))*powf(edad, 7)) + ((-7.588*powf(10, -8))*powf(edad, 6)) + ((7.505*powf(10, -6))*powf(edad, 5)) + ((-0.0003944)*powf(edad, 4)) + ((0.01191)*powf(edad, 3)) + ((-0.2104)*powf(edad, 2)) + ((2.23)*edad) + (33.02)
        let aux_nsd2 = ((3.416*powf(10, -10))*powf(edad, 7)) + ((-8.177*powf(10, -8))*powf(edad, 6)) + ((8.028*powf(10, -6))*powf(edad, 5)) + ((-0.0004175)*powf(edad, 4)) + ((0.01242)*powf(edad, 3)) + ((-0.2154)*powf(edad, 2)) + ((2.232)*edad) + (31.82)
        let aux_nsd3 = ((3.452*powf(10, -10))*powf(edad, 7)) + ((-8.225*powf(10, -8))*powf(edad, 6)) + ((8.037*powf(10, -6))*powf(edad, 5)) + ((-0.0004158)*powf(edad, 4)) + ((0.0123)*powf(edad, 3)) + ((-0.2119)*powf(edad, 2)) + ((2.183)*edad) + (30.71)
        let aux_sd1 = ((3.033*powf(10, -10))*powf(edad, 7)) + ((-7.403*powf(10, -8))*powf(edad, 6)) + ((7.425*powf(10, -6))*powf(edad, 5)) + ((-0.0003954)*powf(edad, 4)) + ((0.01209)*powf(edad, 3)) + ((-0.2159)*powf(edad, 2)) + ((2.309)*edad) + (35.31)
        let aux_sd2 = ((3.148*powf(10, -10))*powf(edad, 7)) + ((-7.603*powf(10, -8))*powf(edad, 6)) + ((7.562*powf(10, -6))*powf(edad, 5)) + ((-0.0004005)*powf(edad, 4)) + ((0.01222)*powf(edad, 3)) + ((-0.2186)*powf(edad, 2)) + ((2.349)*edad) + (36.44)
        let aux_sd3 = ((2.831*powf(10, -10))*powf(edad, 7)) + ((-7.006*powf(10, -8))*powf(edad, 6)) + ((7.134*powf(10, -6))*powf(edad, 5)) + ((-0.0003862)*powf(edad, 4)) + ((0.01201)*powf(edad, 3)) + ((-0.2185)*powf(edad, 2)) + ((2.377)*edad) + (37.6)
        
        return (aux_sd0,aux_nsd1,aux_nsd2,aux_nsd3,aux_sd1,aux_sd2,aux_sd3)
    }
    
    // Mark: Funciones para Hombres
    
    func estaturaParaLaEdad0_24M(edad: Float) -> (sd0: Float,nsd1: Float,nsd2: Float,nsd3: Float,sd1: Float,sd2: Float, sd3: Float) {
        let aux_sd0 = ((-7.117*powf(10, -7))*powf(edad, 6)) + ((6.937*powf(10, -5))*powf(edad, 5)) + ((-0.002741)*powf(edad, 4)) + ((0.05637)*powf(edad, 3)) + ((-0.6543)*powf(edad, 2)) + ((5.36)*edad) + (49.91)
        let aux_nsd1 = ((-8.143*powf(10, -7))*powf(edad, 6)) + ((7.71*powf(10, -5))*powf(edad, 5)) + ((-0.002956)*powf(edad, 4)) + ((0.059)*powf(edad, 3)) + ((-0.6677)*powf(edad, 2)) + ((5.34)*edad) + (48.02)
        let aux_nsd2 = ((-9.361*powf(10, -7))*powf(edad, 6)) + ((8.474*powf(10, -5))*powf(edad, 5)) + ((-0.003118)*powf(edad, 4)) + ((0.06017)*powf(edad, 3)) + ((-0.6669)*powf(edad, 2)) + ((5.277)*edad) + (46.11)
        let aux_nsd3 = ((-7.066*powf(10, -7))*powf(edad, 6)) + ((6.879*powf(10, -5))*powf(edad, 5)) + ((-0.002702)*powf(edad, 4)) + ((0.0551)*powf(edad, 3)) + ((-0.6389)*powf(edad, 2)) + ((5.181)*edad) + (44.23)
        let aux_sd1 = ((-8.03*powf(10, -7))*powf(edad, 6)) + ((7.73*powf(10, -5))*powf(edad, 5)) + ((-0.003006)*powf(edad, 4)) + ((0.06056)*powf(edad, 3)) + ((-0.6848)*powf(edad, 2)) + ((5.479)*edad) + (51.81)
        let aux_sd2 = ((-8.628*powf(10, -7))*powf(edad, 6)) + ((8.088*powf(10, -5))*powf(edad, 5)) + ((-0.003081)*powf(edad, 4)) + ((0.06118)*powf(edad, 3)) + ((-0.6856)*powf(edad, 2)) + ((5.512)*edad) + (53.7)
        let aux_sd3 = ((-9.244*powf(10, -7))*powf(edad, 6)) + ((8.668*powf(10, -5))*powf(edad, 5)) + ((-0.003289)*powf(edad, 4)) + ((0.06474)*powf(edad, 3)) + ((-0.7135)*powf(edad, 2)) + ((5.627)*edad) + (55.6)
        
        return (aux_sd0,aux_nsd1,aux_nsd2,aux_nsd3,aux_sd1,aux_sd2,aux_sd3)
    }
    
    func estaturaParaLaEdad24_60M(edad: Float) -> (sd0: Float,nsd1: Float,nsd2: Float,nsd3: Float,sd1: Float,sd2: Float, sd3: Float) {
        let aux_sd0 = ((0.0001161)*powf(edad, 3)) + ((-0.01855)*powf(edad, 2)) + ((1.542)*edad) + (59.23)
        let aux_nsd1 = ((9.324*powf(10, -5))*powf(edad, 3)) + ((-0.01534)*powf(edad, 2)) + ((1.354)*edad) + (59.16)
        let aux_nsd2 = ((8.67*powf(10, -5))*powf(edad, 3)) + ((-0.0142)*powf(edad, 2)) + ((1.252)*edad) + (57.96)
        let aux_nsd3 = ((7.895*powf(10, -5))*powf(edad, 3)) + ((-0.01281)*powf(edad, 2)) + ((1.135)*edad) + (57.36)
        let aux_sd1 = ((0.0001178)*powf(edad, 3)) + ((-0.01918)*powf(edad, 2)) + ((1.627)*edad) + (60.59)
        let aux_sd2 = ((0.0001304)*powf(edad, 3)) + ((-0.0212)*powf(edad, 2)) + ((1.77)*edad) + (61.18)
        let aux_sd3 = ((0.000145)*powf(edad, 3)) + ((-0.0234)*powf(edad, 2)) + ((1.918)*edad) + (61.72)
        
        return (aux_sd0,aux_nsd1,aux_nsd2,aux_nsd3,aux_sd1,aux_sd2,aux_sd3)
    }
    
    func pesoParaLaEdadM(edad: Float) -> (sd0: Float,nsd1: Float,nsd2: Float,nsd3: Float,sd1: Float,sd2: Float, sd3: Float) {
        let aux_sd0 = ((2.259*powf(10, -10))*powf(edad, 7)) + ((-5.47*powf(10, -8))*powf(edad, 6)) + ((5.4*powf(10, -6))*powf(edad, 5)) + ((-0.0002791)*powf(edad, 4)) + ((0.008083)*powf(edad, 3)) + ((-0.1311)*powf(edad, 2)) + ((1.318)*edad) + (3.346)
        let aux_nsd1 = ((1.962*powf(10, -10))*powf(edad, 7)) + ((-4.768*powf(10, -8))*powf(edad, 6)) + ((4.724*powf(10, -6))*powf(edad, 5)) + ((-0.0002453)*powf(edad, 4)) + ((0.007151)*powf(edad, 3)) + ((-0.1173)*powf(edad, 2)) + ((1.193)*edad) + (2.9)
        let aux_nsd2 = ((1.986*powf(10, -10))*powf(edad, 7)) + ((-4.729*powf(10, -8))*powf(edad, 6)) + ((4.599*powf(10, -6))*powf(edad, 5)) + ((-0.0002351)*powf(edad, 4)) + ((0.006776)*powf(edad, 3)) + ((-0.1106)*powf(edad, 2)) + ((1.114)*edad) + (2.469)
        let aux_nsd3 = ((1.523*powf(10, -10))*powf(edad, 7)) + ((-3.737*powf(10, -8))*powf(edad, 6)) + ((3.745*powf(10, -6))*powf(edad, 5)) + ((-0.0001972)*powf(edad, 4)) + ((0.00585)*powf(edad, 3)) + ((-0.09827)*powf(edad, 2)) + ((1.014)*edad) + (2.072)
        let aux_sd1 = ((2.317*powf(10, -10))*powf(edad, 7)) + ((-5.601*powf(10, -8))*powf(edad, 6)) + ((5.524*powf(10, -6))*powf(edad, 5)) + ((-0.0002856)*powf(edad, 4)) + ((0.008291)*powf(edad, 3)) + ((-0.1351)*powf(edad, 2)) + ((1.389)*edad) + (3.924)
        let aux_sd2 = ((2.27*powf(10, -10))*powf(edad, 7)) + ((-5.569*powf(10, -8))*powf(edad, 6)) + ((5.581*powf(10, -6))*powf(edad, 5)) + ((-0.0002935)*powf(edad, 4)) + ((0.008669)*powf(edad, 3)) + ((-0.1433)*powf(edad, 2)) + ((1.503)*edad) + (4.471)
        let aux_sd3 = ((3.012*powf(10, -10))*powf(edad, 7)) + ((-7.224*powf(10, -8))*powf(edad, 6)) + ((7.06*powf(10, -6))*powf(edad, 5)) + ((-0.000361)*powf(edad, 4)) + ((0.01033)*powf(edad, 3)) + ((-0.1644)*powf(edad, 2)) + ((1.667)*edad) + (5.099)
        
        return (aux_sd0,aux_nsd1,aux_nsd2,aux_nsd3,aux_sd1,aux_sd2,aux_sd3)
    }
    
    func pesoParaLaLongitud0_24M(longitud: Float) -> (sd0: Float,nsd1: Float,nsd2: Float,nsd3: Float,sd1: Float,sd2: Float, sd3: Float) {
        let aux_sd0 = ((3.065*powf(10, -5))*powf(longitud, 3)) + ((-0.006998)*powf(longitud, 2)) + ((0.749)*longitud) + (-20.35)
        let aux_nsd1 = ((2.62*powf(10, -5))*powf(longitud, 3)) + ((-0.006018)*powf(longitud, 2)) + ((0.6616)*longitud) + (-18.16)
        let aux_nsd2 = ((2.241*powf(10, -5))*powf(longitud, 3)) + ((-0.005179)*powf(longitud, 2)) + ((0.5859)*longitud) + (-16.25)
        let aux_nsd3 = ((1.918*powf(10, -5))*powf(longitud, 3)) + ((-0.004464)*powf(longitud, 2)) + ((0.5204)*longitud) + (-14.59)
        let aux_sd1 = ((3.59*powf(10, -5))*powf(longitud, 3)) + ((-0.008152)*powf(longitud, 2)) + ((0.8506)*longitud) + (-22.88)
        let aux_sd2 = ((4.211*powf(10, -5))*powf(longitud, 3)) + ((-0.009515)*powf(longitud, 2)) + ((0.969)*longitud) + (-25.81)
        let aux_sd3 = ((4.949*powf(10, -5))*powf(longitud, 3)) + ((-0.01113)*powf(longitud, 2)) + ((1.108)*longitud) + (-29.21)
        
        return (aux_sd0,aux_nsd1,aux_nsd2,aux_nsd3,aux_sd1,aux_sd2,aux_sd3)
    }
    
    func pesoParaLaLongitud24_60M(longitud: Float) -> (sd0: Float,nsd1: Float,nsd2: Float,nsd3: Float,sd1: Float,sd2: Float, sd3: Float) {
        let aux_sd0 = ((3.839*powf(10, -5))*powf(longitud, 3)) + ((-0.008606)*powf(longitud, 2)) + ((0.8499)*longitud) + (-21.94)
        let aux_nsd1 = ((2.839*powf(10, -5))*powf(longitud, 3)) + ((-0.006182)*powf(longitud, 2)) + ((0.6388)*longitud) + (-16.28)
        let aux_nsd2 = ((2.39*powf(10, -5))*powf(longitud, 3)) + ((-0.005248)*powf(longitud, 2)) + ((0.5631)*longitud) + (-14.63)
        let aux_nsd3 = ((1.65*powf(10, -5))*powf(longitud, 3)) + ((-0.003404)*powf(longitud, 2)) + ((0.3966)*longitud) + (-10)
        let aux_sd1 = ((4.702*powf(10, -5))*powf(longitud, 3)) + ((-0.01061)*powf(longitud, 2)) + ((1.021)*longitud) + (-26.29)
        let aux_sd2 = ((5.905*powf(10, -5))*powf(longitud, 3)) + ((-0.01346)*powf(longitud, 2)) + ((1.265)*longitud) + (-32.67)
        let aux_sd3 = ((7.315*powf(10, -5))*powf(longitud, 3)) + ((-0.01677)*powf(longitud, 2)) + ((1.543)*longitud) + (-39.85)
        
        return (aux_sd0,aux_nsd1,aux_nsd2,aux_nsd3,aux_sd1,aux_sd2,aux_sd3)
    }
    
    func IMCParaLaEdad0_24M(edad: Float) -> (sd0: Float,nsd1: Float,nsd2: Float,nsd3: Float,sd1: Float,sd2: Float, sd3: Float) {
        let aux_sd0 = ((-2.729*powf(10, -8))*powf(edad, 7)) + ((1.517*powf(10, -6))*powf(edad, 6)) + ((-7.184*powf(10, -6))*powf(edad, 5)) + ((-0.001209)*powf(edad, 4)) + ((0.03502)*powf(edad, 3)) + ((-0.4206)*powf(edad, 2)) + ((2.266)*edad) + (12.95)
        let aux_nsd1 = ((-2.533*powf(10, -8))*powf(edad, 7)) + ((1.532*powf(10, -6))*powf(edad, 6)) + ((-1.517*powf(10, -5))*powf(edad, 5)) + ((-0.000907)*powf(edad, 4)) + ((0.03009)*powf(edad, 3)) + ((-0.3796)*powf(edad, 2)) + ((2.107)*edad) + (11.79)
        let aux_nsd2 = ((-1.688*powf(10, -8))*powf(edad, 7)) + ((7.958*powf(10, -7))*powf(edad, 6)) + ((9.698*powf(10, -6))*powf(edad, 5)) + ((-0.001301)*powf(edad, 4)) + ((0.03269)*powf(edad, 3)) + ((-0.3801)*powf(edad, 2)) + ((2.068)*edad) + (10.6)
        let aux_nsd3 = ((-6.089*powf(10, -8))*powf(edad, 7)) + ((4.723*powf(10, -6))*powf(edad, 6)) + ((-0.00013)*powf(edad, 5)) + ((0.001216)*powf(edad, 4)) + ((0.008503)*powf(edad, 3)) + ((-0.26)*powf(edad, 2)) + ((1.806)*edad) + (9.618)
        let aux_sd1 = ((-6.155*powf(10, -8))*powf(edad, 7)) + ((4.367*powf(10, -6))*powf(edad, 6)) + ((-9.965*powf(10, -5))*powf(edad, 5)) + ((0.0002561)*powf(edad, 4)) + ((0.02359)*powf(edad, 3)) + ((-0.3845)*powf(edad, 2)) + ((2.262)*edad) + (14.34)
        let aux_sd2 = ((-7.577*powf(10, -8))*powf(edad, 7)) + ((5.687*powf(10, -6))*powf(edad, 6)) + ((-0.0001484)*powf(edad, 5)) + ((0.001159)*powf(edad, 4)) + ((0.01517)*powf(edad, 3)) + ((-0.3537)*powf(edad, 2)) + ((2.283)*edad) + (15.77)
        let aux_sd3 = ((-9.242*powf(10, -8))*powf(edad, 7)) + ((7.289*powf(10, -6))*powf(edad, 6)) + ((-0.0002086)*powf(edad, 5)) + ((0.00226)*powf(edad, 4)) + ((0.005368)*powf(edad, 3)) + ((-0.3211)*powf(edad, 2)) + ((2.321)*edad) + (17.3)
        
        return (aux_sd0,aux_nsd1,aux_nsd2,aux_nsd3,aux_sd1,aux_sd2,aux_sd3)
    }
    
    func IMCParaLaEdad24_60M(edad: Float) -> (sd0: Float,nsd1: Float,nsd2: Float,nsd3: Float,sd1: Float,sd2: Float, sd3: Float) {
        
        var aux_sd0: Float = 0
        var aux_nsd1: Float = 0
        var aux_nsd2: Float = 0
        var aux_nsd3: Float = 0
        var aux_sd1: Float = 0
        var aux_sd2: Float = 0
        var aux_sd3: Float = 0
        
        if edad < 26 {
            aux_sd0 = 16
        } else if (26 <= edad) && (edad <= 28) {
            aux_sd0 = 15.9
        } else if (29 <= edad) && (edad <= 31) {
            aux_sd0 = 15.8
        } else if (32 <= edad) && (edad <= 34) {
            aux_sd0 = 15.7
        } else if (35 <= edad) && (edad <= 37) {
            aux_sd0 = 15.6
        } else if (38 <= edad) && (edad <= 41) {
            aux_sd0 = 15.5
        } else if (42 <= edad) && (edad <= 46) {
            aux_sd0 = 15.4
        } else if (47 <= edad) && (edad <= 54) {
            aux_sd0 = 15.3
        } else if edad > 54 {
            aux_sd0 = 15.2
        }
        
        if edad < 27 {
            aux_nsd1 = 14.8
        } else if (27 <= edad) && (edad <= 29) {
            aux_nsd1 = 14.7
        } else if (30 <= edad) && (edad <= 32) {
            aux_nsd1 = 14.6
        } else if (33 <= edad) && (edad <= 35) {
            aux_nsd1 = 14.5
        } else if (36 <= edad) && (edad <= 38) {
            aux_nsd1 = 14.4
        } else if (39 <= edad) && (edad <= 42) {
            aux_nsd1 = 14.3
        } else if (43 <= edad) && (edad <= 47) {
            aux_nsd1 = 14.2
        } else if (48 <= edad) && (edad <= 53) {
            aux_nsd1 = 14.1
        } else if 53 < edad {
            aux_nsd1 = 14
        }
        
        if edad < 26 {
            aux_nsd2 = 13.8
        } else if (edad == 26) || (edad == 27) {
            aux_nsd2 = 13.7
        } else if (28 <= edad) && (edad <= 30) {
            aux_nsd2 = 13.6
        } else if (31 <= edad) && (edad <= 33) {
            aux_nsd2 = 13.5
        } else if (34 <= edad) && (edad <= 36) {
            aux_nsd2 = 13.4
        } else if (37 <= edad) && (edad <= 39) {
            aux_nsd2 = 13.3
        } else if (40 <= edad) && (edad <= 43) {
            aux_nsd2 = 13.2
        } else if (44 <= edad) && (edad <= 48) {
            aux_nsd2 = 13.1
        } else if (49 <= edad) && (edad <= 55) {
            aux_nsd2 = 13
        } else if 55 < edad {
            aux_nsd2 = 12.9
        }
        
        if edad == 24 {
            aux_nsd3 = 12.9
        } else if (edad == 25) || (edad == 26) {
            aux_nsd3 = 12.8
        } else if (27 <= edad) && (edad <= 29) {
            aux_nsd3 = 12.7
        } else if (edad == 30) || (edad == 31) {
            aux_nsd3 = 12.6
        } else if (32 <= edad) && (edad <= 34) {
            aux_nsd3 = 12.5
        } else if (35 <= edad) && (edad <= 37) {
            aux_nsd3 = 12.4
        } else if (38 <= edad) && (edad <= 40) {
            aux_nsd3 = 12.3
        } else if (41 <= edad) && (edad <= 45) {
            aux_nsd3 = 12.2
        } else if (46 <= edad) && (edad <= 51) {
            aux_nsd3 = 12.1
        } else if 51 < edad {
            aux_nsd3 = 12
        }
        
        if edad < 27 {
            aux_sd1 = 17.3
        } else if (edad == 27) || (edad == 28) {
            aux_sd1 = 17.2
        } else if (29 <= edad) && (edad <= 31) {
            aux_sd1 = 17.1
        } else if (32 <= edad) && (edad <= 34) {
            aux_sd1 = 17
        } else if (35 <= edad) && (edad <= 37) {
            aux_sd1 = 16.9
        } else if (38 <= edad) && (edad <= 42) {
            aux_sd1 = 16.8
        } else if (43 <= edad) && (edad <= 50) {
            aux_sd1 = 16.7
        } else if 51 < edad {
            aux_sd1 = 16.6
        }
        
        if edad < 25 {
            aux_sd2 = 18.9
        } else if (edad == 25) || (edad == 26) {
            aux_sd2 = 18.8
        } else if (edad == 27) || (edad == 28)  {
            aux_sd2 = 18.7
        } else if (edad == 29) || (edad == 30)  {
            aux_sd2 = 18.6
        } else if (31 <= edad) && (edad <= 33) {
            aux_sd2 = 18.5
        } else if (34 <= edad) && (edad <= 36) {
            aux_sd2 = 18.4
        } else if (37 <= edad) && (edad <= 39) {
            aux_sd2 = 18.3
        } else if (40 <= edad) && (edad <= 57) {
            aux_sd2 = 18.2
        } else if 57 < edad {
            aux_sd2 = 18.3
        }
        
        if edad == 24 {
            aux_sd3 = 20.6
        } else if (edad == 25) || (edad == 26) {
            aux_sd3 = 20.5
        } else if (edad == 27) || (edad == 28) {
            aux_sd3 = 20.4
        } else if (edad == 29) || (edad == 60) {
            aux_sd3 = 20.3
        } else if (edad == 30) || (edad == 31) || (edad == 58) || (edad == 59)  {
            aux_sd3 = 20.2
        } else if ((edad == 32) || (edad == 33)) || ((edad == 56) || (edad == 57)) {
            aux_sd3 = 20.1
        } else if ((34 <= edad) && (edad <= 36)) || ((53 <= edad) && (edad <= 55)) {
            aux_sd3 = 20
        } else if ((37 <= edad) && (edad <= 41)) || ((47 <= edad) && (edad <= 52)) {
            aux_sd3 = 19.9
        } else if (42 <= edad) && (edad <= 46) {
            aux_sd3 = 19.8
        } else if (edad == 55) || (edad == 56) {
            aux_sd3 = 20.9
        } else if (57 <= edad) && (edad <= 59) {
            aux_sd3 = 21
        } else if edad == 60 {
            aux_sd3 = 21.1
        }
        
        return (aux_sd0,aux_nsd1,aux_nsd2,aux_nsd3,aux_sd1,aux_sd2,aux_sd3)
    }
    
    func MUACparaLaEdad3_60M(edad: Float) -> (sd0: Float,nsd1: Float,nsd2: Float,nsd3: Float,sd1: Float,sd2: Float, sd3: Float) {
        let aux_sd0 = ((-4.475*powf(10, -9))*powf(edad, 6)) + ((9.15*powf(10, -7))*powf(edad, 5)) + ((-7.302*powf(10, -5))*powf(edad, 4)) + ((0.002863)*powf(edad, 3)) + ((-0.0571)*powf(edad, 2)) + ((0.5832)*edad) + (12.24)
        let aux_nsd1 = ((-3.523*powf(10, -9))*powf(edad, 6)) + ((7.351*powf(10, -7))*powf(edad, 5)) + ((-5.982*powf(10, -5))*powf(edad, 4)) + ((0.002388)*powf(edad, 3)) + ((-0.04853)*powf(edad, 2)) + ((0.5085)*edad) + (11.4)
        let aux_nsd2 = ((-3.219*powf(10, -9))*powf(edad, 6)) + ((6.687*powf(10, -7))*powf(edad, 5)) + ((-5.42*powf(10, -5))*powf(edad, 4)) + ((0.002157)*powf(edad, 3)) + ((-0.04378)*powf(edad, 2)) + ((0.4615)*edad) + (10.56)
        let aux_nsd3 = ((-3.242*powf(10, -9))*powf(edad, 6)) + ((6.66*powf(10, -7))*powf(edad, 5)) + ((-5.329*powf(10, -5))*powf(edad, 4)) + ((0.00209)*powf(edad, 3)) + ((-0.04172)*powf(edad, 2)) + ((0.4339)*edad) + (9.745)
        let aux_sd1 = ((-4.799*powf(10, -9))*powf(edad, 6)) + ((9.866*powf(10, -7))*powf(edad, 5)) + ((-7.921*powf(10, -5))*powf(edad, 4)) + ((0.003134)*powf(edad, 3)) + ((-0.06299)*powf(edad, 2)) + ((0.6482)*edad) + (13.13)
        let aux_sd2 = ((-4.323*powf(10, -9))*powf(edad, 6)) + ((9.13*powf(10, -7))*powf(edad, 5)) + ((-7.545*powf(10, -5))*powf(edad, 4)) + ((0.003072)*powf(edad, 3)) + ((-0.0637)*powf(edad, 2)) + ((0.683)*edad) + (14.11)
        let aux_sd3 = ((-5.569*powf(10, -9))*powf(edad, 6)) + ((1.152*powf(10, -6))*powf(edad, 5)) + ((-9.327*powf(10, -5))*powf(edad, 4)) + ((0.003727)*powf(edad, 3)) + ((-0.07588)*powf(edad, 2)) + ((0.7989)*edad) + (14.98)
        
        return (aux_sd0,aux_nsd1,aux_nsd2,aux_nsd3,aux_sd1,aux_sd2,aux_sd3)
    }
    
    func pCefalicoParaLaEdad0_60M(edad: Float) -> (sd0: Float,nsd1: Float,nsd2: Float,nsd3: Float,sd1: Float,sd2: Float, sd3: Float) {
        let aux_sd0 = ((3.453*powf(10, -10))*powf(edad, 7)) + ((-8.32*powf(10, -8))*powf(edad, 6)) + ((8.244*powf(10, -6))*powf(edad, 5)) + ((-0.0004343)*powf(edad, 4)) + ((0.01316)*powf(edad, 3)) + ((-0.2333)*powf(edad, 2)) + ((2.448)*edad) + (34.74)
        let aux_nsd1 = ((3.676*powf(10, -10))*powf(edad, 7)) + ((-8.849*powf(10, -8))*powf(edad, 6)) + ((8.744*powf(10, -6))*powf(edad, 5)) + ((-0.0004583)*powf(edad, 4)) + ((0.01377)*powf(edad, 3)) + ((-0.2409)*powf(edad, 2)) + ((2.479)*edad) + (33.51)
        let aux_nsd2 = ((3.835*powf(10, -10))*powf(edad, 7)) + ((-9.229*powf(10, -8))*powf(edad, 6)) + ((9.107*powf(10, -6))*powf(edad, 5)) + ((-0.0004758)*powf(edad, 4)) + ((0.01421)*powf(edad, 3)) + ((-0.2466)*powf(edad, 2)) + ((2.501)*edad) + (32.3)
        let aux_nsd3 = ((4.415*powf(10, -10))*powf(edad, 7)) + ((-1.05*powf(10, -7))*powf(edad, 6)) + ((1.021*powf(10, -5))*powf(edad, 5)) + ((-0.0005244)*powf(edad, 4)) + ((0.01534)*powf(edad, 3)) + ((-0.2591)*powf(edad, 2)) + ((2.544)*edad) + (31.11)
        let aux_sd1 = ((3.22*powf(10, -10))*powf(edad, 7)) + ((-7.839*powf(10, -8))*powf(edad, 6)) + ((7.856*powf(10, -6))*powf(edad, 5)) + ((-0.0004189)*powf(edad, 4)) + ((0.01285)*powf(edad, 3)) + ((-0.2306)*powf(edad, 2)) + ((2.451)*edad) + (35.91)
        let aux_sd2 = ((3.137*powf(10, -10))*powf(edad, 7)) + ((-7.627*powf(10, -8))*powf(edad, 6)) + ((7.635*powf(10, -6))*powf(edad, 5)) + ((-0.000407)*powf(edad, 4)) + ((0.0125)*powf(edad, 3)) + ((-0.2253)*powf(edad, 2)) + ((2.426)*edad) + (37.11)
        let aux_sd3 = ((2.626*powf(10, -10))*powf(edad, 7)) + ((-6.473*powf(10, -8))*powf(edad, 6)) + ((6.597*powf(10, -6))*powf(edad, 5)) + ((-0.0003598)*powf(edad, 4)) + ((0.01137)*powf(edad, 3)) + ((-0.2123)*powf(edad, 2)) + ((2.376)*edad) + (38.34)
        
        return (aux_sd0,aux_nsd1,aux_nsd2,aux_nsd3,aux_sd1,aux_sd2,aux_sd3)
    }
    
    // Mark: Calculos
    
    func calculos() {
        if sexo == "Femenino" {
            // Estatura para la edad
            if edadEnMeses <= 24 {
                let estaturaTeo = estaturaParaLaEdad0_24F(edad: Float(edadEnMeses))
                estaturaTeo_sd0 = estaturaTeo.sd0
                estaturaTeo_sd1 = estaturaTeo.sd1
                estaturaTeo_sd2 = estaturaTeo.sd2
                estaturaTeo_sd3 = estaturaTeo.sd3
                estaturaTeo_nsd1 = estaturaTeo.nsd1
                estaturaTeo_nsd2 = estaturaTeo.nsd2
                estaturaTeo_nsd3 = estaturaTeo.nsd3
            } else {
                let estaturaTeo = estaturaParaLaEdad24_60F(edad: Float(edadEnMeses))
                estaturaTeo_sd0 = estaturaTeo.sd0
                estaturaTeo_sd1 = estaturaTeo.sd1
                estaturaTeo_sd2 = estaturaTeo.sd2
                estaturaTeo_sd3 = estaturaTeo.sd3
                estaturaTeo_nsd1 = estaturaTeo.nsd1
                estaturaTeo_nsd2 = estaturaTeo.nsd2
                estaturaTeo_nsd3 = estaturaTeo.nsd3
            }
        
            if estaturaMedida >= estaturaTeo_nsd1 {
                // Talla adecuada para la edad
                sd1 = "≥ -1 DE"
                a = "Talla adecuada para la edad"
            } else if (estaturaTeo_nsd2 <= estaturaMedida) && (estaturaMedida < estaturaTeo_nsd1) {
                // Riesgo de talla baja
                sd1 = "≥ -2 DE a < -1 DE"
                a = "Riesgo de talla baja"
            } else if estaturaMedida < estaturaTeo_nsd2 {
                // Talla Baja para la Edad o Retraso en Talla
                sd1 = "< -2 DE"
                a = "Talla Baja para la Edad o Retraso en Talla"
            }
            
            // Peso para la edad
            let pesoParaEdad = pesoParaLaEdadF(edad: Float(edadEnMeses))
            
            if pesoParaEdad.sd1 < pesoKgMedido {
                // No Aplica (Verificar con IMC/E)
                sd2 = "≥ -1 DE a < a 1 DE"
                b = "No Aplica (Verificar con IMC/E)"
            } else if (pesoParaEdad.nsd1 <= pesoKgMedido) && (pesoKgMedido <= pesoParaEdad.sd1) {
                // Peso Adecuado para la Edad
                sd2 = "≥ -1 DE a < a 1 DE"
                b = "Peso Adecuado para la Edad"
            } else if (pesoParaEdad.nsd2 <= pesoKgMedido) && (pesoKgMedido < pesoParaEdad.nsd1) {
                // Riesgo de Desnutrición Global
                sd2 = "≥ -2 DE a < a -1 DE"
                b = "Riesgo de Desnutrición Global"
            } else if pesoKgMedido < pesoParaEdad.nsd2 {
                // Desnutrición Global
                sd2 = "< -2 DE"
                b = "Desnutrición Global"
            }
            
            // Peso para la longitud
            if edadEnMeses <= 24 {
                let pesoTeo = pesoParaLaLongitud0_24F(longitud: estaturaMedida)
                pesoKgTeo_sd0 = pesoTeo.sd0
                pesoKgTeo_sd1 = pesoTeo.sd1
                pesoKgTeo_sd2 = pesoTeo.sd2
                pesoKgTeo_sd3 = pesoTeo.sd3
                pesoKgTeo_nsd1 = pesoTeo.nsd1
                pesoKgTeo_nsd2 = pesoTeo.nsd2
                pesoKgTeo_nsd3 = pesoTeo.nsd3

            } else {
                let pesoTeo = pesoParaLaLongitud24_60F(longitud: estaturaMedida)
                pesoKgTeo_sd0 = pesoTeo.sd0
                pesoKgTeo_sd1 = pesoTeo.sd1
                pesoKgTeo_sd2 = pesoTeo.sd2
                pesoKgTeo_sd3 = pesoTeo.sd3
                pesoKgTeo_nsd1 = pesoTeo.nsd1
                pesoKgTeo_nsd2 = pesoTeo.nsd2
                pesoKgTeo_nsd3 = pesoTeo.nsd3
            }
            
            if pesoKgMedido > pesoKgTeo_sd3 {
                // Obesidad
                sd3 = "> 3 DE"
                c = "Obesidad"
            } else if (pesoKgTeo_sd2 < pesoKgMedido) && (pesoKgMedido <= pesoKgTeo_sd3) {
                // Sobrepeso
                sd3 = "> 2 DE a ≤ 3 DE"
                c = "Sobrepeso"
            } else if (pesoKgTeo_sd1 < pesoKgMedido) && (pesoKgMedido <= pesoKgTeo_sd2) {
                // Riesgo de Sobrepeso
                sd3 = "> 1 DE a ≤ 2 DE"
                c = "Riesgo de Sobrepeso"
            } else if (pesoKgTeo_nsd1 <= pesoKgMedido) && (pesoKgMedido <= pesoKgTeo_sd1) {
                // Peso Adecuado para la Talla
                sd3 = "≥ -1 DE a ≤ 1 DE"
                c = "Peso Adecuado para la Talla"
            } else if (pesoKgTeo_nsd2 <= pesoKgMedido) && (pesoKgMedido < pesoKgTeo_nsd1) {
                // Riesgo de Desnutrición Aguda
                sd3 = "≥ -2 DE a < -1 DE"
                c = "Riesgo de Desnutrición Aguda"
            } else if (pesoKgTeo_nsd3 <= pesoKgMedido) && (pesoKgMedido < pesoKgTeo_nsd2) {
                // Desnutrición Aguda Moderada
                sd3 = "≥ -3 DE a < -2 DE"
                c = "Desnutrición Aguda Moderada"
            } else if pesoKgMedido < pesoKgTeo_nsd3 {
                // Desnutrición Aguda Severa
                sd3 = "< -3 DE"
                c = "Desnutrición Aguda Severa"
            }
            
            // IMC para la edad
            if edadEnMeses <= 24 {
                let IMCTeo = IMCParaLaEdad0_24F(edad: Float(edadEnMeses))
                IMCTeo_sd0 = IMCTeo.sd0
                IMCTeo_sd1 = IMCTeo.sd1
                IMCTeo_sd2 = IMCTeo.sd2
                IMCTeo_sd3 = IMCTeo.sd3
                IMCTeo_nsd1 = IMCTeo.nsd1
                IMCTeo_nsd2 = IMCTeo.nsd2
                IMCTeo_nsd3 = IMCTeo.nsd3
                
            } else {
                let IMCTeo = IMCParaLaEdad24_60F(edad: Float(edadEnMeses))
                IMCTeo_sd0 = IMCTeo.sd0
                IMCTeo_sd1 = IMCTeo.sd1
                IMCTeo_sd2 = IMCTeo.sd2
                IMCTeo_sd3 = IMCTeo.sd3
                IMCTeo_nsd1 = IMCTeo.nsd1
                IMCTeo_nsd2 = IMCTeo.nsd2
                IMCTeo_nsd3 = IMCTeo.nsd3
            }
            
            if IMCMedido > IMCTeo_sd3 {
                // Obesidad
                sd4 = "> 3 DE"
                d = "Obesidad"
                
            } else if (IMCTeo_sd2 < IMCMedido) && (IMCMedido <= IMCTeo_sd3) {
                // Sobrepeso
                sd4 = "> 2 DE a ≤ 3 DE"
                d = "Sobrepeso"
                
            } else if (IMCTeo_sd1 < IMCMedido) && (IMCMedido <= IMCTeo_sd2) {
                // Riesgo de Sobrepeso
                sd4 = "> 1 DE a ≤ 2 DE"
                d = "Riesgo de Sobrepeso"
            } else if IMCTeo_sd1 >= IMCMedido {
                // No Aplica (Verificar con P/T)
                sd4 = "≤ 1 DE"
                d = "No Aplica (Verificar con P/T)"
            }
            
            // MUAC para la edad
            if perimetroBraquialMedido == 0 {
                sd5 = "-"
                e = "-"
            } else {
                if edadEnMeses >= 3 {
                    let MUACTeo = MUACparaLaEdad3_60F(edad: Float(edadEnMeses))
                    MUACTeo_sd0 = MUACTeo.sd0
                    MUACTeo_sd1 = MUACTeo.sd1
                    MUACTeo_sd2 = MUACTeo.sd2
                    MUACTeo_sd3 = MUACTeo.sd3
                    MUACTeo_nsd1 = MUACTeo.nsd1
                    MUACTeo_nsd2 = MUACTeo.nsd2
                    MUACTeo_nsd3 = MUACTeo.nsd3
                    
                    if perimetroBraquialMedido < 11.5 {
                        sd5 = "N/A"
                        e = "Desnutrición aguda severa y riesgo de muerte por desnutrición"
                    } else if (11.5 < perimetroBraquialMedido) && (perimetroBraquialMedido <= 12.5) {
                        sd5 = "N/A"
                        e = "Desnutrición aguda moderada"
                    } else if perimetroBraquialMedido <= 12.5 {
                        sd5 = "N/A"
                        e = "Desnutrición aguda global"
                    } else if perimetroBraquialMedido > 12.5 {
                        sd5 = "N/A"
                        e = "Perimetro adecuado para la edad"
                    }
                } else {
                    sd5 = "N/A"
                    e = "Solo aplica para mayores de 3 meses"
                }
            }
            
            
            // Perimetro cefalico para la edad
            if pCefMedido == 0 {
                sd6 = "-"
                f = "-"
            } else {
                let pCefTeo = pCefalicoParaLaEdad0_60F(edad: Float(edadEnMeses))
                pCefTeo_sd0 = pCefTeo.sd0
                pCefTeo_sd1 = pCefTeo.sd1
                pCefTeo_sd2 = pCefTeo.sd2
                pCefTeo_sd3 = pCefTeo.sd3
                pCefTeo_nsd1 = pCefTeo.nsd1
                pCefTeo_nsd2 = pCefTeo.nsd2
                pCefTeo_nsd3 = pCefTeo.nsd3
                
                if pCefMedido > pCefTeo_sd2 {
                    sd6 = "> 2 DE"
                    f = "Factor de Riesgo para el Neurodesarrollo"
                } else if (pCefTeo_nsd2 <= pCefMedido) && (pCefMedido <= pCefTeo_sd2) {
                    sd6 = "≥ -2 DE a ≤ 2 DE"
                    f = "Normal"
                } else if (pCefMedido < pCefTeo_nsd2) {
                    sd6 = "< -2 DE"
                    f = "Factor de Riesgo para el Neurodesarrollo"
                }
            }
            
        }
        if sexo == "Masculino" {
            // Estatura para la edad
            if edadEnMeses <= 24 {
                let estaturaTeo = estaturaParaLaEdad0_24M(edad: Float(edadEnMeses))
                estaturaTeo_sd0 = estaturaTeo.sd0
                estaturaTeo_sd1 = estaturaTeo.sd1
                estaturaTeo_sd2 = estaturaTeo.sd2
                estaturaTeo_sd3 = estaturaTeo.sd3
                estaturaTeo_nsd1 = estaturaTeo.nsd1
                estaturaTeo_nsd2 = estaturaTeo.nsd2
                estaturaTeo_nsd3 = estaturaTeo.nsd3
            } else {
                let estaturaTeo = estaturaParaLaEdad24_60M(edad: Float(edadEnMeses))
                estaturaTeo_sd0 = estaturaTeo.sd0
                estaturaTeo_sd1 = estaturaTeo.sd1
                estaturaTeo_sd2 = estaturaTeo.sd2
                estaturaTeo_sd3 = estaturaTeo.sd3
                estaturaTeo_nsd1 = estaturaTeo.nsd1
                estaturaTeo_nsd2 = estaturaTeo.nsd2
                estaturaTeo_nsd3 = estaturaTeo.nsd3
            }
            
            if estaturaMedida >= estaturaTeo_nsd1 {
                // Talla adecuada para la edad
                sd1 = "≥ -1 DE"
                a = "Talla adecuada para la edad"
            } else if (estaturaTeo_nsd2 <= estaturaMedida) && (estaturaMedida < estaturaTeo_nsd1) {
                // Riesgo de talla baja
                sd1 = "≥ -2 DE a < -1 DE"
                a = "Riesgo de talla baja"
            } else if estaturaMedida < estaturaTeo_nsd2 {
                // Talla Baja para la Edad o Retraso en Talla
                sd1 = "< -2 DE"
                a = "Talla Baja para la Edad o Retraso en Talla"
            }
            
            // Peso para la edad
            let pesoParaEdad = pesoParaLaEdadM(edad: Float(edadEnMeses))
            
            if pesoParaEdad.sd1 < pesoKgMedido {
                // No Aplica (Verificar con IMC/E)
                sd2 = "≥ -1 DE a < a 1 DE"
                b = "No Aplica (Verificar con IMC/E)"
            } else if (pesoParaEdad.nsd1 <= pesoKgMedido) && (pesoKgMedido <= pesoParaEdad.sd1) {
                // Peso Adecuado para la Edad
                sd2 = "≥ -1 DE a < a 1 DE"
                b = "Peso Adecuado para la Edad"
            } else if (pesoParaEdad.nsd2 <= pesoKgMedido) && (pesoKgMedido < pesoParaEdad.nsd1) {
                // Riesgo de Desnutrición Global
                sd2 = "≥ -2 DE a < a -1 DE"
                b = "Riesgo de Desnutrición Global"
            } else if pesoKgMedido < pesoParaEdad.nsd2 {
                // Desnutrición Global
                sd2 = "< -2 DE"
                b = "Desnutrición Global"
            }
            
            // Peso para la longitud
            if edadEnMeses <= 24 {
                let pesoTeo = pesoParaLaLongitud0_24M(longitud: estaturaMedida)
                pesoKgTeo_sd0 = pesoTeo.sd0
                pesoKgTeo_sd1 = pesoTeo.sd1
                pesoKgTeo_sd2 = pesoTeo.sd2
                pesoKgTeo_sd3 = pesoTeo.sd3
                pesoKgTeo_nsd1 = pesoTeo.nsd1
                pesoKgTeo_nsd2 = pesoTeo.nsd2
                pesoKgTeo_nsd3 = pesoTeo.nsd3
                
            } else {
                let pesoTeo = pesoParaLaLongitud24_60M(longitud: estaturaMedida)
                pesoKgTeo_sd0 = pesoTeo.sd0
                pesoKgTeo_sd1 = pesoTeo.sd1
                pesoKgTeo_sd2 = pesoTeo.sd2
                pesoKgTeo_sd3 = pesoTeo.sd3
                pesoKgTeo_nsd1 = pesoTeo.nsd1
                pesoKgTeo_nsd2 = pesoTeo.nsd2
                pesoKgTeo_nsd3 = pesoTeo.nsd3
            }
            
            if pesoKgMedido > pesoKgTeo_sd3 {
                // Obesidad
                sd3 = "> 3 DE"
                c = "Obesidad"
            } else if (pesoKgTeo_sd2 < pesoKgMedido) && (pesoKgMedido <= pesoKgTeo_sd3) {
                // Sobrepeso
                sd3 = "> 2 DE a ≤ 3 DE"
                c = "Sobrepeso"
            } else if (pesoKgTeo_sd1 < pesoKgMedido) && (pesoKgMedido <= pesoKgTeo_sd2) {
                // Riesgo de Sobrepeso
                sd3 = "> 1 DE a ≤ 2 DE"
                c = "Riesgo de Sobrepeso"
            } else if (pesoKgTeo_nsd1 <= pesoKgMedido) && (pesoKgMedido <= pesoKgTeo_sd1) {
                // Peso Adecuado para la Talla
                sd3 = "≥ -1 DE a ≤ 1 DE"
                c = "Peso Adecuado para la Talla"
            } else if (pesoKgTeo_nsd2 <= pesoKgMedido) && (pesoKgMedido < pesoKgTeo_nsd1) {
                // Riesgo de Desnutrición Aguda
                sd3 = "≥ -2 DE a < -1 DE"
                c = "Riesgo de Desnutrición Aguda"
            } else if (pesoKgTeo_nsd3 <= pesoKgMedido) && (pesoKgMedido < pesoKgTeo_nsd2) {
                // Desnutrición Aguda Moderada
                sd3 = "≥ -3 DE a < -2 DE"
                c = "Desnutrición Aguda Moderada"
            } else if pesoKgMedido < pesoKgTeo_nsd3 {
                // Desnutrición Aguda Severa
                sd3 = "< -3 DE"
                c = "Desnutrición Aguda Severa"
            }
            
            // IMC para la edad
            if edadEnMeses <= 24 {
                let IMCTeo = IMCParaLaEdad0_24M(edad: Float(edadEnMeses))
                IMCTeo_sd0 = IMCTeo.sd0
                IMCTeo_sd1 = IMCTeo.sd1
                IMCTeo_sd2 = IMCTeo.sd2
                IMCTeo_sd3 = IMCTeo.sd3
                IMCTeo_nsd1 = IMCTeo.nsd1
                IMCTeo_nsd2 = IMCTeo.nsd2
                IMCTeo_nsd3 = IMCTeo.nsd3
                
            } else {
                let IMCTeo = IMCParaLaEdad24_60M(edad: Float(edadEnMeses))
                IMCTeo_sd0 = IMCTeo.sd0
                IMCTeo_sd1 = IMCTeo.sd1
                IMCTeo_sd2 = IMCTeo.sd2
                IMCTeo_sd3 = IMCTeo.sd3
                IMCTeo_nsd1 = IMCTeo.nsd1
                IMCTeo_nsd2 = IMCTeo.nsd2
                IMCTeo_nsd3 = IMCTeo.nsd3
            }
            
            if IMCMedido > IMCTeo_sd3 {
                // Obesidad
                sd4 = "> 3 DE"
                d = "Obesidad"
                
            } else if (IMCTeo_sd2 < IMCMedido) && (IMCMedido <= IMCTeo_sd3) {
                // Sobrepeso
                sd4 = "> 2 DE a ≤ 3 DE"
                d = "Sobrepeso"
                
            } else if (IMCTeo_sd1 < IMCMedido) && (IMCMedido <= IMCTeo_sd2) {
                // Riesgo de Sobrepeso
                sd4 = "> 1 DE a ≤ 2 DE"
                d = "Riesgo de Sobrepeso"
            } else if IMCTeo_sd1 >= IMCMedido {
                // No Aplica (Verificar con P/T)
                sd4 = "≤ 1 DE"
                d = "No Aplica (Verificar con P/T)"
            }
            
            // MUAC para la edad
            if perimetroBraquialMedido == 0 {
                sd5 = "-"
                e = "-"
            } else {
                if edadEnMeses >= 3 {
                    let MUACTeo = MUACparaLaEdad3_60M(edad: Float(edadEnMeses))
                    MUACTeo_sd0 = MUACTeo.sd0
                    MUACTeo_sd1 = MUACTeo.sd1
                    MUACTeo_sd2 = MUACTeo.sd2
                    MUACTeo_sd3 = MUACTeo.sd3
                    MUACTeo_nsd1 = MUACTeo.nsd1
                    MUACTeo_nsd2 = MUACTeo.nsd2
                    MUACTeo_nsd3 = MUACTeo.nsd3
                    
                    if perimetroBraquialMedido < 11.5 {
                        sd5 = "N/A"
                        e = "Desnutrición aguda severa y riesgo de muerte por desnutrición"
                    } else if (11.5 < perimetroBraquialMedido) && (perimetroBraquialMedido <= 12.5) {
                        sd5 = "N/A"
                        e = "Desnutrición aguda moderada"
                    } else if perimetroBraquialMedido <= 12.5 {
                        sd5 = "N/A"
                        e = "Desnutrición aguda global"
                    } else if perimetroBraquialMedido > 12.5 {
                        sd5 = "N/A"
                        e = "Perimetro adecuado para la edad"
                    }
                } else {
                    sd5 = "N/A"
                    e = "Solo aplica para mayores de 3 meses"
                }
            }
            
            
            // Perimetro cefalico para la edad
            if pCefMedido == 0 {
                sd6 = "-"
                f = "-"
            } else {
                let pCefTeo = pCefalicoParaLaEdad0_60M(edad: Float(edadEnMeses))
                pCefTeo_sd0 = pCefTeo.sd0
                pCefTeo_sd1 = pCefTeo.sd1
                pCefTeo_sd2 = pCefTeo.sd2
                pCefTeo_sd3 = pCefTeo.sd3
                pCefTeo_nsd1 = pCefTeo.nsd1
                pCefTeo_nsd2 = pCefTeo.nsd2
                pCefTeo_nsd3 = pCefTeo.nsd3
                
                if pCefMedido > pCefTeo_sd2 {
                    sd6 = "> 2 DE"
                    f = "Factor de Riesgo para el Neurodesarrollo"
                } else if (pCefTeo_nsd2 <= pCefMedido) && (pCefMedido <= pCefTeo_sd2) {
                    sd6 = "≥ -2 DE a ≤ 2 DE"
                    f = "Normal"
                } else if (pCefMedido < pCefTeo_nsd2) {
                    sd6 = "< -2 DE"
                    f = "Factor de Riesgo para el Neurodesarrollo"
                }
            }
        }
        
        puntoDeCorte = ["Punto de corte (desviaciones estandar DE)",sd3, sd1, sd6, sd4, sd2, sd5]
        clasificacion = ["Clasificación antropométrica",c, a, f, d, b, e]
    }
    
    
    @IBAction func infoPressed(_ sender: UIBarButtonItem) {
        createAlert(title: "Indicadores del estado nutricional", message: "Los siguientes son todos indicadores del estado nutricional de un niño menor de 5 años: \nPeso para la talla (P/T) \nTalla para la edad (T/E) \nP. cefálico para la edad (PC/E) \nP. cefálico para la edad (PC/E) \nIndice de masa corporal para la edad (IMC/E) \nPeso para la edad (P/E) \nP. brazo para la edad (MUAC) - Medida complementaria e independiente")
    }
    
    @IBAction func salirBtn(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
        }
        catch {
            print("Error, hubo un problema al salir.")
        }
    }

}
