//
//  ObjectDetectionViewModelDelegate.swift
//  RealTimeObjectDetection
//
//  Created by Rodrigo  Candido on 18/4/21.
//

import Foundation
import Vision

protocol ObjectDetectionViewModelDelegate: AnyObject {
    func didRecognizeObject(recognizedObjects: [VNRecognizedObjectObservation])
    func didNotRecognizedObject()
}
