//
//  CustomCameraVC.swift
//  Pictorious
//


import UIKit
import Foundation
import AVFoundation

class CustomCameraVC: UIViewController, AVCapturePhotoCaptureDelegate {
    
    var session: AVCaptureSession?
    var previewLayer : AVCaptureVideoPreviewLayer?
    var cameraOutput = AVCapturePhotoOutput()
    var cameraPosition = "back"
    
    // storage for found device at initialization
    var captureDevice : AVCaptureDevice?
    
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var imgOverlay: UIImageView!
    @IBOutlet weak var cameraView: UIView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Setup your camera here...

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        previewLayer!.frame = cameraView.bounds
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        loadCamera()
    }
    
    func loadCamera() {
        session?.stopRunning()
        previewLayer?.removeFromSuperlayer()
        
        session = AVCaptureSession()
        session!.sessionPreset = AVCaptureSessionPresetHigh
        
        var backCamera = AVCaptureDevice.defaultDevice(withDeviceType: .builtInWideAngleCamera, mediaType: AVMediaTypeVideo, position: .front)
        
        if cameraPosition == "back"
        {
            backCamera = AVCaptureDevice.defaultDevice(withDeviceType: .builtInWideAngleCamera, mediaType: AVMediaTypeVideo, position: .back)
        }
        
        var error: NSError?
        var input: AVCaptureDeviceInput!
        do {
            input = try AVCaptureDeviceInput(device: backCamera)
        } catch let error1 as NSError {
            error = error1
            input = nil
            print(error!.localizedDescription)
        }
        
        if error == nil && session!.canAddInput(input) {
            session!.addInput(input)
            
            cameraOutput = AVCapturePhotoOutput()
            
            if session!.canAddOutput(cameraOutput) {
                session!.addOutput(cameraOutput)
                previewLayer = AVCaptureVideoPreviewLayer(session: session)
                previewLayer?.frame = cameraView.bounds
                previewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
                previewLayer?.connection.videoOrientation = AVCaptureVideoOrientation.portrait
                
                cameraView.layer.addSublayer(previewLayer!)
                session!.startRunning()
                
            }
            
        }
            
    }
    
    
    func beginSession() {
        
        guard let previewLayer = AVCaptureVideoPreviewLayer(session: session) else {
            print("no preview layer")
            return
        }

        self.view.layer.addSublayer(previewLayer)
        previewLayer.frame = self.view.layer.frame
        session!.startRunning()

        self.view.addSubview(imgOverlay)
        self.view.addSubview(cameraButton)
    }
    
    func saveToCamera() {
        
        //configure the output
        let settings = AVCapturePhotoSettings()
        let previewPixelType = settings.availablePreviewPhotoPixelFormatTypes.first!
        let previewFormat = [kCVPixelBufferPixelFormatTypeKey as String: previewPixelType,
                             kCVPixelBufferWidthKey as String: 160,
                             kCVPixelBufferHeightKey as String: 160,
                             ]
        settings.previewPhotoFormat = previewFormat
        self.cameraOutput.capturePhoto(with: settings, delegate: self)
    }
  

    @IBAction func didPressCameraButton(_ sender: UIButton) {
        print("Camera button pressed")
        saveToCamera()
        
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let cameraVC = storyboard.instantiateViewController(withIdentifier: "createVC")
//        present(cameraVC, animated: true, completion: nil)
    }

}
