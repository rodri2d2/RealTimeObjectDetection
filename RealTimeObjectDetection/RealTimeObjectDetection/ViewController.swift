//
//  ViewController.swift
//  RealTimeObjectDetection
//
//  Created by Rodrigo  Candido on 18/4/21.
//

import UIKit
import Vision

class ViewController: UIViewController {
    
    // MARK: - Class properties
    private let cameraController = CameraController()
    private var viewModel: ObjectDetectionViewModel

    // MARK: - Outlets
    private lazy var previewOutput: UIView = {
        let view   = UIView()
        let width  = self.view.bounds.width
        let height = self.view.bounds.height
        view.frame = CGRect(x: 0, y: 0, width: width, height: height)
        return view
    }()
    
    private lazy var boundingView: UIView = {
        let view = UIView()
        let width  = self.view.bounds.width / 2
        let height = self.view.bounds.height / 2
        view.frame = CGRect(x: 0, y: 0, width: width, height: height)
        view.center = self.view.center
        view.backgroundColor = .purple
        view.alpha = 0.8
        return view
    }()
    
    
    private lazy var objectLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .center
        return view
    }()
    

    // MARK: - Lifecycle
    init(viewModel: ObjectDetectionViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: .main)
        viewModel.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupOutlets()
        setupCameraController()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear( animated)
        self.cameraController.stopSession()
    }
    
    deinit {
        self.cameraController.stopSession()
    }
}


















// MARK: - Extension for Outlets setup
extension ViewController{
    private func setupOutlets(){
        setupPreviewOutput()
        setupBoundingView()
        setupObjectLabel()
    }
    
    private func setupPreviewOutput(){
        self.view.addSubview(self.previewOutput)
    }
    
    private func setupBoundingView(){
        self.view.addSubview(boundingView)
    }
    
    private func setupObjectLabel(){
        self.boundingView.addSubview(objectLabel)
        self.objectLabel.pin(to: self.boundingView)
        self.objectLabel.text = "Reading Image..."
    }
}



// MARK: - Dynamic UI
extension ViewController{
        
    private func redrawDetectionLayers(recognizedObjects: [VNRecognizedObjectObservation]){
        for object in recognizedObjects{
            DispatchQueue.main.async {
                let scaleHeight = self.previewOutput.frame.width / object.boundingBox.size.width * object.boundingBox.size.height
                
                let x = object.boundingBox.midX * scaleHeight
                let y = object.boundingBox.midY * scaleHeight
                let width = CGFloat(100)
                self.boundingView.frame =  CGRect(x: x, y: y, width: width, height: width)
                self.boundingView.backgroundColor = .green
                self.boundingView.alpha = 0.8
                self.objectLabel.text = object.labels.first?.identifier
            }
        }
    }
    
    private func clearAlreadyDetected(){
        DispatchQueue.main.async {
            self.boundingView.frame = CGRect()
        }
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


















// MARK: - Extension for CameraControllerDelegate
extension ViewController: CameraControllerDelegate{
    func didCapturedImage(imageBuffer: CVPixelBuffer, dimesions: CGSize) {
        self.viewModel.imageWasCaptured(imageBuffer: imageBuffer)
    }
}


















// MARK: - Extension for ObjectDetectionViewModelDelegate
extension ViewController: ObjectDetectionViewModelDelegate{
    
    func didNotRecognizedObject() {
        self.clearAlreadyDetected()
    }
    
    func didRecognizeObject(recognizedObjects: [VNRecognizedObjectObservation]) {
       self.redrawDetectionLayers(recognizedObjects: recognizedObjects)
    
    }
}
