//
//  ObjectDetectionViewModel.swift
//  RealTimeObjectDetection
//
//  Created by Rodrigo  Candido on 18/4/21.
//

import Foundation
import Vision


class ObjectDetectionViewModel{
    var delegate: ObjectDetectionViewModelDelegate?
    
    var data: [CVPixelBuffer] = []
    
}

















// MARK: - Respond to Views demands
extension ObjectDetectionViewModel{
    
    
    func load(){
        
    }
    
    
    func filteredImages(texto: String, imageBuffer: CVPixelBuffer){
        
    }
    
    
    func imageWasCaptured(imageBuffer: CVPixelBuffer){
        do {
        
            let configuration = MLModelConfiguration()
            let model = try VNCoreMLModel(for: YOLOv3(configuration: configuration).model)
            
            let request = VNCoreMLRequest(model: model) { (resultRequest, error) in
                
                if let _ = error {
                    print("resquest VN error !")
                    return
                }
                
                guard let results = resultRequest.results as? [VNRecognizedObjectObservation] else { return}
                
                guard let observation = results.first else{
                    self.delegate?.didNotRecognizedObject()
                    return
                }
                
            
                if observation.confidence > 0.9 {
                    
                    self.delegate?.didRecognizeObject(recognizedObjects: [observation])
                }
            }
            
            let handler = VNImageRequestHandler(cvPixelBuffer: imageBuffer, options: [:])
            try handler.perform([request])
            
        } catch  {
            print(error.localizedDescription)
        }
    }
    
}
