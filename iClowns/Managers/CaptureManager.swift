//
//  CaptureManager.swift
//  iClowns
//
//  Created by Luigi Penza on 15/05/24.
//

import SwiftUI
import Foundation
import AVFoundation

@Observable class CaptureManager {
    enum Status {
        case unconfigured
        case configured
        case unauthorized
        case failed
    }
    
    static let shared = CaptureManager()
    
    var error: CameraError?
    
    var session = AVCaptureSession()
    private let sessionQueue = DispatchQueue(label: "com.iClowns.cameraSessionQ")
    private let videoOutput = AVCaptureVideoDataOutput()
    private var status: Status = .unconfigured
    
    private init() {
        config()
    }
    
    private func config() {
        checkPermissions()
        sessionQueue.async {
            self.configCaptureSession()
            self.session.startRunning()
            self.controllSession(start: true)
        }
    }
    
    func controllSession(start: Bool) {
        guard status == .configured else {
            self.config()
            return
        }
        
        sessionQueue.async {
            if start {
                if !self.session.isRunning {
                    self.session.startRunning()
                }
            } else {
                self.session.stopRunning()
            }
        }
    }
    
    private func setError(_ error: CameraError?) {
        DispatchQueue.main.async {
            self.error = error
        }
    }
    
    private func checkPermissions() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .notDetermined:
            sessionQueue.suspend()
            AVCaptureDevice.requestAccess(for: .video) { authorized in
                if !authorized {
                    self.status = .unauthorized
                    self.setError(.deniedAuthorization)
                }
                self.sessionQueue.resume()
            }
            
        case .restricted:
            status = .unauthorized
            setError(.restrictedAuthorization)
            
        case .denied:
            status = .unauthorized
            setError(.deniedAuthorization)
            
        case .authorized:
            status = .unconfigured
            
        @unknown default:
            status = .unauthorized
            setError(.unknownAuthorization)
        }
    }
    
    private func configCaptureSession() {
        guard status == .unconfigured else {
            return
        }
        
        session.beginConfiguration()
        defer {
            session.commitConfiguration()
        }
        
        // Setting Session Preset
        session.sessionPreset = .hd1920x1080
        
        // Preparing the device as input
        guard let device = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInDualCamera, .builtInUltraWideCamera], mediaType: .video, position: .back).devices.first else {
            setError(.cameraUnavailable)
            status = .failed
            return
        }
        let camera = device
        
        do {
            let cameraInput = try AVCaptureDeviceInput(device: camera)
            if session.canAddInput(cameraInput) {
                session.addInput(cameraInput)
            } else {
                setError(.cannotAddInput)
                status = .failed
                return
            }
        } catch {
            setError(.createCaptureInput(error))
            status = .failed
            return
        }
        
        if session.canAddOutput(videoOutput) {
            session.addOutput(videoOutput)
            videoOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA]
        } else {
            setError(.cannotAddOutput)
            status = .failed
            return
        }
        
        status = .configured
    }
    
    func set(_ delegate: AVCaptureVideoDataOutputSampleBufferDelegate, queue: DispatchQueue) {
        sessionQueue.async {
            self.videoOutput.setSampleBufferDelegate(delegate, queue: queue)
        }
    }
}

enum CameraError: Error {
    case cameraUnavailable
    case cannotAddInput
    case cannotAddOutput
    case createCaptureInput(Error)
    case deniedAuthorization
    case restrictedAuthorization
    case unknownAuthorization
}

extension CameraError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .cameraUnavailable:
            return "Camera unavailable"
        case .cannotAddInput:
            return "Cannot add capture input to session"
        case .cannotAddOutput:
            return "Cannot add video output to session"
        case .createCaptureInput(let error):
            return "Creating capture input for camera: \(error.localizedDescription)"
        case .deniedAuthorization:
            return "Camera access denied"
        case .restrictedAuthorization:
            return "Attempting to access a restricted capture device"
        case .unknownAuthorization:
            return "Unknown authorization status for capture device"
        }
    }
}

