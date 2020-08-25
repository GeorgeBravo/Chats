//
//  CameraManager.swift
//  Chats
//
//  Created by user on 18.08.2020.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import AVFoundation

protocol CameraManagerDelegate: class {
    func setup(with previewLayer: AVCaptureVideoPreviewLayer?)
}

final class CameraManager: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {

    // MARK: - Variables
    private let session = AVCaptureSession()
    private var captureDevice: AVCaptureDevice!
    private var videoDataOutput: AVCaptureVideoDataOutput!
    private var videoDataOutputQueue: DispatchQueue!
    weak var delegate: CameraManagerDelegate?
    
    // MARK: - Logic
    func checkCameraAuthorizationStatus() {
        if AVCaptureDevice.authorizationStatus(for: .video) == .notDetermined {
            AVCaptureDevice.requestAccess(for: .video) { [unowned self] _ in
                self.setupAVCapture()
            }
        } else {
            setupAVCapture()
        }
    }

    private func setupAVCapture() {
        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
            AVCaptureDevice.authorizationStatus(for: .video) == .authorized else {
                delegate?.setup(with: nil)
                return
        }
        session.sessionPreset = AVCaptureSession.Preset.medium
        captureDevice = device
        beginSession()
    }

    private func beginSession() {
        var deviceInput: AVCaptureDeviceInput!

        do {
            deviceInput = try AVCaptureDeviceInput(device: captureDevice)
            guard deviceInput != nil else {
                print("CameraManager error: cant get deviceInput")
                delegate?.setup(with: nil)
                return
            }

            if self.session.canAddInput(deviceInput) {
                self.session.addInput(deviceInput)
            }

            videoDataOutput = AVCaptureVideoDataOutput()
            videoDataOutput.alwaysDiscardsLateVideoFrames = true
            videoDataOutputQueue = DispatchQueue(label: "VideoDataOutputQueue")
            videoDataOutput.setSampleBufferDelegate(self, queue: self.videoDataOutputQueue)

            if session.canAddOutput(self.videoDataOutput){
                session.addOutput(self.videoDataOutput)
            }

            videoDataOutput.connection(with: .video)?.isEnabled = true

            startCamera()
        } catch let error as NSError {
            deviceInput = nil
            delegate?.setup(with: nil)
            print("CameraManager error: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Manipulation logic
    func startCamera() {
        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        delegate?.setup(with: previewLayer)
        session.startRunning()
    }

    func stopCamera() {
        session.stopRunning()
    }
}
