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
//        print(estaturaParaLaEdad0_24(edad: 10))
//        print(estaturaParaLaEdad24_60(edad: 25))
//        print(pesoParaLaEdad(edad: 10))
//        print(pesoParaLaLongitud0_24(longitud: 80))
//        print(pesoParaLaLongitud24_60(longitud: 80))
//        print(IMCParaLaEdad0_24(edad: 10))
        print(MUACparaLaEdad3_60(edad: 10))
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
    
    // MARK: Mujeres
    
    func estaturaParaLaEdad0_24(edad: Float) -> (sd0: Float,nsd1: Float,nsd2: Float,nsd3: Float,sd1: Float,sd2: Float, sd3: Float) {
        let aux_sd0 = ((-1.213*powf(10, -6))*powf(edad, 6)) + ((0.0001053)*powf(edad, 5)) + ((-0.003672)*powf(edad, 4)) + ((0.06613)*powf(edad, 3)) + ((-0.6722)*powf(edad, 2)) + ((5.08)*edad) + (49.14)
        let aux_nsd1 = ((-9.256*powf(10, -7))*powf(edad, 6)) + ((8.308*powf(10, -5))*powf(edad, 5)) + ((-0.003012)*powf(edad, 4)) + ((0.05674)*powf(edad, 3)) + ((-0.608)*powf(edad, 2)) + ((4.846)*edad) + (47.34)
        let aux_nsd2 = ((-1.053*powf(10, -6))*powf(edad, 6)) + ((9.289*powf(10, -5))*powf(edad, 5)) + ((-0.003295)*powf(edad, 4)) + ((0.0605)*powf(edad, 3)) + ((-0.6299)*powf(edad, 2)) + ((4.828)*edad) + (45.45)
        let aux_nsd3 = ((-1.067*powf(10, -6))*powf(edad, 6)) + ((9.224*powf(10, -5))*powf(edad, 5)) + ((-0.003217)*powf(edad, 4)) + ((0.0584)*powf(edad, 3)) + ((-0.6069)*powf(edad, 2)) + ((4.674)*edad) + (43.63)
        let aux_sd1 = ((-1.073*powf(10, -6))*powf(edad, 6)) + ((9.488*powf(10, -5))*powf(edad, 5)) + ((-0.003384)*powf(edad, 4)) + ((0.06256)*powf(edad, 3)) + ((-0.6542)*powf(edad, 2)) + ((5.119)*edad) + (51.03)
        let aux_sd2 = ((-9.603*powf(10, -7))*powf(edad, 6)) + ((8.732*powf(10, -5))*powf(edad, 5)) + ((-0.003194)*powf(edad, 4)) + ((0.0604)*powf(edad, 3)) + ((-0.6441)*powf(edad, 2)) + ((5.166)*edad) + (52.94)
        let aux_sd3 = ((-1.144*powf(10, -6))*powf(edad, 6)) + ((0.0001012)*powf(edad, 5)) + ((-0.003607)*powf(edad, 4)) + ((0.0665)*powf(edad, 3)) + ((-0.6895)*powf(edad, 2)) + ((5.368)*edad) + (54.72)
        
        return (aux_sd0,aux_nsd1,aux_nsd2,aux_nsd3,aux_sd1,aux_sd2,aux_sd3)
    }
    
    func estaturaParaLaEdad24_60(edad: Float) -> (sd0: Float,nsd1: Float,nsd2: Float,nsd3: Float,sd1: Float,sd2: Float, sd3: Float) {
        let aux_sd0 = ((7.103*powf(10, -5))*powf(edad, 3)) + ((-0.01341)*powf(edad, 2)) + ((1.386)*edad) + (59.22)
        let aux_nsd1 = ((6.626*powf(10, -5))*powf(edad, 3)) + ((-0.01259)*powf(edad, 2)) + ((1.302)*edad) + (57.61)
        let aux_nsd2 = ((6.626*powf(10, -5))*powf(edad, 3)) + ((-0.01259)*powf(edad, 2)) + ((1.302)*edad) + (57.61)
        let aux_nsd3 = ((5.784*powf(10, -5))*powf(edad, 3)) + ((-0.0111)*powf(edad, 2)) + ((1.138)*edad) + (54.36)
        let aux_sd1 = ((6.96*powf(10, -5))*powf(edad, 3)) + ((-0.0135)*powf(edad, 2)) + ((1.444)*edad) + (61.15)
        let aux_sd2 = ((7.057*powf(10, -5))*powf(edad, 3)) + ((-0.01391)*powf(edad, 2)) + ((1.515)*edad) + (62.89)
        let aux_sd3 = ((8.155*powf(10, -5))*powf(edad, 3)) + ((-0.01545)*powf(edad, 2)) + ((1.627)*edad) + (64.14)
        
        return (aux_sd0,aux_nsd1,aux_nsd2,aux_nsd3,aux_sd1,aux_sd2,aux_sd3)
    }
    
    func pesoParaLaEdad(edad: Float) -> (sd0: Float,nsd1: Float,nsd2: Float,nsd3: Float,sd1: Float,sd2: Float, sd3: Float) {
        let aux_sd0 = ((1.598*powf(10, -10))*powf(edad, 7)) + ((-3.935*powf(10, -8))*powf(edad, 6)) + ((3.96*powf(10, -6))*powf(edad, 5)) + ((-0.0002095)*powf(edad, 4)) + ((0.00624)*powf(edad, 3)) + ((-0.1044)*powf(edad, 2)) + ((1.121)*edad) + (3.207)
        let aux_nsd1 = ((1.627*powf(10, -10))*powf(edad, 7)) + ((-3.97*powf(10, -8))*powf(edad, 6)) + ((3.959*powf(10, -6))*powf(edad, 5)) + ((-0.0002072)*powf(edad, 4)) + ((0.006089)*powf(edad, 3)) + ((-0.1001)*powf(edad, 2)) + ((1.039)*edad) + (2.764)
        let aux_nsd2 = ((1.102*powf(10, -10))*powf(edad, 7)) + ((-2.799*powf(10, -8))*powf(edad, 6)) + ((2.906*powf(10, -6))*powf(edad, 5)) + ((-0.0001585)*powf(edad, 4)) + ((0.004853)*powf(edad, 3)) + ((-0.08338)*powf(edad, 2)) + ((0.9116)*edad) + (2.389)
        let aux_nsd3 = ((1.384*powf(10, -10))*powf(edad, 7)) + ((-3.371*powf(10, -8))*powf(edad, 6)) + ((3.359*powf(10, -6))*powf(edad, 5)) + ((-0.0001758)*powf(edad, 4)) + ((0.005161)*powf(edad, 3)) + ((-0.08493)*powf(edad, 2)) + ((0.8772)*edad) + (1.965)
        let aux_sd1 = ((1.62*powf(10, -10))*powf(edad, 7)) + ((-4.01*powf(10, -8))*powf(edad, 6)) + ((4.064*powf(10, -6))*powf(edad, 5)) + ((-0.0002171)*powf(edad, 4)) + ((0.006557)*powf(edad, 3)) + ((-0.1116)*powf(edad, 2)) + ((1.231)*edad) + (3.714)
        let aux_sd2 = ((1.853*powf(10, -10))*powf(edad, 7)) + ((-4.551*powf(10, -8))*powf(edad, 6)) + ((4.575*powf(10, -6))*powf(edad, 5)) + ((-0.0002426)*powf(edad, 4)) + ((0.007293)*powf(edad, 3)) + ((-0.1238)*powf(edad, 2)) + ((1.376)*edad) + (4.245)
        let aux_sd3 = ((2.049*powf(10, -10))*powf(edad, 7)) + ((-5.013*powf(10, -8))*powf(edad, 6)) + ((5.018*powf(10, -6))*powf(edad, 5)) + ((-0.0002654)*powf(edad, 4)) + ((0.007987)*powf(edad, 3)) + ((-0.1365)*powf(edad, 2)) + ((1.546)*edad) + (4.829)
        
        return (aux_sd0,aux_nsd1,aux_nsd2,aux_nsd3,aux_sd1,aux_sd2,aux_sd3)
    }
    
    func pesoParaLaLongitud0_24(longitud: Float) -> (sd0: Float,nsd1: Float,nsd2: Float,nsd3: Float,sd1: Float,sd2: Float, sd3: Float) {
        let aux_sd0 = ((3.324*powf(10, -5))*powf(longitud, 3)) + ((-0.007228)*powf(longitud, 2)) + ((0.7346)*longitud) + (-19.35)
        let aux_nsd1 = ((2.853*powf(10, -5))*powf(longitud, 3)) + ((-0.006206)*powf(longitud, 2)) + ((0.6439)*longitud) + (-17.08)
        let aux_nsd2 = ((2.457*powf(10, -5))*powf(longitud, 3)) + ((-0.005346)*powf(longitud, 2)) + ((0.5667)*longitud) + (-15.14)
        let aux_nsd3 = ((2.122*powf(10, -5))*powf(longitud, 3)) + ((-0.004618)*powf(longitud, 2)) + ((0.5005)*longitud) + (-13.47)
        let aux_sd1 = ((3.887*powf(10, -5))*powf(longitud, 3)) + ((-0.008451)*powf(longitud, 2)) + ((0.8419)*longitud) + (-22.03)
        let aux_sd2 = ((4.563*powf(10, -5))*powf(longitud, 3)) + ((-0.009918)*powf(longitud, 2)) + ((0.9693)*longitud) + (-25.19)
        let aux_sd3 = ((5.38*powf(10, -5))*powf(longitud, 3)) + ((-0.01169)*powf(longitud, 2)) + ((1.122)*longitud) + (-28.96)
        
//        let aux_sd0 = ((-5.485*powf(10, -5))*powf(peso, 6)) + ((0.003613)*powf(peso, 5)) + ((-0.0941)*powf(peso, 4)) + ((1.218)*powf(peso, 3)) + ((-8.099)*powf(peso, 2)) + ((30.11)*peso) + (4.702)
//        let aux_nsd1 = ((-3.126*powf(10, -5))*powf(peso, 6)) + ((0.002268)*powf(peso, 5)) + ((-0.06502)*powf(peso, 4)) + ((0.9256)*powf(peso, 3)) + ((-6.761)*powf(peso, 2)) + ((27.55)*peso) + (4.585)
//        let aux_nsd2 = ((-1.748*powf(10, -5))*powf(peso, 6)) + ((0.001402)*powf(peso, 5)) + ((-0.04441)*powf(peso, 4)) + ((0.6977)*powf(peso, 3)) + ((-5.616)*powf(peso, 2)) + ((25.17)*peso) + (4.405)
//        let aux_nsd3 = ((-9.582*powf(10, -6))*powf(peso, 6)) + ((0.0008527)*powf(peso, 5)) + ((-0.02995)*powf(peso, 4)) + ((0.521)*powf(peso, 3)) + ((-4.639)*powf(peso, 2)) + ((22.94)*peso) + (4.184)
//        let aux_sd1 = ((-9.446*powf(10, -5))*powf(peso, 6)) + ((0.005668)*powf(peso, 5)) + ((-0.1345)*powf(peso, 4)) + ((1.588)*powf(peso, 3)) + ((-9.642)*powf(peso, 2)) + ((32.79)*peso) + (4.835)
//        let aux_sd2 = ((-0.0001601)*powf(peso, 6)) + ((0.008777)*powf(peso, 5)) + ((-0.1904)*powf(peso, 4)) + ((2.056)*powf(peso, 3)) + ((-11.44)*powf(peso, 2)) + ((35.66)*peso) + (4.905)
//        let aux_sd3 = ((-0.000267)*powf(peso, 6)) + ((0.01341)*powf(peso, 5)) + ((-0.2668)*powf(peso, 4)) + ((2.643)*powf(peso, 3)) + ((-13.5)*powf(peso, 2)) + ((38.72)*peso) + (4.947)
        
        return (aux_sd0,aux_nsd1,aux_nsd2,aux_nsd3,aux_sd1,aux_sd2,aux_sd3)
    }
    
    func pesoParaLaLongitud24_60(longitud: Float) -> (sd0: Float,nsd1: Float,nsd2: Float,nsd3: Float,sd1: Float,sd2: Float, sd3: Float) {
        let aux_sd0 = ((3.774*powf(10, -5))*powf(longitud, 3)) + ((-0.007964)*powf(longitud, 2)) + ((0.7597)*longitud) + (-18.82)
        let aux_nsd1 = ((3.383*powf(10, -5))*powf(longitud, 3)) + ((-0.007257)*powf(longitud, 2)) + ((0.7055)*longitud) + (-17.87)
        let aux_nsd2 = ((2.794*powf(10, -5))*powf(longitud, 3)) + ((-0.005888)*powf(longitud, 2)) + ((0.584)*longitud) + (-14.66)
        let aux_nsd3 = ((2.415*powf(10, -5))*powf(longitud, 3)) + ((-0.005053)*powf(longitud, 2)) + ((0.5092)*longitud) + (-12.77)
        let aux_sd1 = ((4.583*powf(10, -5))*powf(longitud, 3)) + ((-0.009823)*powf(longitud, 2)) + ((0.9212)*longitud) + (-22.99)
        let aux_sd2 = ((5.314*powf(10, -5))*powf(longitud, 3)) + ((-0.01138)*powf(longitud, 2)) + ((1.052)*longitud) + (-26.13)
        let aux_sd3 = ((6.229*powf(10, -5))*powf(longitud, 3)) + ((-0.01332)*powf(longitud, 2)) + ((1.21)*longitud) + (-29.8)
        
        return (aux_sd0,aux_nsd1,aux_nsd2,aux_nsd3,aux_sd1,aux_sd2,aux_sd3)
    }
    
    func IMCParaLaEdad0_24(edad: Float) -> (sd0: Float,nsd1: Float,nsd2: Float,nsd3: Float,sd1: Float,sd2: Float, sd3: Float) {
        let aux_sd0 = ((-4.489*powf(10, -8))*powf(edad, 7)) + ((3.513*powf(10, -6))*powf(edad, 6)) + ((-9.744*powf(10, -5))*powf(edad, 5)) + ((0.0008795)*powf(edad, 4)) + ((0.008803)*powf(edad, 3)) + ((-0.2475)*powf(edad, 2)) + ((1.745)*edad) + (12.95)
        let aux_nsd1 = ((-6.628*powf(10, -8))*powf(edad, 7)) + ((5.434*powf(10, -6))*powf(edad, 6)) + ((-0.0001664)*powf(edad, 5)) + ((0.002148)*powf(edad, 4)) + ((-0.004085)*powf(edad, 3)) + ((-0.1745)*powf(edad, 2)) + ((1.532)*edad) + (11.77)
        let aux_nsd2 = ((-6.745*powf(10, -8))*powf(edad, 7)) + ((5.655*powf(10, -6))*powf(edad, 6)) + ((-0.0001796)*powf(edad, 5)) + ((0.002517)*powf(edad, 4)) + ((-0.009519)*powf(edad, 3)) + ((-0.1313)*powf(edad, 2)) + ((1.376)*edad) + (10.64)
        let aux_nsd3 = ((-1.191*powf(10, -7))*powf(edad, 7)) + ((1*powf(10, -5))*powf(edad, 6)) + ((-0.0003249)*powf(edad, 5)) + ((0.004975)*powf(edad, 4)) + ((-0.03171)*powf(edad, 3)) + ((-0.02756)*powf(edad, 2)) + ((1.165)*edad) + (9.56)
        let aux_sd1 = ((-5.023*powf(10, -8))*powf(edad, 7)) + ((3.842*powf(10, -6))*powf(edad, 6)) + ((-0.0001025)*powf(edad, 5)) + ((0.0008062)*powf(edad, 4)) + ((0.01205)*powf(edad, 3)) + ((-0.2876)*powf(edad, 2)) + ((1.948)*edad) + (14.2)
        let aux_sd2 = ((-6.551*powf(10, -8))*powf(edad, 7)) + ((5.176*powf(10, -6))*powf(edad, 6)) + ((-0.0001485)*powf(edad, 5)) + ((0.001583)*powf(edad, 4)) + ((0.005785)*powf(edad, 3)) + ((-0.2742)*powf(edad, 2)) + ((2.039)*edad) + (15.63)
        let aux_sd3 = ((-7.795*powf(10, -8))*powf(edad, 7)) + ((6.364*powf(10, -6))*powf(edad, 6)) + ((-0.0001926)*powf(edad, 5)) + ((0.002368)*powf(edad, 4)) + ((-0.0005273)*powf(edad, 3)) + ((-0.2654)*powf(edad, 2)) + ((2.184)*edad) + (17.1)
        
        return (aux_sd0,aux_nsd1,aux_nsd2,aux_nsd3,aux_sd1,aux_sd2,aux_sd3)
    }
    
    func IMCParaLaEdad24_60(edad: Float) -> (sd0: Float,nsd1: Float,nsd2: Float,nsd3: Float,sd1: Float,sd2: Float, sd3: Float) {
        
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
    
    func MUACparaLaEdad3_60(edad: Float) -> (sd0: Float,nsd1: Float,nsd2: Float,nsd3: Float,sd1: Float,sd2: Float, sd3: Float) {
        let aux_sd0 = ((-4.433*powf(10, -9))*powf(edad, 6)) + ((9.075*powf(10, -7))*powf(edad, 5)) + ((-7.23*powf(10, -5))*powf(edad, 4)) + ((0.002818)*powf(edad, 3)) + ((-0.05544)*powf(edad, 2)) + ((0.5681)*edad) + (11.81)
        let aux_nsd1 = ((-3.614*powf(10, -9))*powf(edad, 6)) + ((7.389*powf(10, -7))*powf(edad, 5)) + ((-5.877*powf(10, -5))*powf(edad, 4)) + ((0.002287)*powf(edad, 3)) + ((-0.04516)*powf(edad, 2)) + ((0.4769)*edad) + (10.98)
        let aux_nsd2 = ((-3.643*powf(10, -9))*powf(edad, 6)) + ((7.385*powf(10, -7))*powf(edad, 5)) + ((-5.811*powf(10, -5))*powf(edad, 4)) + ((0.002231)*powf(edad, 3)) + ((-0.0434)*powf(edad, 2)) + ((0.4507)*edad) + (10.1)
        let aux_nsd3 = ((-3.248*powf(10, -9))*powf(edad, 6)) + ((6.563*powf(10, -7))*powf(edad, 5)) + ((-5.152*powf(10, -5))*powf(edad, 4)) + ((0.001976)*powf(edad, 3)) + ((-0.03855)*powf(edad, 2)) + ((0.4049)*edad) + (9.363)
        let aux_sd1 = ((-4.523*powf(10, -9))*powf(edad, 6)) + ((9.301*powf(10, -7))*powf(edad, 5)) + ((-7.466*powf(10, -5))*powf(edad, 4)) + ((0.002941)*powf(edad, 3)) + ((-0.05849)*powf(edad, 2)) + ((0.6048)*edad) + (12.88)
        let aux_sd2 = ((-5.493*powf(10, -9))*powf(edad, 6)) + ((1.13*powf(10, -6))*powf(edad, 5)) + ((-9.087*powf(10, -5))*powf(edad, 4)) + ((0.003587)*powf(edad, 3)) + ((-0.07131)*powf(edad, 2)) + ((0.7234)*edad) + (13.84)
        let aux_sd3 = ((-6.098*powf(10, -9))*powf(edad, 6)) + ((1.258*powf(10, -6))*powf(edad, 5)) + ((-0.0001014)*powf(edad, 4)) + ((0.004009)*powf(edad, 3)) + ((-0.07966)*powf(edad, 2)) + ((0.8012)*edad) + (15.08)
        
        return (aux_sd0,aux_nsd1,aux_nsd2,aux_nsd3,aux_sd1,aux_sd2,aux_sd3)
    }
    
    // Mark: Hombres
    func estaturaParaLaEdad0_24M(edad: Float) -> (sd0: Float,nsd1: Float,nsd2: Float,nsd3: Float,sd1: Float,sd2: Float, sd3: Float) {
        let aux_sd0 = ((-1.213*powf(10, -6))*powf(edad, 6)) + ((0.0001053)*powf(edad, 5)) + ((-0.003672)*powf(edad, 4)) + ((0.06613)*powf(edad, 3)) + ((-0.6722)*powf(edad, 2)) + ((5.08)*edad) + (49.14)
        let aux_nsd1 = ((-9.256*powf(10, -7))*powf(edad, 6)) + ((8.308*powf(10, -5))*powf(edad, 5)) + ((-0.003012)*powf(edad, 4)) + ((0.05674)*powf(edad, 3)) + ((-0.608)*powf(edad, 2)) + ((4.846)*edad) + (47.34)
        let aux_nsd2 = ((-1.053*powf(10, -6))*powf(edad, 6)) + ((9.289*powf(10, -5))*powf(edad, 5)) + ((-0.003295)*powf(edad, 4)) + ((0.0605)*powf(edad, 3)) + ((-0.6299)*powf(edad, 2)) + ((4.828)*edad) + (45.45)
        let aux_nsd3 = ((-1.067*powf(10, -6))*powf(edad, 6)) + ((9.224*powf(10, -5))*powf(edad, 5)) + ((-0.003217)*powf(edad, 4)) + ((0.0584)*powf(edad, 3)) + ((-0.6069)*powf(edad, 2)) + ((4.674)*edad) + (43.63)
        let aux_sd1 = ((-1.073*powf(10, -6))*powf(edad, 6)) + ((9.488*powf(10, -5))*powf(edad, 5)) + ((-0.003384)*powf(edad, 4)) + ((0.06256)*powf(edad, 3)) + ((-0.6542)*powf(edad, 2)) + ((5.119)*edad) + (51.03)
        let aux_sd2 = ((-9.603*powf(10, -7))*powf(edad, 6)) + ((8.732*powf(10, -5))*powf(edad, 5)) + ((-0.003194)*powf(edad, 4)) + ((0.0604)*powf(edad, 3)) + ((-0.6441)*powf(edad, 2)) + ((5.166)*edad) + (52.94)
        let aux_sd3 = ((-1.144*powf(10, -6))*powf(edad, 6)) + ((0.0001012)*powf(edad, 5)) + ((-0.003607)*powf(edad, 4)) + ((0.0665)*powf(edad, 3)) + ((-0.6895)*powf(edad, 2)) + ((5.368)*edad) + (54.72)
        
        return (aux_sd0,aux_nsd1,aux_nsd2,aux_nsd3,aux_sd1,aux_sd2,aux_sd3)
    }
    
    func estaturaParaLaEdad24_60M(edad: Float) -> (sd0: Float,nsd1: Float,nsd2: Float,nsd3: Float,sd1: Float,sd2: Float, sd3: Float) {
        let aux_sd0 = ((7.103*powf(10, -5))*powf(edad, 3)) + ((-0.01341)*powf(edad, 2)) + ((1.386)*edad) + (59.22)
        let aux_nsd1 = ((6.626*powf(10, -5))*powf(edad, 3)) + ((-0.01259)*powf(edad, 2)) + ((1.302)*edad) + (57.61)
        let aux_nsd2 = ((6.626*powf(10, -5))*powf(edad, 3)) + ((-0.01259)*powf(edad, 2)) + ((1.302)*edad) + (57.61)
        let aux_nsd3 = ((5.784*powf(10, -5))*powf(edad, 3)) + ((-0.0111)*powf(edad, 2)) + ((1.138)*edad) + (54.36)
        let aux_sd1 = ((6.96*powf(10, -5))*powf(edad, 3)) + ((-0.0135)*powf(edad, 2)) + ((1.444)*edad) + (61.15)
        let aux_sd2 = ((7.057*powf(10, -5))*powf(edad, 3)) + ((-0.01391)*powf(edad, 2)) + ((1.515)*edad) + (62.89)
        let aux_sd3 = ((8.155*powf(10, -5))*powf(edad, 3)) + ((-0.01545)*powf(edad, 2)) + ((1.627)*edad) + (64.14)
        
        return (aux_sd0,aux_nsd1,aux_nsd2,aux_nsd3,aux_sd1,aux_sd2,aux_sd3)
    }
    
    func pesoParaLaEdadM(edad: Float) -> (sd0: Float,nsd1: Float,nsd2: Float,nsd3: Float,sd1: Float,sd2: Float, sd3: Float) {
        let aux_sd0 = ((1.598*powf(10, -10))*powf(edad, 7)) + ((-3.935*powf(10, -8))*powf(edad, 6)) + ((3.96*powf(10, -6))*powf(edad, 5)) + ((-0.0002095)*powf(edad, 4)) + ((0.00624)*powf(edad, 3)) + ((-0.1044)*powf(edad, 2)) + ((1.121)*edad) + (3.207)
        let aux_nsd1 = ((1.627*powf(10, -10))*powf(edad, 7)) + ((-3.97*powf(10, -8))*powf(edad, 6)) + ((3.959*powf(10, -6))*powf(edad, 5)) + ((-0.0002072)*powf(edad, 4)) + ((0.006089)*powf(edad, 3)) + ((-0.1001)*powf(edad, 2)) + ((1.039)*edad) + (2.764)
        let aux_nsd2 = ((1.102*powf(10, -10))*powf(edad, 7)) + ((-2.799*powf(10, -8))*powf(edad, 6)) + ((2.906*powf(10, -6))*powf(edad, 5)) + ((-0.0001585)*powf(edad, 4)) + ((0.004853)*powf(edad, 3)) + ((-0.08338)*powf(edad, 2)) + ((0.9116)*edad) + (2.389)
        let aux_nsd3 = ((1.384*powf(10, -10))*powf(edad, 7)) + ((-3.371*powf(10, -8))*powf(edad, 6)) + ((3.359*powf(10, -6))*powf(edad, 5)) + ((-0.0001758)*powf(edad, 4)) + ((0.005161)*powf(edad, 3)) + ((-0.08493)*powf(edad, 2)) + ((0.8772)*edad) + (1.965)
        let aux_sd1 = ((1.62*powf(10, -10))*powf(edad, 7)) + ((-4.01*powf(10, -8))*powf(edad, 6)) + ((4.064*powf(10, -6))*powf(edad, 5)) + ((-0.0002171)*powf(edad, 4)) + ((0.006557)*powf(edad, 3)) + ((-0.1116)*powf(edad, 2)) + ((1.231)*edad) + (3.714)
        let aux_sd2 = ((1.853*powf(10, -10))*powf(edad, 7)) + ((-4.551*powf(10, -8))*powf(edad, 6)) + ((4.575*powf(10, -6))*powf(edad, 5)) + ((-0.0002426)*powf(edad, 4)) + ((0.007293)*powf(edad, 3)) + ((-0.1238)*powf(edad, 2)) + ((1.376)*edad) + (4.245)
        let aux_sd3 = ((2.049*powf(10, -10))*powf(edad, 7)) + ((-5.013*powf(10, -8))*powf(edad, 6)) + ((5.018*powf(10, -6))*powf(edad, 5)) + ((-0.0002654)*powf(edad, 4)) + ((0.007987)*powf(edad, 3)) + ((-0.1365)*powf(edad, 2)) + ((1.546)*edad) + (4.829)
        
        return (aux_sd0,aux_nsd1,aux_nsd2,aux_nsd3,aux_sd1,aux_sd2,aux_sd3)
    }
    
    func pesoParaLaLongitud0_24M(longitud: Float) -> (sd0: Float,nsd1: Float,nsd2: Float,nsd3: Float,sd1: Float,sd2: Float, sd3: Float) {
        let aux_sd0 = ((3.324*powf(10, -5))*powf(longitud, 3)) + ((-0.007228)*powf(longitud, 2)) + ((0.7346)*longitud) + (-19.35)
        let aux_nsd1 = ((2.853*powf(10, -5))*powf(longitud, 3)) + ((-0.006206)*powf(longitud, 2)) + ((0.6439)*longitud) + (-17.08)
        let aux_nsd2 = ((2.457*powf(10, -5))*powf(longitud, 3)) + ((-0.005346)*powf(longitud, 2)) + ((0.5667)*longitud) + (-15.14)
        let aux_nsd3 = ((2.122*powf(10, -5))*powf(longitud, 3)) + ((-0.004618)*powf(longitud, 2)) + ((0.5005)*longitud) + (-13.47)
        let aux_sd1 = ((3.887*powf(10, -5))*powf(longitud, 3)) + ((-0.008451)*powf(longitud, 2)) + ((0.8419)*longitud) + (-22.03)
        let aux_sd2 = ((4.563*powf(10, -5))*powf(longitud, 3)) + ((-0.009918)*powf(longitud, 2)) + ((0.9693)*longitud) + (-25.19)
        let aux_sd3 = ((5.38*powf(10, -5))*powf(longitud, 3)) + ((-0.01169)*powf(longitud, 2)) + ((1.122)*longitud) + (-28.96)
        
        return (aux_sd0,aux_nsd1,aux_nsd2,aux_nsd3,aux_sd1,aux_sd2,aux_sd3)
    }
    
    func pesoParaLaLongitud24_60M(longitud: Float) -> (sd0: Float,nsd1: Float,nsd2: Float,nsd3: Float,sd1: Float,sd2: Float, sd3: Float) {
        let aux_sd0 = ((3.774*powf(10, -5))*powf(longitud, 3)) + ((-0.007964)*powf(longitud, 2)) + ((0.7597)*longitud) + (-18.82)
        let aux_nsd1 = ((3.383*powf(10, -5))*powf(longitud, 3)) + ((-0.007257)*powf(longitud, 2)) + ((0.7055)*longitud) + (-17.87)
        let aux_nsd2 = ((2.794*powf(10, -5))*powf(longitud, 3)) + ((-0.005888)*powf(longitud, 2)) + ((0.584)*longitud) + (-14.66)
        let aux_nsd3 = ((2.415*powf(10, -5))*powf(longitud, 3)) + ((-0.005053)*powf(longitud, 2)) + ((0.5092)*longitud) + (-12.77)
        let aux_sd1 = ((4.583*powf(10, -5))*powf(longitud, 3)) + ((-0.009823)*powf(longitud, 2)) + ((0.9212)*longitud) + (-22.99)
        let aux_sd2 = ((5.314*powf(10, -5))*powf(longitud, 3)) + ((-0.01138)*powf(longitud, 2)) + ((1.052)*longitud) + (-26.13)
        let aux_sd3 = ((6.229*powf(10, -5))*powf(longitud, 3)) + ((-0.01332)*powf(longitud, 2)) + ((1.21)*longitud) + (-29.8)
        
        return (aux_sd0,aux_nsd1,aux_nsd2,aux_nsd3,aux_sd1,aux_sd2,aux_sd3)
    }
    
    func IMCParaLaEdad0_24M(edad: Float) -> (sd0: Float,nsd1: Float,nsd2: Float,nsd3: Float,sd1: Float,sd2: Float, sd3: Float) {
        let aux_sd0 = ((-4.489*powf(10, -8))*powf(edad, 7)) + ((3.513*powf(10, -6))*powf(edad, 6)) + ((-9.744*powf(10, -5))*powf(edad, 5)) + ((0.0008795)*powf(edad, 4)) + ((0.008803)*powf(edad, 3)) + ((-0.2475)*powf(edad, 2)) + ((1.745)*edad) + (12.95)
        let aux_nsd1 = ((-6.628*powf(10, -8))*powf(edad, 7)) + ((5.434*powf(10, -6))*powf(edad, 6)) + ((-0.0001664)*powf(edad, 5)) + ((0.002148)*powf(edad, 4)) + ((-0.004085)*powf(edad, 3)) + ((-0.1745)*powf(edad, 2)) + ((1.532)*edad) + (11.77)
        let aux_nsd2 = ((-6.745*powf(10, -8))*powf(edad, 7)) + ((5.655*powf(10, -6))*powf(edad, 6)) + ((-0.0001796)*powf(edad, 5)) + ((0.002517)*powf(edad, 4)) + ((-0.009519)*powf(edad, 3)) + ((-0.1313)*powf(edad, 2)) + ((1.376)*edad) + (10.64)
        let aux_nsd3 = ((-1.191*powf(10, -7))*powf(edad, 7)) + ((1*powf(10, -5))*powf(edad, 6)) + ((-0.0003249)*powf(edad, 5)) + ((0.004975)*powf(edad, 4)) + ((-0.03171)*powf(edad, 3)) + ((-0.02756)*powf(edad, 2)) + ((1.165)*edad) + (9.56)
        let aux_sd1 = ((-5.023*powf(10, -8))*powf(edad, 7)) + ((3.842*powf(10, -6))*powf(edad, 6)) + ((-0.0001025)*powf(edad, 5)) + ((0.0008062)*powf(edad, 4)) + ((0.01205)*powf(edad, 3)) + ((-0.2876)*powf(edad, 2)) + ((1.948)*edad) + (14.2)
        let aux_sd2 = ((-6.551*powf(10, -8))*powf(edad, 7)) + ((5.176*powf(10, -6))*powf(edad, 6)) + ((-0.0001485)*powf(edad, 5)) + ((0.001583)*powf(edad, 4)) + ((0.005785)*powf(edad, 3)) + ((-0.2742)*powf(edad, 2)) + ((2.039)*edad) + (15.63)
        let aux_sd3 = ((-7.795*powf(10, -8))*powf(edad, 7)) + ((6.364*powf(10, -6))*powf(edad, 6)) + ((-0.0001926)*powf(edad, 5)) + ((0.002368)*powf(edad, 4)) + ((-0.0005273)*powf(edad, 3)) + ((-0.2654)*powf(edad, 2)) + ((2.184)*edad) + (17.1)
        
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
    
    func MUACparaLaEdad3_60M(edad: Float) -> (sd0: Float,nsd1: Float,nsd2: Float,nsd3: Float,sd1: Float,sd2: Float, sd3: Float) {
        let aux_sd0 = ((-4.433*powf(10, -9))*powf(edad, 6)) + ((9.075*powf(10, -7))*powf(edad, 5)) + ((-7.23*powf(10, -5))*powf(edad, 4)) + ((0.002818)*powf(edad, 3)) + ((-0.05544)*powf(edad, 2)) + ((0.5681)*edad) + (11.81)
        let aux_nsd1 = ((-3.614*powf(10, -9))*powf(edad, 6)) + ((7.389*powf(10, -7))*powf(edad, 5)) + ((-5.877*powf(10, -5))*powf(edad, 4)) + ((0.002287)*powf(edad, 3)) + ((-0.04516)*powf(edad, 2)) + ((0.4769)*edad) + (10.98)
        let aux_nsd2 = ((-3.643*powf(10, -9))*powf(edad, 6)) + ((7.385*powf(10, -7))*powf(edad, 5)) + ((-5.811*powf(10, -5))*powf(edad, 4)) + ((0.002231)*powf(edad, 3)) + ((-0.0434)*powf(edad, 2)) + ((0.4507)*edad) + (10.1)
        let aux_nsd3 = ((-3.248*powf(10, -9))*powf(edad, 6)) + ((6.563*powf(10, -7))*powf(edad, 5)) + ((-5.152*powf(10, -5))*powf(edad, 4)) + ((0.001976)*powf(edad, 3)) + ((-0.03855)*powf(edad, 2)) + ((0.4049)*edad) + (9.363)
        let aux_sd1 = ((-4.523*powf(10, -9))*powf(edad, 6)) + ((9.301*powf(10, -7))*powf(edad, 5)) + ((-7.466*powf(10, -5))*powf(edad, 4)) + ((0.002941)*powf(edad, 3)) + ((-0.05849)*powf(edad, 2)) + ((0.6048)*edad) + (12.88)
        let aux_sd2 = ((-5.493*powf(10, -9))*powf(edad, 6)) + ((1.13*powf(10, -6))*powf(edad, 5)) + ((-9.087*powf(10, -5))*powf(edad, 4)) + ((0.003587)*powf(edad, 3)) + ((-0.07131)*powf(edad, 2)) + ((0.7234)*edad) + (13.84)
        let aux_sd3 = ((-6.098*powf(10, -9))*powf(edad, 6)) + ((1.258*powf(10, -6))*powf(edad, 5)) + ((-0.0001014)*powf(edad, 4)) + ((0.004009)*powf(edad, 3)) + ((-0.07966)*powf(edad, 2)) + ((0.8012)*edad) + (15.08)
        
        return (aux_sd0,aux_nsd1,aux_nsd2,aux_nsd3,aux_sd1,aux_sd2,aux_sd3)
    }

}
