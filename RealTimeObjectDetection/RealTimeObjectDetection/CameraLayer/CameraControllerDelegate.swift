//
//  CameraControllerDelegate.swift
//  RealTimeObjectDetection
//
//  Created by Rodrigo  Candido on 18/4/21.
//

import AVFoundation
import UIKit

protocol CameraControllerDelegate {
    func didCapturedImage(imageBuffer: CVPixelBuffer, dimesions: CGSize)
}

