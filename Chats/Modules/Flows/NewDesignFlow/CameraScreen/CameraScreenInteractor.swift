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
    func updateCloseFriendsCollectionView()
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol CameraScreenListener: class {

    func hideCameraScreen()
    // TODO: Declare methods the interactor can invoke to communicate with other BRIcks.
}

final class CameraScreenInteractor: PresentableInteractor<CameraScreenPresentable> {

    // MARK: - Variables
    weak var router: CameraScreenRouting?
    weak var listener: CameraScreenListener?
    private let cameraManager = CameraManager()
    private var closeFriendsCollectionViewDataSource: CloseFriendsCollectionViewDataSource
    
    // TODO: Add additional dependencies to constructor. Do not perform any logic in constructor.

    // MARK: - Life cycle
    override init(presenter: CameraScreenPresentable) {
        closeFriendsCollectionViewDataSource = CloseFriendsCollectionViewDataSource()
        super.init(presenter: presenter)
        presenter.listener = self
        cameraManager.delegate = self
        closeFriendsCollectionViewDataSource.delegate = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        
        // TODO: Implement business logic here.
    }

    override func willResignActive() {
        super.willResignActive()

        // TODO: Pause any business logic.
    }
    
}

extension CameraScreenInteractor: CameraScreenInteractable {}

extension CameraScreenInteractor: CameraScreenPresentableListener {
    
    func checkAndStartCameraSession() {
        cameraManager.checkCameraAuthorizationStatus()
    }
    
    func getCloseFriendCollectionViewDataSourceAndDelegate() -> CloseFriendsCollectionViewDataSource {
        return closeFriendsCollectionViewDataSource
    }
    
    func stopCameraSession() {
        cameraManager.stopCamera()
    }
    
    func hideCameraScreen() {
        listener?.hideCameraScreen()
    }
    
    func fillCloseFriendsCollectionViewDataSource() {
        closeFriendsCollectionViewDataSource.fillModels(with: [CloseFriendCollectionViewCellModel(userImage: nil, isPhotoCellModel: true), CloseFriendCollectionViewCellModel(userImage: #imageLiteral(resourceName: "Dan-Leonard")), CloseFriendCollectionViewCellModel(userImage: #imageLiteral(resourceName: "roflan"))])
    }
    
}

// MARK: - CameraManagerDelegate
extension CameraScreenInteractor: CameraManagerDelegate {
    
    func setup(with previewLayer: AVCaptureVideoPreviewLayer?) {
        presenter.setup(with: previewLayer)
    }
    
}

extension CameraScreenInteractor: CloseFriendsCollectionViewDataSourceDelegate {
    func updateCloseFriendsCollectionView() {
        presenter.updateCloseFriendsCollectionView()
    }
}
