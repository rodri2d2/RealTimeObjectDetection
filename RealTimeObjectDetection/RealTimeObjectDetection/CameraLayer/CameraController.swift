//
//  CameraController.swift
//  RealTimeObjectDetection
//
//  Created by Rodrigo  Candido on 18/4/21.
//

import AVFoundation
import UIKit

class CameraController: NSObject{

    //    //A device that provides input (such as audio or video) for capture sessions and offers controls for hardware-specific capture features.
    //    //An AVCaptureDevice object represents a physical capture device and the properties associated with that device.
    //    //You use a capture device to configure the properties of the underlying hardware. A capture device also provides input data (such as audio or video) to an AVCaptureSession object.
    private var captureSession:    AVCaptureSession!
    
    //A Core Animation layer that displays the video as it’s captured. AVCaptureVideoPreviewLayer is a subclass of CALayer that you use to display video as it’s captured by an input device.
    //You use this preview layer in conjunction with a capture session, as shown in the following code fragment.
    private var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    
    
    //A device that provides input (such as audio or video) for capture sessions and offers controls for hardware-specific capture features.
    //An AVCaptureDevice object represents a physical capture device and the properties associated with that device. You use a capture device to configure the properties of the underlying hardware.
    private var cameraDevice: AVCaptureDevice!
    
    //A capture input that provides media from a capture device to a capture session.
    //AVCaptureDeviceInput is a concrete subclass of AVCaptureInput that you use to capture data from an AVCaptureDevice object.
    private var dataInput:AVCaptureDeviceInput!
    
    //A capture output that records video and provides access to video frames for processing.
    //Use this output to process compressed or uncompressed frames from the captured video. You can access the frames with the captureOutput(_:didOutput:from:) delegate method.
    private var dataOutput = AVCaptureVideoDataOutput()
    
    //To separate self queue from Main or other Globals
    private var cameraQueue = DispatchQueue(label: "VideoDataOutput", qos: .userInitiated, attributes: [], autoreleaseFrequency: .workItem)
    
    //
    private var bufferSize: CGSize = .zero
    
    var delegate: CameraControllerDelegate?
}


















// MARK: - Extension for camera Authorization and setup
extension CameraController{
    
    func grantCameraAuth(completion: @escaping(Error?) -> ()){
        AVCaptureDevice.requestAccess(for: .video) { (isAuthorized) in
            if isAuthorized{
                self.configureCaptureSession()
            }else {
                completion(nil)
            }
        }
    }
}
















// MARK: - Extesion to create and configure Capture Session
extension CameraController{
    func configureCaptureSession(){
        //1.
        captureSession = AVCaptureSession()
        
        captureSession.beginConfiguration()
        
        //A constant value indicating the quality level or bit rate of the output.
        captureSession.sessionPreset = .photo
        
        
       self.cameraDevice = AVCaptureDevice.default(for: .video)
        
        
        do {
            //The AVCaptureDeviceInput will serve as the "middle man" to attach the input device, backCamera to the session.
            self.dataInput = try AVCaptureDeviceInput(device: cameraDevice)
            
            if captureSession.canAddInput(dataInput){
                captureSession.addInput(dataInput)
            }
        } catch  {
            print("Error Unable to initialize back camera:  \(error.localizedDescription)")
        }
        
        
        
        captureSession.commitConfiguration()
    }
    
    
    func startSession(){
        if !self.captureSession.isRunning{
            self.captureSession.startRunning()
        }
    }
    
    func stopSession() {
        if self.captureSession.isRunning{
            self.captureSession.stopRunning()
        }
    }
}
















// MARK: - Extension for configure Inputs
extension CameraController{
    
    func setupLivePreview(in view: UIView){
        
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
        
        //Configure layer to resize while maintain the original aspect
        videoPreviewLayer.videoGravity = .resizeAspectFill
        
        //Fix orientation to portrait
        videoPreviewLayer.connection?.videoOrientation = .portrait
        
        //Add Captured image to a sort of output connection for the user
        view.layer.addSublayer(videoPreviewLayer)
        
        self.videoPreviewLayer.frame = view.bounds
        
        setupCapture()
        
    }
}


// MARK: - Extension  to actually run output
extension CameraController{
    private func setupCapture(){
        
        //A capture output that records video and provides access to video frames for processing.
        self.dataOutput = AVCaptureVideoDataOutput()
        
        dataOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_420YpCbCr8BiPlanarFullRange)]
        
        dataOutput.alwaysDiscardsLateVideoFrames = true
        
        dataOutput.setSampleBufferDelegate(self, queue: self.cameraQueue)
        
        
        self.captureSession.beginConfiguration()
        if self.captureSession.canAddOutput(dataOutput){
            
            self.captureSession.addOutput(dataOutput)
        }
        
        //Returns the first connection in the connections array with an input port of a specified media type
        let captureConnection = dataOutput.connection(with: .video)
        
        captureConnection?.isEnabled = true
        do {
            try  self.cameraDevice!.lockForConfiguration()
            let dimensions = CMVideoFormatDescriptionGetDimensions((cameraDevice?.activeFormat.formatDescription)!)
            bufferSize.width = CGFloat(dimensions.width)
            bufferSize.height = CGFloat(dimensions.height)
            cameraDevice!.unlockForConfiguration()
        } catch {
            print(error)
        }
        
        self.captureSession.commitConfiguration()
        
        self.startSession()
    }
}




extension CameraController: AVCaptureVideoDataOutputSampleBufferDelegate{
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
        guard let pixelBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {return}
        delegate?.didCapturedImage(imageBuffer: pixelBuffer, dimesions: self.bufferSize)
        
    }
}

