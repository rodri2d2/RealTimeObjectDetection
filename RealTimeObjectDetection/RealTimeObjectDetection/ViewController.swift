//
//  ViewController.swift
//  RealTimeObjectDetection
//
//  Created by Rodrigo  Candido on 18/4/21.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - Class properties
    let cameraController = CameraController()

    // MARK: - Outlets
    private lazy var previewOutput: UIView = {
        let view   = UIView()
        let width  = self.view.bounds.width
        let height = self.view.bounds.height
        view.frame = CGRect(x: 0, y: 0, width: width, height: height)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupOutlets()
        setupCameraController()
    }
}


















// MARK: - Extension for Outlets setup
extension ViewController{
    private func setupOutlets(){
        
        setupPreviewOutput()
        
    }
    
    private func setupPreviewOutput(){
        self.view.addSubview(self.previewOutput)
    }
}


















// MARK: - Extension for Camera Controller setup
extension ViewController{
    
    private func setupCameraController(){
       
        self.cameraController.grantCameraAuth { [weak self] (error) in
            guard let self = self else { return }
            if let _ = error{
                let alert = UIAlertController(title: "Ooops...", message: "This app needs to user your camera", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            }
        }
        
        //Start runnign session if camera access is granted
        self.cameraController.configureCaptureSession()
        
        //
        self.cameraController.delegate = self
        
        //
        self.cameraController.setupLivePreview(in: self.previewOutput)
        
    }
}



extension ViewController: CameraControllerDelegate{
    func didCapturedImage(imageBuffer: CVPixelBuffer, dimesions: CGSize) {
     print("Frame")
    }
}
