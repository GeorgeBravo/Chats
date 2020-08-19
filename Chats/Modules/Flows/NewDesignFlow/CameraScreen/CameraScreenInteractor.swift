// 
//  CameraScreenInteractor.swift
//  Chats
//
//  Created by user on 18.08.2020.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import BRIck
import AVFoundation

protocol CameraScreenRouting: ViewableRouting {

    // TODO: Declare methods the interactor can invoke to manage sub-tree view the router.
}

protocol CameraScreenPresentable: Presentable {
    var listener: CameraScreenPresentableListener? { get set }

    func setup(with previewLayer: AVCaptureVideoPreviewLayer?)
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol CameraScreenListener: class {

    // TODO: Declare methods the interactor can invoke to communicate with other BRIcks.
}

final class CameraScreenInteractor: PresentableInteractor<CameraScreenPresentable> {

    weak var router: CameraScreenRouting?
    weak var listener: CameraScreenListener?
    private let cameraManager = CameraManager()

    // TODO: Add additional dependencies to constructor. Do not perform any logic in constructor.

    override init(presenter: CameraScreenPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
        cameraManager.delegate = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        
        // TODO: Implement business logic here.
    }

    override func willResignActive() {
        super.willResignActive()

        // TODO: Pause any business logic.
    }
    
    deinit {
        print("CameraScreenInteractor deinit")
    }
}

extension CameraScreenInteractor: CameraScreenInteractable {}

extension CameraScreenInteractor: CameraScreenPresentableListener {
    func checkAndStartCameraSession() {
        cameraManager.checkCameraAuthorizationStatus()
    }
    
    func stopCameraSession() {
        cameraManager.stopCamera()
    }
}

// MARK: - CameraManagerDelegate
extension CameraScreenInteractor: CameraManagerDelegate {
    func setup(with previewLayer: AVCaptureVideoPreviewLayer?) {
        presenter.setup(with: previewLayer)
    }
}
