//
//  SeleccionarMedidaViewController.swift
//  NutriKids
//
//  Created by Manuela Garcia on 2/10/18.
//  Copyright © 2018 Manuela Garcia. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class SeleccionarMedidaViewController: UIViewController {

    @IBOutlet weak var check1: UIImageView!
    @IBOutlet weak var check2: UIImageView!
    @IBOutlet weak var check3: UIImageView!
    @IBOutlet weak var check4: UIImageView!
    @IBOutlet weak var continuarBtn: UIButton!
    @IBOutlet weak var perimetroElipse: UILabel!
    
    @IBOutlet weak var marcador1Btn: UIButton!
    @IBOutlet weak var marcador2Btn: UIButton!
    @IBOutlet weak var medidaHBnt: UIButton!
    @IBOutlet weak var medidaVBtn: UIButton!
    @IBOutlet weak var marcadoresLabel: UILabel!
    @IBOutlet weak var medidaLabel: UILabel!
    
    
    var medida = 0
    var tipoMedida = 0
    var tipoMarcador = 0
    var tipoMarcador2 = 0
    var cancel = false
    var mmX: Float = 0
    var mmY: Float = 0
    var mmZ: Float = 0
    
    var d1: Float = 0
    var d2: Float = 0
    var aux: Float = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SVProgressHUD.dismiss()
        perimetroElipse.isHidden = true
        continuarBtn.isEnabled = false
        UserDefaults.standard.set(0, forKey: "MUAC")
        
        if tipoMedida == 1 {
            marcador1Btn.setTitle(" Marcador", for: .normal)
            marcador2Btn.isHidden = true
            marcadoresLabel.text = " Seleccione el marcador"

            medidaHBnt.setTitle(" Medida de estatura", for: .normal)
            medidaVBtn.isHidden = true
        }
        else if tipoMedida == 2 {
            marcador1Btn.setTitle(" Marcador 1", for: .normal)
            marcador2Btn.isHidden = false
            marcadoresLabel.text = " Seleccione los marcadores"

            medidaHBnt.setTitle(" Medida Horizontal", for: .normal)
            medidaVBtn.isHidden = false
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        cancel = UserDefaults.standard.bool(forKey: "Cancel")
        mmX = UserDefaults.standard.float(forKey: "mmEnX")
        mmY = UserDefaults.standard.float(forKey: "mmEnY")
        mmZ = UserDefaults.standard.float(forKey: "altura")
        
        print("mmX: \(mmX), mmY: \(mmY), mmZ: \(mmZ)")
        
        if tipoMedida == 1 {
            // Estatura
            if cancel == true && medida == 1 {
                check3.isHidden = true
            }
            if check3.isHidden == false && medida == 1 {
                d1 = mmX
                aux = mmY
                print("mmX: \(d1) y mmY: \(aux)")
            }
            if check1.isHidden == false && check3.isHidden == false {
                continuarBtn.isEnabled = true
                continuarBtn.backgroundColor = UIColor(red:0.00, green:0.10, blue:0.58, alpha:1.0)
                perimetroElipse.text = "mmX: \(d1) y mmY: \(aux)"
                perimetroElipse.isHidden = false
            } else {
                continuarBtn.isEnabled = false
                continuarBtn.backgroundColor = UIColor.lightGray
                perimetroElipse.isHidden = true
            }
        }
        else if tipoMedida == 2 {
            //MUAC
            if cancel == true && medida == 1 {
                check3.isHidden = true
            }
            if cancel == true && medida == 2 {
                check4.isHidden = true
            }
            if check3.isHidden == false && medida == 1 {
                d1 = mmX
                print("r1: \(d1)")
            }
            if check4.isHidden == false && medida == 2 {
                d2 = mmZ
                print("r2: \(d2)")
            }
            if check1.isHidden == false && check2.isHidden == false && check3.isHidden == false && check4.isHidden == false {
                continuarBtn.isEnabled = true
                continuarBtn.backgroundColor = UIColor(red:0.00, green:0.10, blue:0.58, alpha:1.0)
                if (d1 != 0 && d2 != 0) {
                    perElipse(mmX: d1, mmY: mmY, mmZ: d2)
                }
            } else {
                continuarBtn.isEnabled = false
                continuarBtn.backgroundColor = UIColor.lightGray
                perimetroElipse.isHidden = true
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMedida" {
            let vc = segue.destination as! ViewController
            
            vc.medida = self.medida
            vc.tipoMarcador = self.tipoMarcador
            vc.tipoMarcador2 = self.tipoMarcador2
        } else if segue.identifier == "goToResultados" {
            // nada aun
        }
    }
    
    @IBAction func marcador1(_ sender: UIButton) {
        let actionSheet = UIAlertController(title: nil,
                                            message: nil,
                                            preferredStyle: .actionSheet)
        
        
        actionSheet.addAction(UIAlertAction(title: "Moneda de 50 vieja", style: .default) { (action) in
            self.tipoMarcador = 1
            self.check1.isHidden = false
        })
        
        actionSheet.addAction(UIAlertAction(title: "Moneda de 50 nueva", style: .default) { (action) in
            self.tipoMarcador = 2
            self.check1.isHidden = false
        })
        
        actionSheet.addAction(UIAlertAction(title: "Moneda de 100 vieja", style: .default) { (action) in
            self.tipoMarcador = 3
            self.check1.isHidden = false
        })
        
        actionSheet.addAction(UIAlertAction(title: "Moneda de 100 nueva", style: .default) { (action) in
            self.tipoMarcador = 4
            self.check1.isHidden = false
        })
        
        actionSheet.addAction(UIAlertAction(title: "Moneda de 200 vieja", style: .default) { (action) in
            self.tipoMarcador = 5
            self.check1.isHidden = false
        })
        
        actionSheet.addAction(UIAlertAction(title: "Moneda de 200 nueva", style: .default) { (action) in
            self.tipoMarcador = 6
            self.check1.isHidden = false
        })
        
        actionSheet.addAction(UIAlertAction(title: "Moneda de 500 vieja", style: .default) { (action) in
            self.tipoMarcador = 7
            self.check1.isHidden = false
        })
        
        actionSheet.addAction(UIAlertAction(title: "Moneda de 500 nueva", style: .default) { (action) in
            self.tipoMarcador = 8
            self.check1.isHidden = false
        })
        
        actionSheet.addAction(UIAlertAction(title: "Moneda de 1000", style: .default) { (action) in
            self.tipoMarcador = 9
            self.check1.isHidden = false
        })
        
        actionSheet.addAction(UIAlertAction(title: "Tapa de CocaCola", style: .default) { (action) in
            self.tipoMarcador = 10
            self.check1.isHidden = false
        })
        
        actionSheet.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        present(actionSheet, animated: true, completion: nil)
    }
    
    
    @IBAction func marcador2(_ sender: UIButton) {
        let actionSheet = UIAlertController(title: nil,
                                            message: nil,
                                            preferredStyle: .actionSheet)
        
        
        actionSheet.addAction(UIAlertAction(title: "Moneda de 50 vieja", style: .default) { (action) in
            self.tipoMarcador2 = 1
            self.check2.isHidden = false
        })
        
        actionSheet.addAction(UIAlertAction(title: "Moneda de 50 nueva", style: .default) { (action) in
            self.tipoMarcador2 = 2
            self.check2.isHidden = false
        })
        
        actionSheet.addAction(UIAlertAction(title: "Moneda de 100 vieja", style: .default) { (action) in
            self.tipoMarcador2 = 3
            self.check2.isHidden = false
        })
        
        actionSheet.addAction(UIAlertAction(title: "Moneda de 100 nueva", style: .default) { (action) in
            self.tipoMarcador2 = 4
            self.check2.isHidden = false
        })
        
        actionSheet.addAction(UIAlertAction(title: "Moneda de 200 vieja", style: .default) { (action) in
            self.tipoMarcador2 = 5
            self.check2.isHidden = false
        })
        
        actionSheet.addAction(UIAlertAction(title: "Moneda de 200 nueva", style: .default) { (action) in
            self.tipoMarcador2 = 6
            self.check2.isHidden = false
        })
        
        actionSheet.addAction(UIAlertAction(title: "Moneda de 500 vieja", style: .default) { (action) in
            self.tipoMarcador2 = 7
            self.check2.isHidden = false
        })
        
        actionSheet.addAction(UIAlertAction(title: "Moneda de 500 nueva", style: .default) { (action) in
            self.tipoMarcador2 = 8
            self.check2.isHidden = false
        })
        
        actionSheet.addAction(UIAlertAction(title: "Moneda de 1000", style: .default) { (action) in
            self.tipoMarcador2 = 9
            self.check2.isHidden = false
        })
        
        actionSheet.addAction(UIAlertAction(title: "Tapa de CocaCola", style: .default) { (action) in
            self.tipoMarcador2 = 10
            self.check2.isHidden = false
        })
        
        actionSheet.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        present(actionSheet, animated: true, completion: nil)
    }
    
    
    @IBAction func medidaHorizontal(_ sender: UIButton) {
        // Si la medida es horizontal
        self.medida = 1
        self.check3.isHidden = false
        self.performSegue(withIdentifier: "showMedida", sender: self)
    }
    
    @IBAction func medidaVertical(_ sender: UIButton) {
        // Si la medida es vertical
        self.medida = 2
        self.check4.isHidden = false
        self.performSegue(withIdentifier: "showMedida", sender: self)
    }
    
    func perElipse(mmX: Float,mmY: Float,mmZ: Float) {
        
        let a = mmX/2
        let b = mmZ/2
        let aux1 = pow((a-b), 2)
        let aux2 = pow((a+b), 2)
        let aux3 = aux1/aux2
        let aux4 = ((-3)*aux3)+4
        let aux5 = (aux4.squareRoot())+10
        let aux6 = aux2*aux5
        let aux7 = 3*aux1/aux6
        let aux8 = aux7 + 1
        let aux9 = Float.pi*(a+b)
        let c = aux9*aux8
        
        perimetroElipse.isHidden = false
        perimetroElipse.text = "MUAC: \(c)"
        print("a \(a)")
        print("b \(b)")
        //        print("aux1 \(aux1)")
        //        print("aux2 \(aux2)")
        //        print("aux3 \(aux3)")
        //        print("aux4 \(aux4)")
        //        print("aux5 \(aux5)")
        //        print("aux6 \(aux6)")
        //        print("aux7 \(aux7)")
        //        print("aux8 \(aux8)")
        //        print("aux9 \(aux9)")
        print("Circunferencia \(c)")
        UserDefaults.standard.set(c, forKey: "MUAC")
    }
    
    @IBAction func salirPressed(_ sender: UIBarButtonItem) {
        do {
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
        }
        catch {
            print("Error, hubo un problema al salir.")
        }
    }
    
    
    @IBAction func continuarPressed(_ sender: UIButton) {
        //performSegue(withIdentifier: "goToResultados", sender: self)
        navigationController?.popViewController(animated: true)
    }
}
