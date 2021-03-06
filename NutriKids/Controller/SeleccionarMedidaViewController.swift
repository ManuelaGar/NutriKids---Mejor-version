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
import IGRPhotoTweaks

class SeleccionarMedidaViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var check1: UIImageView!
    @IBOutlet weak var check2: UIImageView!
    @IBOutlet weak var check3: UIImageView!
    @IBOutlet weak var check4: UIImageView!
    @IBOutlet weak var check5: UIImageView!
    
    @IBOutlet weak var continuarBtn: UIButton!
    @IBOutlet weak var perimetroElipse: UILabel!
    
    
    @IBOutlet weak var marcador1Btn: UIButton!
    @IBOutlet weak var marcador2Btn: UIButton!
    @IBOutlet weak var medidaHBnt: UIButton!
    @IBOutlet weak var medidaVBtn: UIButton!
    @IBOutlet weak var marcadoresLabel: UILabel!
    @IBOutlet weak var notaLabel: UILabel!
    @IBOutlet weak var medidaLabel: UILabel!
    
    
    var medida = 0
    var tipoMedida = 0
    var tipoMarcador = 0
    var tipoMarcador2 = 0
    var notShow = 0
    var cancel = false
    var mmX: Float = 0
    var mmY: Float = 0
    var mmZ: Float = 0
    
    var ref: DatabaseReference!
    let userID = Auth.auth().currentUser?.uid
    
    var image: UIImage!
    var imageView: UIImage!
    let pickerView = UIImagePickerController.init()
    
    var d1: Float = 0
    var d2: Float = 0
    var aux: Float = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SVProgressHUD.dismiss()
        pickerView.delegate = self
        pickerView.allowsEditing = false
        perimetroElipse.isHidden = true
        continuarBtn.isEnabled = false
        UserDefaults.standard.set(0, forKey: "MUAC")
        UserDefaults.standard.set(0, forKey: "PerCef")
        
        if tipoMedida == 1 {
            marcador1Btn.setTitle(" Marcador", for: .normal)
            marcador2Btn.isHidden = true
            marcadoresLabel.text = "1. Seleccione el marcador"

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
            if notShow == 0 {
                createAlert(title: "Medir estatura", message: "Para medir la estatura del usuario teniendo una foto necesita un marcador (objeto de medidas conocidas) como se ve en la imagen, deberá: \n1. Seleccionar el marcador a usar \n2. Seleccionar una foto que contenga al usuario y el marcador seleccionado \n3. Recortar el marcador en la foto \n4. Recortar al usuario en la foto", imageName: "Kid")
            }
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
        } else if (tipoMedida == 2 || tipoMedida == 3) {
            //MUAC o Perimetro cefálico
            if tipoMedida == 2 {
                if notShow == 0 {
                    createAlert(title: "Perímetro Brazo", message: "Para medir el perímetro del brazo teniendo una foto necesitará dos marcadores (objeto de medidas conocidas) como se ve en la imagen, deberá: \n1. Seleccionar los marcadores a usar \n2. Seleccionar una foto que contenga el brazo no dominante del usuario apoyado sobre una superficie plana con el marcador 1 sobre dicha superficie y el marcador 2 sobre el brazo \n3. Medida horizontal: \n3.1. Recortar el marcador 1 sobre la superficie \n3.2. Recortar el diámetro aproximadamente en la mitad del brazo  \n4. Medida vertical: \n4.1. Recortar el marcador 1 sobre la superficie \n4.2. Recortar el marcador 2 sobre el brazo", imageName: "brazo2")
                }
            } else {
                if notShow == 0 {
                   createAlert(title: "Perímetro Cabeza", message: "Para medir el perímetro de la cabeza teniendo una foto necesitará dos marcadores (objeto de medidas conocidas) como se ve en la imagen, deberá: \n1. Seleccionar los marcadores a usar \n2. Seleccionar una foto que contenga la cabeza del usuario apoyada sobre una superficie plana con el marcador 1 sobre dicha superficie y el marcador 2 sobre la cabeza \n3. Medida horizontal: \n3.1. Recortar el marcador 1 sobre la superficie \n3.2. Recortar el diámetro de la cabeza \n4. Medida vertical: \n4.1. Recortar el marcador 1 sobre la superficie \n4.2. Recortar el marcador 2 sobre la cabeza", imageName: "cabeza3")
                }
            }
            
            if cancel == true && medida == 1 {
                check3.isHidden = true
            }
            if cancel == true && medida == 2 {
                check4.isHidden = true
            }
            if check3.isHidden == false && medida == 1 {
                d1 = mmY
                notaLabel.isHidden = false
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let userPickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.image = userPickedImage
        }
        pickerView.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMedida" {
            let vc = segue.destination as! ViewController
            
            vc.medida = self.medida
            vc.tipoMedida = self.tipoMedida
            vc.tipoMarcador = self.tipoMarcador
            vc.tipoMarcador2 = self.tipoMarcador2
            vc.image = self.image

        }
    }
    
    func createAlert(title: String, message: String, imageName: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let image = UIImage(named: imageName)
        alert.addImage(image: image!)
        alert.addAction(UIAlertAction(title: "Entiendo", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "No mostrar otra vez", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            self.notShow = 1
        }))
        self.present(alert, animated: true, completion: nil)
    }
    func createAlert2(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Entiendo", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
//    func guardarImagen() {
//        let storageRef = Storage.storage().reference()
//        let data = Data()
//        let stgRef = storageRef.child("images.jpg")
//        _ = stgRef.putData(data, metadata: nil) { (metadata, error) in
//            guard metadata != nil else {
//                print(error!)
//                return
//            }
//            
//            storageRef.downloadURL { (url, error) in
//                guard url != nil else {
//                    print(error!)
//                    return
//                }
//                Database.database().reference().child("Usuarios").child(self.userID!).updateChildValues(
//                    ["Imagen": url ?? ""])
//                print("url: \(String(describing: url))")
//            }
//        }
//    }
    
    @IBAction func marcador1(_ sender: UIButton) {
        let actionSheet = UIAlertController(title: nil,
                                            message: nil,
                                            preferredStyle: .actionSheet)
        if tipoMedida == 1 {
            actionSheet.addAction(UIAlertAction(title: "Botella CocaCola 1.5 Litros", style: .default) { (action) in
                self.tipoMarcador = 11
                self.check1.isHidden = false
            })
        } else if tipoMedida == 2 || tipoMedida == 3 {
//            actionSheet.addAction(UIAlertAction(title: "Moneda de 50 vieja", style: .default) { (action) in
//                self.tipoMarcador = 1
//                self.check1.isHidden = false
//            })
//
//            actionSheet.addAction(UIAlertAction(title: "Moneda de 50 nueva", style: .default) { (action) in
//                self.tipoMarcador = 2
//                self.check1.isHidden = false
//            })
            
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
            
//            actionSheet.addAction(UIAlertAction(title: "Tapa de CocaCola", style: .default) { (action) in
//                self.tipoMarcador = 10
//                self.check1.isHidden = false
//            })
        }
        actionSheet.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        present(actionSheet, animated: true, completion: nil)
    }
    
    
    @IBAction func marcador2(_ sender: UIButton) {
        let actionSheet = UIAlertController(title: nil,
                                            message: nil,
                                            preferredStyle: .actionSheet)
        if tipoMedida == 1 {
            actionSheet.addAction(UIAlertAction(title: "Botella CocaCola 1.5 Litros", style: .default) { (action) in
                self.tipoMarcador = 11
                self.check1.isHidden = false
            })
        }
        else if tipoMedida == 2 || tipoMedida == 3 {
            //        actionSheet.addAction(UIAlertAction(title: "Moneda de 50 vieja", style: .default) { (action) in
            //            self.tipoMarcador2 = 1
            //            self.check2.isHidden = false
            //        })
            //
            //        actionSheet.addAction(UIAlertAction(title: "Moneda de 50 nueva", style: .default) { (action) in
            //            self.tipoMarcador2 = 2
            //            self.check2.isHidden = false
            //        })
            
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
            
//            actionSheet.addAction(UIAlertAction(title: "Tapa de CocaCola", style: .default) { (action) in
//                self.tipoMarcador2 = 10
//                self.check2.isHidden = false
//            })
        }
        actionSheet.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        present(actionSheet, animated: true, completion: nil)
    }
    
    
    @IBAction func fotoBtnPressed(_ sender: UIButton) {
        let actionSheet = UIAlertController(title: nil,
                                            message: nil,
                                            preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cámara de fotos", style: .default) { (action) in
            // Abrir camara
            self.pickerView.sourceType = UIImagePickerController.SourceType.camera
            self.present(self.pickerView, animated: true, completion: nil)
            self.check5.isHidden = false
        })
        
        actionSheet.addAction(UIAlertAction(title: "Librería de imágenes", style: .default) { (action) in
            // Abrir librería
            self.pickerView.sourceType = UIImagePickerController.SourceType.photoLibrary
            self.present(self.pickerView, animated: true, completion: nil)
            self.check5.isHidden = false
        })
        
        actionSheet.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        present(actionSheet, animated: true, completion: nil)
    }
    
    @IBAction func medidaHorizontal(_ sender: UIButton) {
        // Si la medida es horizontal
        if image != nil {
            self.medida = 1
            self.performSegue(withIdentifier: "showMedida", sender: self)
            self.check3.isHidden = false
        } else {
            createAlert2(title: "Error", message: "Debe seleccionar una imagen antes de acceder a esta función")
        }
        
    }
    
    @IBAction func medidaVertical(_ sender: UIButton) {
        // Si la medida es vertical
        if image != nil {
            self.medida = 2
            self.performSegue(withIdentifier: "showMedida", sender: self)
            notShow = 1
            self.check4.isHidden = false
        } else {
            createAlert2(title: "Error", message: "Debe seleccionar una imagen antes de acceder a esta función")
        }
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
        
        print("a \(a)")
        print("b \(b)")
        print("Circunferencia \(c)")
        
        if tipoMedida == 2 {
            perimetroElipse.text = "MUAC: \(c)"
            UserDefaults.standard.set(c, forKey: "MUAC")
        } else if tipoMedida == 3 {
            perimetroElipse.text = "P. Cefálico: \(c)"
            UserDefaults.standard.set(c, forKey: "PerCef")
        }
        
        perimetroElipse.isHidden = false
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
    
    @IBAction func ayudaPressed(_ sender: UIBarButtonItem) {
        notShow = 0
        if tipoMedida == 1 {
            // Estatura
            createAlert(title: "Medir estatura", message: "Para medir la estatura del usuario teniendo una foto necesita un marcador (objeto de medidas conocidas) como se ve en la imagen, deberá: \n1. Seleccionar el marcador a usar \n2. Seleccionar una foto que contenga al usuario y el marcador seleccionado \n3. Recortar el marcador en la foto \n4. Recortar al usuario en la foto", imageName: "Kid")
        } else if tipoMedida == 2 {
            createAlert(title: "Perímetro Brazo", message: "Para medir el perímetro del brazo teniendo una foto necesitará dos marcadores (objeto de medidas conocidas) como se ve en la imagen, deberá: \n1. Seleccionar los marcadores a usar \n2. Seleccionar una foto que contenga el brazo no dominante del usuario apoyado sobre una superficie plana con el marcador 1 sobre dicha superficie y el marcador 2 sobre el brazo \n3. Medida horizontal: \n3.1. Recortar el marcador 1 sobre la superficie \n3.2. Recortar el diámetro aproximadamente en la mitad del brazo  \n4. Medida vertical: \n4.1. Recortar el marcador 1 sobre la superficie \n4.2. Recortar el marcador 2 sobre el brazo", imageName: "brazo2")
        } else if tipoMedida == 3 {
            createAlert(title: "Perímetro Cabeza", message: "Para medir el perímetro de la cabeza teniendo una foto necesitará dos marcadores (objeto de medidas conocidas) como se ve en la imagen, deberá: \n1. Seleccionar los marcadores a usar \n2. Seleccionar una foto que contenga la cabeza del usuario apoyada sobre una superficie plana con el marcador 1 sobre dicha superficie y el marcador 2 sobre la cabeza \n3. Medida horizontal: \n3.1. Recortar el marcador 1 sobre la superficie \n3.2. Recortar el diámetro de la cabeza \n4. Medida vertical: \n4.1. Recortar el marcador 1 sobre la superficie \n4.2. Recortar el marcador 2 sobre la cabeza", imageName: "cabeza3")
        }
    }
    
    @IBAction func continuarPressed(_ sender: UIButton) {
        //guardarImagen()
        navigationController?.popViewController(animated: true)
    }
}
