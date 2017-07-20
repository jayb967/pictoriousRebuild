//
//  CustomCameraVC.swift
//  Pictorious
//


import UIKit
import Foundation
import AVFoundation

class CustomCameraVC: UIViewController {
    
    var captureSession = AVCaptureSession()
    let stillImageOutput = AVCapturePhotoOutput()
    var previewLayer : AVCaptureVideoPreviewLayer?
    
    // storage for found device at initialization
    var captureDevice : AVCaptureDevice?
    
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var imgOverlay: UIImageView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
    
        captureSession.sessionPreset = AVCaptureSessionPresetHigh
        
        if let devices = AVCaptureDevice.devices() as? [AVCaptureDevice] {
            
            // Loop through all the capture devices on this phone
            for device in devices {
                // Make sure this particular device supports video
                if (device.hasMediaType(AVMediaTypeVideo)) {
                    // Finally check the position and confirm we've got the back camera
                    if(device.position == AVCaptureDevicePosition.front) {
                        captureDevice = device
                        if captureDevice != nil {
                            print("Capture device found")
                            beginSession()
                        }
                    }
                }
            }
        }

    }
    
    
    func beginSession() {
        
        do {
            try captureSession.addInput(AVCaptureDeviceInput(device: captureDevice))
//            stillImageOutput.outputSettings = [AVVideoCodecKey:AVVideoCodecJPEG]
            
            if captureSession.canAddOutput(stillImageOutput) {
                captureSession.addOutput(stillImageOutput)
            }
            
        }
        catch {
            print("error: \(error.localizedDescription)")
        }
        
        guard let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession) else {
            print("no preview layer")
            return
        }
        
        self.view.layer.addSublayer(previewLayer)
        previewLayer.frame = self.view.layer.frame
        captureSession.startRunning()
        
        self.view.addSubview(imgOverlay)
        self.view.addSubview(cameraButton)
    }
    
  
        

    func saveToCamera() {
        
        if let videoConnection = stillImageOutput.connection(withMediaType: AVMediaTypeVideo) {
            
            stillImageOutput.captureStillImageAsynchronously(from: videoConnection, completionHandler: { (CMSampleBuffer, Error) in
                if let imageData = AVCapturePhotoOutput.jpegStillImageNSDataRepresentation(CMSampleBuffer) {
                    
                    if let cameraImage = UIImage(data: imageData) {
                        
                        UIImageWriteToSavedPhotosAlbum(cameraImage, nil, nil, nil)
                    }
                }
            })
        }
    }
  
    

    
    @IBAction func didPressCameraButton(_ sender: UIButton) {
        
        print("Camera button pressed")
        saveToCamera()
        
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let cameraVC = storyboard.instantiateViewController(withIdentifier: "createVC")
//        present(cameraVC, animated: true, completion: nil)
    }


}
