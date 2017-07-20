//
//  CustomCameraVC.swift
//  Pictorious
//
//  Created by Rio Balderas on 7/17/17.
//  Copyright © 2017 Jay Balderas. All rights reserved.
//

import UIKit
import Foundation
import AVFoundation

class CustomCameraVC: UIViewController {
    
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var cameraView: UIView!
    
    let captureSession = AVCaptureSession()
    let photoOutput = AVCapturePhotoOutput()
    var previewLayer : AVCaptureVideoPreviewLayer?

    override func viewDidLoad() {
        super.viewDidLoad()

        captureSession.sessionPreset = AVCaptureSessionPresetHigh
        
        
        
    }
    
    @IBAction func didPressCameraButton(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
//        let cameraVC = storyboard.instantiateViewController(withIdentifier: "createVC")
//        present(cameraVC, animated: true, completion: nil)
    }


}
