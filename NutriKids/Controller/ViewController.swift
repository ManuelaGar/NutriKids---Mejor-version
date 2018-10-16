//
//  ViewController.swift
//  NutriKids
//
//  Created by Manuela Garcia on 2/10/18.
//  Copyright © 2018 Manuela Garcia. All rights reserved.
//

import UIKit
import IGRPhotoTweaks


class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageMeasure: UIImageView!
    
    @IBOutlet weak var editItem: UIBarButtonItem!
    @IBOutlet weak var doneItem: UIBarButtonItem!
    @IBOutlet weak var cancelItem: UIBarButtonItem!
    
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var medidaLabel: UILabel!
    var image: UIImage!
    
    var imageWasTapped = false
    var medida = 0
    var tipoMedida = 0
    var tipoMarcador = 0
    var tipoMarcador2 = 0
    var tap = 0
    var mmX: Float = 0
    var mmY: Float = 0
    var altura: Float = 0
    var aux = 0
    var aux2 = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("tipomarcador3 \(tipoMarcador)")
        print("tipomarcador4 \(tipoMarcador2)")
        if self.medida == 1 {
            navigationItem.title = "Medida Horizontal"
        }
        if self.medida == 2 {
            navigationItem.title = "Medida Vertical"
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UserDefaults.standard.set(false, forKey: "Cancel")
        mmEnImagenCortada()
        if (self.aux == 0) {
            edit(image: image)
            if tipoMedida == 1 {
                createAlert(title: "Paso 1", message: "Recorte el marcador")
            } else if tipoMedida == 2 || tipoMedida == 3 {
                createAlert(title: "Paso 1", message: "Recorte el marcador 1 que está sobre la superficie")
            }
            
            self.medidaLabel?.text = ""
            aux = 1
            
        } else if ((aux == 1) && (aux2 == 0)) {
            if medida == 1 {
                if tipoMedida == 1 {
                    createAlert(title: "Paso 2", message: "Recorte al usuario para medir estatura")
                } else if tipoMedida == 2 {
                    createAlert(title: "Paso 2", message: "Recorte el diámetro del brazo")
                } else if tipoMedida == 3 {
                    createAlert(title: "Paso 2", message: "Recorte el diámetro de la cabeza")
                }
            } else if medida == 2 {
                if tipoMedida == 2 {
                    createAlert(title: "Paso 2", message: "Recorte el marcador 2 que está sobre el brazo del usuario")
                } else if tipoMedida == 3 {
                    createAlert(title: "Paso 2", message: "Recorte el marcador 2 que está sobre la cabeza del usuario")
                }
            }
            aux2 = 1
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc1 = segue.destination as! CropViewController
        vc1.tap1 = self.tap
        vc1.medida = self.medida
        vc1.tipoMedida = self.tipoMedida
        vc1.tipoMarcador = self.tipoMarcador
        vc1.tipoMarcador2 = self.tipoMarcador2
        
        if segue.identifier == "showCrop" {
            let exampleCropViewController = segue.destination as! CropViewController
            exampleCropViewController.image = sender as? UIImage
            exampleCropViewController.delegate = self
        }
    }
    
    // MARK: - Funcs
    
    func edit(image: UIImage) {
        self.performSegue(withIdentifier: "showCrop", sender: image)
    }
    
    func createAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Listo", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func editPressed(_ sender: UIBarButtonItem) {
        self.edit(image: self.image)
    }
    
    @IBAction func cancelPressed(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
        UserDefaults.standard.set(true, forKey: "Cancel")
    }
    
    @IBAction func donePressed(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
        self.doneItem.isEnabled = false
    }
    
    @IBAction func imageClicked(_ sender: Any){
        print("image tapped \(imageWasTapped)")
        imageWasTapped = true
        self.tap = 1
        infoLabel.isHidden = true
        edit(image: image)
        self.doneItem.isEnabled = true
        self.cancelItem.isEnabled = false
    }
    
    @objc func mmEnImagenCortada(){
        self.mmX = UserDefaults.standard.float(forKey: "mmEnX")
        self.mmY = UserDefaults.standard.float(forKey: "mmEnY")
        self.altura = UserDefaults.standard.float(forKey: "altura")
        
        if (self.medida == 1) {
            self.medidaLabel?.text = "mmX: \(self.mmX), mmY: \(self.mmY)"
        }
        if (self.medida == 2) {
            self.medidaLabel?.text = "h: \(self.altura)"
        }
    }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Local variable inserted by Swift 4.2 migrator.
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        
        let image = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as! UIImage
        
        self.image = image
        let imageSize1 = image.size

        print("Original Image")
        print(imageSize1)

        picker.dismiss(animated: true) {
            self.edit(image: image)
        }
    }
}

extension ViewController: IGRPhotoTweakViewControllerDelegate {
    func photoTweaksController(_ controller: IGRPhotoTweakViewController, didFinishWithCroppedImage croppedImage: UIImage) {
        if self.tap == 1 {
            self.tap = 0
            imageWasTapped = false
            self.imageMeasure?.image = croppedImage
            let croppedWidth: CGFloat = croppedImage.size.width
            let croppedHeight: CGFloat = croppedImage.size.height
            let aspect = croppedHeight/croppedWidth
            UserDefaults.standard.set(aspect, forKey: "aspect")
            print("Aspect \(aspect) y \(UserDefaults.standard.float(forKey: "aspect"))")
        } else {
            self.imageView?.image = croppedImage
        }
        _ = controller.navigationController?.popViewController(animated: true)
    }
    
    func photoTweaksControllerDidCancel(_ controller: IGRPhotoTweakViewController) {
        _ = controller.navigationController?.popViewController(animated: true)
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
    return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
    return input.rawValue
}
