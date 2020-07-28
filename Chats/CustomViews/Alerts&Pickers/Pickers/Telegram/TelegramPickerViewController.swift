import Foundation
import UIKit
import Photos

public typealias TelegramSelection = (TelegramSelectionType) -> ()

public enum TelegramSelectionType {
    
    case newPhoto(UIImage?)
    case newVideo(URL?)
    case photo([PHAsset])
    case location(Location?)
    case contact(Contact?)
    case file(FileAsset?)
}

extension UIAlertController {
    
    /// Add Telegram Picker
    ///
    /// - Parameters:
    ///   - selection: type and action for selection of asset/assets
    
    func addTelegramPicker(selection: @escaping TelegramSelection) {
        let vc = TelegramPickerViewController(selection: selection)
        set(vc: vc)
    }
}


final class TelegramPickerViewController: UIViewController {
    var buttons: [ButtonType] {
        return selectedAssets.count == 0
            ? [.photoOrVideo, .location, .contact, .file]
            : [.sendPhotos, .sendAsFile]
    }
    
    enum ButtonType {
        case photoOrVideo
        case file
        case location
        case contact
        case sendPhotos
        case sendAsFile
    }
    
    // MARK: UI
    
    struct UI {
        static let rowHeight: CGFloat = 58
        static let insets: UIEdgeInsets = UIEdgeInsets(top: 57, left: 8, bottom: 0, right: 8)
        static let minimumInteritemSpacing: CGFloat = 6
        static let minimumLineSpacing: CGFloat = 6
        static let maxHeight: CGFloat = 92
        static let multiplier: CGFloat = 2.26
        static let animationDuration: TimeInterval = 0.3
    }
    
    func title(for button: ButtonType) -> String {
        switch button {
        case .photoOrVideo: return "Photo or Video"
        case .file: return "File"
        case .location: return "Location"
        case .contact: return "Contact"
        case .sendPhotos:
        return changeTitleForButton()
        case .sendAsFile: return "Send as File"
        }
    }
    
    func changeTitleForButton() -> String {
        var hasImage: Bool = false
        var hasVideo: Bool = false
        for asset in selectedAssets {
            if asset.mediaType == .video {
                hasVideo = true
            }
            if asset.mediaType == .image {
                hasImage = true
            }
        }
        if selectedAssets.count > 1 {
            if hasImage && hasVideo {
                return "Send \(selectedAssets.count) Items"
            }
            if hasImage && !hasVideo {
                return "Send \(selectedAssets.count) Photos"
            }
            if !hasImage && hasVideo {
                return "Send \(selectedAssets.count) Videos"
            }
        }
        if selectedAssets.count == 1 {
            if hasImage {
                return "Send 1 Photo"
            }
            if hasVideo {
                return "Send 1 Video"
            }
        }
        return ""
    }
    
    func font(for button: ButtonType) -> UIFont {
        switch button {
        case .sendPhotos: return UIFont.boldSystemFont(ofSize: 20)
        default: return UIFont.systemFont(ofSize: 20) }
    }
    
    var preferredHeight: CGFloat {
        return UI.maxHeight * (selectedAssets.count == 0 ? 1 : UI.multiplier) + UI.insets.top + UI.insets.bottom
    }
    
    func sizeFor(asset: PHAsset) -> CGSize {
        let height: CGFloat = UI.maxHeight * UI.multiplier
        var width: CGFloat = CGFloat(Double(height) * Double(asset.pixelWidth) / Double(asset.pixelHeight))
        if width > UIScreen.main.bounds.width * 0.6 {
            width = height
        }
        //        CGFloat(Double(height) * Double(asset.pixelWidth) / Double(asset.pixelHeight))
        return CGSize(width: width, height: height)
    }
    
    func sizeForItem(asset: PHAsset) -> CGSize {
        let size: CGSize = sizeFor(asset: asset)
        if selectedAssets.count == 0 {
            let value: CGFloat = 84
            return CGSize(width: value, height: value)
        } else {
            return size
        }
    }
    
    // MARK: Properties

    var initialTouchPoint: CGPoint = CGPoint(x: 0,y: 0)
    private var videoCell: ItemWithCameraPreview? {
        didSet {
            if !self.session.isRunning {
                DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + 0.05, execute: { [unowned self] in
                    self.startCamera()
                })
            }
        }
    }
    fileprivate lazy var shareLabel: UILabel = { [unowned self] in
        $0.text = "Share"
        $0.textAlignment = .center
        $0.textColor = Color.init(named: ColorName.aquamarine)
        $0.font = UIFont.helveticaNeueFontOfSize(size: 20, style: .bold)
        return $0
    }(UILabel())
    
    fileprivate lazy var collectionView: UICollectionView = { [unowned self] in
        $0.dataSource = self
        $0.delegate = self
        $0.allowsMultipleSelection = true
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
        $0.decelerationRate = UIScrollView.DecelerationRate.fast
        $0.contentInsetAdjustmentBehavior = .never
        $0.contentInset = UI.insets
        $0.backgroundColor = .clear
        $0.alwaysBounceVertical = false
        $0.alwaysBounceHorizontal = false
        $0.isDirectionalLockEnabled = true
        $0.bounces = false
        $0.maskToBounds = false
        $0.clipsToBounds = false
        $0.register(ItemWithPhoto.self, forCellWithReuseIdentifier: String(describing: ItemWithPhoto.self))
        $0.register(ItemWithCameraPreview.self, forCellWithReuseIdentifier: String(describing: ItemWithCameraPreview.self))
        
        return $0
        }(UICollectionView(frame: .zero, collectionViewLayout: layout))
    
    fileprivate lazy var layout: PhotoLayout = { [unowned self] in
        $0.delegate = self
        $0.lineSpacing = UI.minimumLineSpacing
        return $0
        }(PhotoLayout())
    
    fileprivate lazy var tableView: UITableView = { [unowned self] in
        $0.dataSource = self
        $0.delegate = self
        $0.rowHeight = UI.rowHeight
        $0.separatorColor = UIColor.lightGray.withAlphaComponent(0.4)
        $0.separatorInset = .zero
        $0.backgroundColor = nil
        $0.bounces = false
        $0.tableHeaderView = collectionView
        $0.tableFooterView = UIView()
        $0.register(LikeButtonCell.self, forCellReuseIdentifier: LikeButtonCell.identifier)
        
        return $0
        }(UITableView(frame: .zero, style: .plain))
    
    lazy var assets = [PHAsset]()
    lazy var selectedAssets = [PHAsset]()
    lazy var selectedCells: [IndexPath] = []
    lazy var needReload: Bool = false
    
    var selection: TelegramSelection?
    
    private var videoDataOutput: AVCaptureVideoDataOutput!
    private var videoDataOutputQueue: DispatchQueue!
    private var imagePickerWindow: UIWindow? = nil
    private var captureDevice: AVCaptureDevice!
    private let session = AVCaptureSession()
    private var hasCamera: Bool = false
    private var needShowCameraPreviewCell = true
    private var heightHasChanged: Bool = false {
        didSet {
            tableView.reloadData()
        }
    }
    private var oldHeight: CGFloat?
    
    // MARK: Initialize
    
    required init(selection: @escaping TelegramSelection) {
        self.selection = selection
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = tableView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            preferredContentSize.width = UIScreen.main.bounds.width * 0.5
        }
        
        setupShareLabel()
        setupGesture()
        checkCameraAuthorizationStatus()
        updatePhotos()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        stopCamera()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layoutSubviews()
    }
    
    func setupGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(dissmisTelegramWithSwipe))
        self.view.addGestureRecognizer(panGesture)
    }
    
    func setupShareLabel() {
        tableView.addSubview(shareLabel) {
            $0.top == tableView.topAnchor + 20
            $0.centerX == tableView.centerXAnchor
            $0.height == 16
        }
    }
    
    func layoutSubviews() {
        tableView.tableHeaderView?.height = preferredHeight
        preferredContentSize.height = preferredHeight + (CGFloat(buttons.count) * UI.rowHeight)
    }
    
    func updatePhotos() {
        checkStatus { [unowned self] assets in
            
            self.assets.removeAll()
            if self.hasCamera { self.assets.append(PHAsset()) }
            self.assets.append(contentsOf: assets)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.collectionView.reloadData()
            }
        }
    }
    
    func getAssetInfoForFile() -> FileAsset? {
        guard let asset = self.selectedAssets.first else { return nil}
        let image = asset.image
        let data = image.pngData()
        let fileName = asset.originalFilename
        return FileAsset(fileName: fileName, data: data, size: nil, image: image)
    }
    
    func checkStatus(completionHandler: @escaping ([PHAsset]) -> ()) {
        switch PHPhotoLibrary.authorizationStatus() {
            
        case .notDetermined:
            /// This case means the user is prompted for the first time for allowing contacts
            Assets.requestAccess { [unowned self] status in
                self.checkStatus(completionHandler: completionHandler)
            }
            
        case .authorized:
            /// Authorization granted by user for this app.
            DispatchQueue.main.async {
                self.fetchPhotos(completionHandler: completionHandler)
            }
            
        case .denied, .restricted:
            /// User has denied the current app to access the contacts.
            let productName = Bundle.main.infoDictionary!["CFBundleName"]!
            let alert = UIAlertController(style: .alert, title: "Permission denied", message: "\(productName) does not have access to contacts. Please, allow the application to access to your photo library.")
            alert.addAction(title: "Settings", style: .destructive) { action in
                if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(settingsURL)
                }
            }
            alert.addAction(title: "OK", style: .cancel) { [unowned self] action in
                self.alertController?.dismiss(animated: true)
            }
            alert.show()
        }
    }
    
    func fetchPhotos(completionHandler: @escaping ([PHAsset]) -> ()) {
        Assets.fetch { [unowned self] result in
            switch result {
                
            case .success(let assets):
                completionHandler(assets)
                
            case .error(let error):
                let alert = UIAlertController(style: .alert, title: "Error", message: error.localizedDescription)
                alert.addAction(title: "OK") { [unowned self] action in
                    self.alertController?.dismiss(animated: true)
                }
                alert.show()
            }
        }
    }
    
    func action(withAsset asset: PHAsset, at indexPath: IndexPath) {
        let previousCount = selectedAssets.count
        
        if hasCamera && needShowCameraPreviewCell && indexPath.item == 0 {
            showCamera()
            return
        }
        
        selectedAssets.contains(asset)
            ? selectedAssets.remove(asset)
            : selectedAssets.append(asset)
        
        let currentCount = selectedAssets.count
        
        if hasCamera && previousCount == 0 && currentCount != 0 {
            layout.expanded = true
            needShowCameraPreviewCell = false
            needReload = true
        }
        
        if hasCamera && previousCount != 0 && currentCount == 0 {
            layout.expanded = false
            needShowCameraPreviewCell = true
            needReload = true
        }
        
        if (previousCount == 0 && currentCount > 0) || (previousCount > 0 && currentCount == 0) {
            self.view.layoutIfNeeded()

            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
                self.layout.invalidateLayout()
            }) { finished in
                self.layoutSubviews()
                if !self.layout.expanded {
                    self.layout.selectedCellIndexPath = nil
                }
            }
        }
        tableView.reloadData()
    }
    
    func action(for button: ButtonType) {
        switch button {
            
        case .photoOrVideo:
            alertController?.addPhotoLibraryPicker(flow: .vertical, paging: false,
                                                   selection: .multiple(action: { assets in
                                                    self.selection?(TelegramSelectionType.photo(assets))
                                                   }))
            
        case .file:
            alertController?.addFilePicker { file in
                self.selection?(TelegramSelectionType.file(file))
            }
            
        case .location:
            alertController?.addLocationPicker { location in
                self.selection?(TelegramSelectionType.location(location))
            }
            
        case .contact:
            alertController?.addContactsPicker { contact in
                self.selection?(TelegramSelectionType.contact(contact))
            }
            
        case .sendPhotos:
            alertController?.dismiss(animated: true) { [unowned self] in
                self.selection?(TelegramSelectionType.photo(self.selectedAssets))
            }
            
        case .sendAsFile:
            alertController?.dismiss(animated: true) { [unowned self] in
                self.selection?(TelegramSelectionType.file(self.getAssetInfoForFile()))
            }
        }
    }
    
    func showCamera() {
        stopCamera()
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.allowsEditing = true
        pickerController.mediaTypes = ["public.image", "public.movie"]
        pickerController.sourceType = .camera
        
        imagePickerWindow = UIWindow(frame: UIScreen.main.bounds)
        imagePickerWindow?.rootViewController = UIViewController()
        imagePickerWindow?.windowLevel = UIWindow.Level.alert + 1
        imagePickerWindow?.makeKeyAndVisible()
        
        imagePickerWindow?.rootViewController?.present(pickerController, animated: true, completion: nil)
    }
    
    func stringFromTimeInterval(interval: TimeInterval) -> String {
        
        let time = NSInteger(interval)
        let seconds = time % 60
        let minutes = (time / 60) % 60
        
        return String(format: "%0.1d:%0.2d",minutes,seconds)
        
    }
    
    @objc func dissmisTelegramWithSwipe(_ sender: UIPanGestureRecognizer) {
        let touchPoint = sender.location(in: self.view?.window)
        
        if sender.state == UIGestureRecognizer.State.began {
            initialTouchPoint = touchPoint
        } else if sender.state == UIGestureRecognizer.State.ended || sender.state == UIGestureRecognizer.State.cancelled {
            if touchPoint.y - initialTouchPoint.y > 100 {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
}

// MARK: - TableViewDelegate
extension TelegramPickerViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = collectionView.cellForItem(at: indexPath) as? ItemWithPhoto else {
            if let _ = collectionView.cellForItem(at: indexPath) as? ItemWithCameraPreview {
                collectionView.deselectItem(at: indexPath, animated: false)
                action(withAsset: assets[indexPath.item], at: indexPath)
            }
            return
        }
        
        layout.selectedCellIndexPath = layout.selectedCellIndexPath == indexPath ? nil : indexPath
        action(withAsset: assets[indexPath.item], at: indexPath)
        if selectedCells.contains(indexPath) {
            selectedCells = selectedCells.filter() { $0 != indexPath }
        } else {
            selectedCells.append(indexPath)
        }
        
        if let index = selectedCells.firstIndex(where: { $0.row == indexPath.row }) {
            //use index
            item.selectedPoint.text = "\(index + 1)"
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        layout.selectedCellIndexPath = layout.selectedCellIndexPath == indexPath ? nil : indexPath
        if selectedCells.contains(indexPath) {
            selectedCells = selectedCells.filter(){$0 != indexPath}
        }
        if !selectedCells.isEmpty {
            collectionView.reloadItems(at: selectedCells)
        } else {
         layout.selectedCellIndexPath = indexPath
        }
        action(withAsset: assets[indexPath.item], at: indexPath)
    }
}
// MARK: - CollectionViewDataSource

extension TelegramPickerViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return assets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 && hasCamera {
            guard let item = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ItemWithCameraPreview.self), for: indexPath) as? ItemWithCameraPreview else { return UICollectionViewCell() }
            if let videoCell = self.videoCell {
                return videoCell
            } else {
                self.videoCell = item
                self.videoCell?.delegate = self
                let previewLayer = AVCaptureVideoPreviewLayer(session: self.session)
                previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
                self.videoCell?.setup(with: previewLayer)
            }
            return videoCell ?? item
        }
        guard let item = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ItemWithPhoto.self), for: indexPath) as? ItemWithPhoto else { return UICollectionViewCell() }
        
        let asset = assets[indexPath.item]
        let size = sizeFor(asset: asset)
        
        DispatchQueue.main.async {
                Assets.resolve(asset: asset, size: size) { new in
                    if asset.mediaType == .video {
                        item.videoImageVIew.isHidden = false
                        item.videoDurationLabel.text = self.stringFromTimeInterval(interval: asset.duration)
                    } else if asset.mediaType == .image {
                        item.videoImageVIew.isHidden = true
                        item.videoDurationLabel.text = nil
                    }
                    item.imageView.image = new
                }
        }
        
        if let index = selectedCells.firstIndex(where: { $0.row == indexPath.row }) {
            //use index
            collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .init(rawValue: 0))
            item.selectedPoint.text = "\(index + 1)"
        } else {
            collectionView.deselectItem(at: indexPath, animated: true)
        }
        
        return item
    }
}

// MARK: - PhotoLayoutDelegate

extension TelegramPickerViewController: PhotoLayoutDelegate {
    
    func collectionView(_ collectionView: UICollectionView, sizeForPhotoAtIndexPath indexPath: IndexPath) -> CGSize {
        let size: CGSize = sizeForItem(asset: assets[indexPath.item])
        if let height = oldHeight {
            if height == size.height {
                heightHasChanged = false
            } else {
                heightHasChanged = true
                oldHeight = size.height
            }
        } else {
            heightHasChanged = true
            oldHeight = size.height
        }
        return size
    }
}

// MARK: - TableViewDelegate

extension TelegramPickerViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            self.action(for: self.buttons[indexPath.row])
        }
    }
}

// MARK: - TableViewDataSource

extension TelegramPickerViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return buttons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LikeButtonCell.identifier) as! LikeButtonCell
        cell.textLabel?.font = font(for: buttons[indexPath.row])
        cell.textLabel?.text = title(for: buttons[indexPath.row])
        return cell
    }
}

extension TelegramPickerViewController: AVCaptureVideoDataOutputSampleBufferDelegate, ItemWithCameraPreviewDelegate {
    func checkCameraAuthorizationStatus() {
        if AVCaptureDevice.authorizationStatus(for: .video) == .notDetermined {
            AVCaptureDevice.requestAccess(for: .video) { [unowned self] _ in
                self.setupAVCapture()
            }
        } else {
            setupAVCapture()
        }
    }
    
    func setupAVCapture() {
        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
            AVCaptureDevice.authorizationStatus(for: .video) == .authorized else {
                hasCamera = false
                layout.hasCamera = false
                return
        }
        session.sessionPreset = AVCaptureSession.Preset.medium
        captureDevice = device
        beginSession()
    }
    
    func beginSession() {
        var deviceInput: AVCaptureDeviceInput!
        
        do {
            deviceInput = try AVCaptureDeviceInput(device: captureDevice)
            guard deviceInput != nil else {
                print("error: cant get deviceInput")
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
            
            hasCamera = true
            layout.hasCamera = true
        } catch let error as NSError {
            deviceInput = nil
            print("error: \(error.localizedDescription)")
        }
    }
    
    func startCamera() {
        session.startRunning()
    }
    
    func stopCamera() {
        session.stopRunning()
    }
}

// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension TelegramPickerViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.startCamera()
        picker.dismiss(animated: true) { [unowned self] in
            self.imagePickerWindow = nil
            self.selection?(TelegramSelectionType.newPhoto(nil))
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        self.imagePickerWindow = nil
        if let image = info[.editedImage] as? UIImage {
            selection?(TelegramSelectionType.newPhoto(image))
        } else if let videoURL = info[.mediaURL] as? URL {
            selection?(TelegramSelectionType.newVideo(videoURL))
        } else {
            selection?(TelegramSelectionType.newPhoto(nil))
        }
    }
}
