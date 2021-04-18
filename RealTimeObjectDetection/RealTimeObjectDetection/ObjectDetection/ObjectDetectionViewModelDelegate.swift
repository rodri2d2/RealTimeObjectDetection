//
//  ObjectDetectionViewModelDelegate.swift
//  RealTimeObjectDetection
//
//  Created by Rodrigo  Candido on 18/4/21.
//

import Foundation
import Vision

protocol ObjectDetectionViewModelDelegate: class {
    func didRecognizeObject(recognizedObjects: [VNRecognizedObjectObservation])
    func didNotRecognizedObject()
}
