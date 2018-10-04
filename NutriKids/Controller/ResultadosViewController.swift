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

class ResultadosViewController: UIViewController {
    
    var estatura: Float = 0
    var pesoKg: Float = 0
    var edadEnMeses: Float = 0
    var perimetroBraquial: Float = 0
    var IMC: Float = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        SVProgressHUD.dismiss()
        print(estaturaParaLaEdad0_24(edad: 10))
        print(estaturaParaLaEdad24_60(edad: 25))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
    
    func IMC(peso: Float, altura: Float) -> Float {
        let variable = peso/(powf(altura, 2))
        return variable
    }
    
    func estaturaParaLaEdad0_24(edad: Float) -> (sd0: Float, nsd2: Float, nsd3: Float, sd2: Float, sd3: Float) {
        let aux_sd0 = ((-1.213*powf(10, -6))*powf(edad, 6)) + ((0.0001053)*powf(edad, 5)) + ((-0.003672)*powf(edad, 4)) + ((0.06613)*powf(edad, 3)) + ((-0.6722)*powf(edad, 2)) + ((5.08)*edad) + (49.14)
        let aux_nsd2 = ((-1.053*powf(10, -6))*powf(edad, 6)) + ((9.289*powf(10, -5))*powf(edad, 5)) + ((-0.003295)*powf(edad, 4)) + ((0.0605)*powf(edad, 3)) + ((-0.6299)*powf(edad, 2)) + ((4.828)*edad) + (45.45)
        let aux_nsd3 = ((-1.067*powf(10, -6))*powf(edad, 6)) + ((9.224*powf(10, -5))*powf(edad, 5)) + ((-0.003217)*powf(edad, 4)) + ((0.0584)*powf(edad, 3)) + ((-0.6069)*powf(edad, 2)) + ((4.674)*edad) + (43.63)
        let aux_sd2 = ((-9.603*powf(10, -7))*powf(edad, 6)) + ((8.732*powf(10, -5))*powf(edad, 5)) + ((-0.003194)*powf(edad, 4)) + ((0.0604)*powf(edad, 3)) + ((-0.6441)*powf(edad, 2)) + ((5.166)*edad) + (52.94)
        let aux_sd3 = ((-1.144*powf(10, -6))*powf(edad, 6)) + ((0.0001012)*powf(edad, 5)) + ((-0.003607)*powf(edad, 4)) + ((0.0665)*powf(edad, 3)) + ((-0.6895)*powf(edad, 2)) + ((5.368)*edad) + (54.72)
        
        return (aux_sd0,aux_nsd2,aux_nsd3,aux_sd2,aux_sd3)
    }
    
    func estaturaParaLaEdad24_60(edad: Float) -> (sd0: Float, nsd2: Float, nsd3: Float, sd2: Float, sd3: Float) {
        let aux_sd0 = ((7.103*powf(10, -5))*powf(edad, 3)) + ((-0.01341)*powf(edad, 2)) + ((1.386)*edad) + (59.22)
        let aux_nsd2 = ((6.05*powf(10, -5))*powf(edad, 3)) + ((-0.01162)*powf(edad, 2)) + ((1.21)*edad) + (56.11)
        let aux_nsd3 = ((5.784*powf(10, -5))*powf(edad, 3)) + ((-0.0111)*powf(edad, 2)) + ((1.138)*edad) + (54.36)
        let aux_sd2 = ((7.057*powf(10, -5))*powf(edad, 3)) + ((-0.01391)*powf(edad, 2)) + ((1.515)*edad) + (62.89)
        let aux_sd3 = ((8.155*powf(10, -5))*powf(edad, 3)) + ((-0.01545)*powf(edad, 2)) + ((1.627)*edad) + (64.14)
        
        return (aux_sd0,aux_nsd2,aux_nsd3,aux_sd2,aux_sd3)
    }

}
