//
//  CropViewController.swift
//  NutriKids
//
//  Created by Manuela Garcia on 2/10/18.
//  Copyright © 2018 Manuela Garcia. All rights reserved.
//

import IGRPhotoTweaks
import UIKit
import HorizontalDial


extension IGRPhotoTweakViewController {
    // MARK: - Funciones para calcular los mm por pixel y mm totales
    public func pixels(marker: Float) -> (mmxPixelX: Float, mmxPixelY: Float, pX: Float, pY: Float) {
        var transform = CGAffineTransform.identity
        // translate
        let translation: CGPoint = self.photoView.photoTranslation
        transform = transform.translatedBy(x: translation.x, y: translation.y)
        // scale
        
        let t: CGAffineTransform = self.photoView.photoContentView.transform
        let xScale: CGFloat = sqrt(t.a * t.a + t.c * t.c)
        let yScale: CGFloat = sqrt(t.b * t.b + t.d * t.d)
        transform = transform.scaledBy(x: xScale, y: yScale)
        
        print(xScale)
        print(yScale)
        
        let pixelsXInCroppedImage = Float(image.size.width/xScale)
        let pixelsYInCroppedImage = Float(image.size.height/yScale)
        
        let mmPorPixelX = Float(marker/pixelsXInCroppedImage)
        let mmPorPixelY = Float(marker/pixelsYInCroppedImage)
        
        print("Pixels x: \(pixelsXInCroppedImage), mm por pixel: \(mmPorPixelX)")
        print("Pixels y: \(pixelsYInCroppedImage), mm por pixel: \(mmPorPixelY)")
        
        return (mmPorPixelX, mmPorPixelY, pixelsXInCroppedImage, pixelsYInCroppedImage)
    }
    
    public func mmEnImagenCortada(mmxPixelX: Float, mmxPixelY: Float) -> (mmTotalesX: Float, mmTotalesX: Float, PX: Float, PY: Float) {
        var transform = CGAffineTransform.identity
        // translate
        let translation: CGPoint = self.photoView.photoTranslation
        transform = transform.translatedBy(x: translation.x, y: translation.y)
        let t: CGAffineTransform = self.photoView.photoContentView.transform
        let xScale: CGFloat = sqrt(t.a * t.a + t.c * t.c)
        let yScale: CGFloat = sqrt(t.b * t.b + t.d * t.d)
        
        let pixelsInCroppedImageX = Float(image.size.width/xScale)
        let pixelsInCroppedImageY = Float(image.size.height/yScale)
        
        var mmTotalesX: Float = 0
        var mmTotalesY: Float = 0
        
        let aspect = UserDefaults.standard.float(forKey: "aspect")
        
        if aspect < 1 {
            mmTotalesX = pixelsInCroppedImageX * mmxPixelX
            mmTotalesY = mmTotalesX*aspect
        } else if aspect == 1 {
            mmTotalesX = pixelsInCroppedImageX * mmxPixelX
            mmTotalesY = mmTotalesX
            //pixelsInCroppedImageY * mmxPixelX
        } else {
            mmTotalesY = pixelsInCroppedImageY * mmxPixelX
            mmTotalesX = mmTotalesY/aspect
        }
        
        print("xScale \(xScale)")
        print("yScale \(yScale)")
        print("height \(image.size.height)")
        print("width \(image.size.width)")
        print(pixelsInCroppedImageX)
        print(pixelsInCroppedImageY)
        
        return (mmTotalesX, mmTotalesY, pixelsInCroppedImageX, pixelsInCroppedImageY)
    }
    
    public func Calibracion(mmDiametro: Float, pixelesDiametro: Float) -> (Float) {
        let h: Float = 153.8
        let distanciaFocal = (pixelesDiametro * h)/mmDiametro
        print("pixeles DF \(pixelesDiametro) y mm DF \(mmDiametro)")
        return (distanciaFocal)
    }
    
}

class CropViewController: IGRPhotoTweakViewController {
    
    @IBOutlet weak var angleSlider: UISlider!
    @IBOutlet weak var angleLabel: UILabel!
    
    @IBOutlet weak fileprivate var horizontalDial: HorizontalDial? {
        didSet {
            self.horizontalDial?.migneticOption = .none
        }
    }
    
    var tap1 = 0
    var medida = 0
    var tipoMarcador = 0
    var tipoMarcador2 = 0
    var distanciaFocal: Float = 0
    var distanciaFocal2: Float = 0
    var medidaText = ""
    var mmPorPixelX: Float = 0
    var mmPorPixelY: Float = 0
    var mmX: Float = 0
    var mmY: Float = 0
    var m: Float = 0
    var DF: Float = 0
    
    var marcador: Float = 0
    var marcador2: Float = 0
    var h1: Float = 0
    var h2: Float = 0
    
    // MARK: - Life Cicle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setCropAspectRect(aspect: "1:1")
        self.setupSlider()
        UserDefaults.standard.set(0, forKey:"mmEnX")
        UserDefaults.standard.set(0, forKey:"mmEnY")
        UserDefaults.standard.set(0, forKey: "altura")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //FIXME: Themes Preview
    override open func setupThemes() {
        IGRCropLine.appearance().backgroundColor = UIColor.white
        IGRPhotoContentView.appearance().backgroundColor = UIColor.white
    }
    
    fileprivate func setupSlider() {
        self.angleSlider?.minimumValue = -Float(IGRRadianAngle.toRadians(90))
        self.angleSlider?.maximumValue = Float(IGRRadianAngle.toRadians(90))
        self.angleSlider?.value = 0.0
        
        setupAngleLabelValue(radians: CGFloat((self.angleSlider?.value)!))
    }
    
    fileprivate func setupAngleLabelValue(radians: CGFloat) {
        let intDegrees: Int = Int(IGRRadianAngle.toDegrees(radians))
        self.angleLabel?.text = "\(intDegrees)°"
    }
    
    func MarcadorElegido (tipoMar: Int) -> (m: Float, DF: Float) {
        switch tipoMar{
        case 1:
            // 50 Vieja
            m = 21.75
            DF = 3051.8789
        case 2:
            // 50 Nueva
            m = 17
            DF = 3132.155533
        case 3:
            // 100 Vieja
            m = 23.05
            DF = 3050.504567
        case 4:
            // 100 Nueva
            m = 20.35
            DF = 3093.422867
        case 5:
            // 200 Vieja
            m = 24.5
            DF = 3073.610733
        case 6:
            // 200 Nueva
            m = 22.5
            DF = 3149.113967
        case 7:
            // 500 Vieja
            m = 23.75
            DF = 3011.894533
        case 8:
            // 500 Nueva
            m = 23.75
            DF = 3115.3405
        case 9:
            // 1000
            m = 26.75
            DF = 2958.2775
        case 10:
            // Tapa CocaCola
            m = 30
            DF = 3163.39985
        case 11:
            m = 0
            DF = 0
        default:
            // Moneda de 1000
            m = 26.75
            DF = 2958.2775
        }
        print("macador \(m)")
        return (m,DF)
    }
    
    // MARK: - Rotation
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        
        coordinator.animate(alongsideTransition: { (context) in
            self.view.layoutIfNeeded()
        }) { (context) in
            //
        }
    }
    
    // MARK: - Actions
    
    @IBAction func onChandeAngleSliderValue(_ sender: UISlider) {
        let radians: CGFloat = CGFloat(sender.value)
        setupAngleLabelValue(radians: radians)
        self.changedAngle(value: radians)
    }
    
    @IBAction func onEndTouchAngleControl(_ sender: UISlider) {
        self.stopChangeAngle()
    }
    
    @IBAction func cancelBtn(_ sender: UIBarButtonItem) {
        self.dismissAction()
    }
    
    @IBAction func resetBtn(_ sender: UIBarButtonItem) {
        self.angleSlider?.value = 0.0
        self.horizontalDial?.value = 0.0
        setupAngleLabelValue(radians: 0.0)
        self.resetView()
    }
    
    @IBAction func cropBtn(_ sender: UIBarButtonItem) {
        cropAction()
        let marc = MarcadorElegido(tipoMar: tipoMarcador)
        marcador = marc.m
        distanciaFocal = marc.DF
        
        let marc2 = MarcadorElegido(tipoMar: tipoMarcador2)
        marcador2 = marc2.m
        distanciaFocal2 = marc2.DF
        
        print("marcador1: \(marcador) y DF \(distanciaFocal)")
        print("marcador2: \(marcador2) y DF2 \(distanciaFocal2)")
        
        if self.medida == 1 {
            // Medida Horizontal
            print("Medida Horizontal")
            if self.tap1 == 0 {
                let pixelsEnImagenCortada = pixels(marker: marcador)
                self.mmPorPixelX = pixelsEnImagenCortada.0
                self.mmPorPixelY = pixelsEnImagenCortada.1
                
                UserDefaults.standard.set(self.mmPorPixelX, forKey: "mmPPX")
                UserDefaults.standard.set(self.mmPorPixelY, forKey: "mmPPY")
            } else {
                let mmPPX = UserDefaults.standard.float(forKey: "mmPPX")
                let mmPPY = UserDefaults.standard.float(forKey: "mmPPY")
                
                let mmEnImagen = mmEnImagenCortada(mmxPixelX: mmPPX, mmxPixelY: mmPPY)
                self.mmX = mmEnImagen.0
                self.mmY = mmEnImagen.1
                
                print("Los mm x: \(mmX), y son: \(mmY)")
                
                UserDefaults.standard.set(mmX, forKey:"mmEnX")
                UserDefaults.standard.set(mmY, forKey:"mmEnY")
            }
        }
        if self.medida == 2 {
            // Medida Vertical
            print("Medida Vertical")
            if self.tap1 == 0 {
                let pixelsEnImagenCortada = pixels(marker: marcador)
                self.mmPorPixelX = pixelsEnImagenCortada.0
                self.mmPorPixelY = pixelsEnImagenCortada.1
                let pX = pixelsEnImagenCortada.2
                //let distanciaFocal = Calibracion(mmDiametro: marcador, pixelesDiametro: pX)
                
                self.h1 = (marcador * distanciaFocal)/pX
                
                UserDefaults.standard.set(self.mmPorPixelX, forKey: "mmPPX")
                UserDefaults.standard.set(self.mmPorPixelY, forKey: "mmPPY")
                //UserDefaults.standard.set(distanciaFocal, forKey: "DF")
                UserDefaults.standard.set(self.h1, forKey:"h1")
                
                print("La distancia focal es \(distanciaFocal)")
                print("h1 es \(h1)")
            } else {
                let mmPPX = UserDefaults.standard.float(forKey: "mmPPX")
                let mmPPY = UserDefaults.standard.float(forKey: "mmPPY")
                
                let mmEnImagen = mmEnImagenCortada(mmxPixelX: mmPPX, mmxPixelY: mmPPY)
                self.mmX = mmEnImagen.0
                self.mmY = mmEnImagen.1
                let PX = mmEnImagen.2
                
                //let distanciaFocal = UserDefaults.standard.float(forKey: "DF")
                let h1 = UserDefaults.standard.float(forKey: "h1")
                
                self.h2 = (marcador2 * distanciaFocal2)/PX
                let altura = abs(h1 - self.h2)
                
                UserDefaults.standard.set(altura, forKey: "altura")
                print("h2 es \(h2) y la h1-h2 es \(altura)")
            }
        }
    }
    
    @IBAction func aspectBtn(_ sender: UIBarButtonItem) {
        let actionSheet = UIAlertController(title: nil,
                                            message: nil,
                                            preferredStyle: .actionSheet)
        
        
        actionSheet.addAction(UIAlertAction(title: "Original", style: .default) { (action) in
            self.resetAspectRect()
        })
        
        actionSheet.addAction(UIAlertAction(title: "Cuadrado", style: .default) { (action) in
            self.setCropAspectRect(aspect: "1:1")
        })
        
        actionSheet.addAction(UIAlertAction(title: "2:3", style: .default) { (action) in
            self.setCropAspectRect(aspect: "2:3")
        })
        
        actionSheet.addAction(UIAlertAction(title: "3:5", style: .default) { (action) in
            self.setCropAspectRect(aspect: "3:5")
        })
        
        actionSheet.addAction(UIAlertAction(title: "3:4", style: .default) { (action) in
            self.setCropAspectRect(aspect: "3:4")
        })
        
        actionSheet.addAction(UIAlertAction(title: "5:7", style: .default) { (action) in
            self.setCropAspectRect(aspect: "5:7")
        })
        
        actionSheet.addAction(UIAlertAction(title: "9:16", style: .default) { (action) in
            self.setCropAspectRect(aspect: "9:16")
        })
        
        actionSheet.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        
        present(actionSheet, animated: true, completion: nil)
    }
    
    override open func customCanvasHeaderHeigth() -> CGFloat {
        var heigth: CGFloat = 0.0
        
        if UIDevice.current.orientation.isLandscape {
            heigth = 40.0
        } else {
            heigth = 100.0
        }
        
        return heigth
    }
}

extension CropViewController: HorizontalDialDelegate {
    func horizontalDialDidValueChanged(_ horizontalDial: HorizontalDial) {
        let degrees = horizontalDial.value
        let radians = IGRRadianAngle.toRadians(CGFloat(degrees))
        
        self.setupAngleLabelValue(radians: radians)
        self.changedAngle(value: radians)
    }
    
    func horizontalDialDidEndScroll(_ horizontalDial: HorizontalDial) {
        self.stopChangeAngle()
    }
}
