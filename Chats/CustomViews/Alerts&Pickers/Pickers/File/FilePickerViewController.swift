//
//  FilePickerViewController.swift
//  Chats
//
//  Created by Mykhailo H on 7/13/20.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import Foundation
import UIKit
import MobileCoreServices
import PDFKit

extension UIAlertController {
    func addFilePicker(completion: @escaping FilePickerViewController.Selection) {
        let selection: FilePickerViewController.Selection = completion
        let vc = FilePickerViewController(selection: selection)
        if UIDevice.current.userInterfaceIdiom == .pad {
            vc.preferredContentSize.height = vc.preferredSize.height * 0.2
            vc.preferredContentSize.width = vc.preferredSize.width * 0.9
        } else {
            vc.preferredContentSize.height = 116
        }
        set(vc: vc)
    }
}

final class FilePickerViewController: UIViewController {
    
    public typealias Selection = (FileAsset?) -> ()
    
    fileprivate var selection: Selection?
    
    var preferredSize: CGSize {
        return UIScreen.main.bounds.size
    }
    
    fileprivate lazy var tableView: UITableView = { [unowned self] in
        $0.dataSource = self
        $0.delegate = self
        $0.rowHeight = 58
        $0.separatorColor = UIColor.lightGray.withAlphaComponent(0.4)
        $0.separatorInset = .zero
        $0.backgroundColor = nil
        $0.bounces = false
        $0.tableFooterView = UIView()
        $0.register(LikeButtonCell.self, forCellReuseIdentifier: LikeButtonCell.identifier)
        
        return $0
        }(UITableView(frame: .zero, style: .plain))
    
    
    required init(selection: Selection?) {
        self.selection = selection
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        view = tableView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func showDocumentPicker() {
        let documentTypes = [String(kUTTypeText),String(kUTTypeContent),String(kUTTypeItem),String(kUTTypeData)]
        let documentPicker = UIDocumentPickerViewController(documentTypes: documentTypes, in: .import)
        documentPicker.delegate = self
        
        self.present(documentPicker, animated: true, completion: nil)
    }
    
    private func getFileFormat(fileName: String) -> String {
        var suffix = String()
        if let rangeOfDot = fileName.range(of: ".", options: .backwards) {
            suffix = String(fileName.suffix(from: rangeOfDot.upperBound))
            suffix.insert(".", at: suffix.startIndex)
        }
        return suffix
    }
    
    private func getPDFImage(url: URL) -> UIImage? {
        var image: UIImage?
        let suffix = url.lastPathComponent.suffix(4)
        let last4 = String(suffix)
        if last4 == ".pdf" {
            if let document = PDFDocument(url: url) {
                try? extractImages(from: document) { (imageInfo) in
                    image = UIImage(data: imageInfo.data)
                }
            }
        }
        return image
    }
    
    private func getImage(url: URL, data: Data) -> UIImage? {
        var image: UIImage?
        let suffix = url.lastPathComponent.suffix(4)
        let last4 = String(suffix)
        if last4 == "jpeg" {
            image = UIImage(data: data)
        }
        return image
    }
    
    private func replaceLongFileName(fullFileName: String) -> String? {
        let fileFormat = getFileFormat(fileName: fullFileName)
        var shortFileName: String?
        if fullFileName.count > 10 {
            let lowBound = fullFileName.index(fullFileName.startIndex, offsetBy: 10)
            let upperBound = fullFileName.index(fullFileName.endIndex, offsetBy: -fileFormat.count - 2)
            let midRange = lowBound..<upperBound
            shortFileName = fullFileName
            shortFileName?.replaceSubrange(midRange, with: "...")
        }
        return shortFileName
    }
}

extension FilePickerViewController: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        
        guard let destinationUrl = urls.first else {
            return
        }
        var image: UIImage?
        var fileName: String?
        guard let url = urls.last else { return }
        
        let data = try? Data(contentsOf: destinationUrl)
        guard let d = data else {
            return
        }
        
        if let jpegImage = getImage(url: url, data: d) {
            image = jpegImage
        }
        
        if let shortFileName = replaceLongFileName(fullFileName: url.lastPathComponent) {
            fileName = shortFileName
        } else {
            fileName = url.lastPathComponent
        }
        
        let dataSize = Double(integerLiteral: Int64(d.count))
        let file = FileAsset(fileName: fileName, data: d, size: dataSize, image: image ?? UIImage(data: d))
        selection?(file)
        self.dismiss(animated: true, completion: nil)
    }
}

extension FilePickerViewController: UITableViewDelegate , UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LikeButtonCell.identifier) as! LikeButtonCell
        cell.textLabel?.font = UIFont.systemFont(ofSize: 20)
        if indexPath.row == 0 {
            cell.textLabel?.text = "Photo or video"
        }
        if indexPath.row == 1 {
            cell.textLabel?.text = "iCloud"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
        }
        if indexPath.row == 1 {
            showDocumentPicker()
        }
    }
}

//MARK: - Image From .PDF File
extension FilePickerViewController {
    
    func extractImages(from pdf: PDFDocument, extractor: @escaping (ImageInfo)->Void) throws {
        for pageNumber in 0..<pdf.pageCount {
            guard let page = pdf.page(at: pageNumber) else {
                throw PDFReadError.couldNotOpenPageNumber(pageNumber)
            }
            try extractImages(from: page, extractor: extractor)
        }
    }
    
    func extractImages(from page: PDFPage, extractor: @escaping (ImageInfo)->Void) throws {
        let pageNumber = page.label ?? "unknown page"
        guard let page = page.pageRef else {
            throw PDFReadError.couldNotOpenPage(pageNumber)
        }
        
        guard let dictionary = page.dictionary else {
            throw PDFReadError.couldNotOpenDictionaryOfPage(pageNumber)
        }
        
        guard let resources = dictionary[CGPDFDictionaryGetDictionary, "Resources"] else {
            throw PDFReadError.couldNotReadResources(pageNumber)
        }
        
        if let xObject = resources[CGPDFDictionaryGetDictionary, "XObject"] {
            print("reading resources of page", pageNumber)
            
            func extractImage(key: UnsafePointer<Int8>, object: CGPDFObjectRef, info: UnsafeMutableRawPointer?) -> Bool {
                guard let stream: CGPDFStreamRef = object[CGPDFObjectGetValue, .stream] else { return true }
                guard let dictionary = CGPDFStreamGetDictionary(stream) else {return true}
                
                guard dictionary.getName("Subtype", CGPDFDictionaryGetName) == "Image" else {return true}
                
                let colorSpaces = dictionary.getNameArray(for: "ColorSpace") ?? []
                let filter = dictionary.getNameArray(for: "Filter") ?? []
                
                var format = CGPDFDataFormat.raw
                guard let data = CGPDFStreamCopyData(stream, &format) as Data? else { return false }
                
                extractor(
                    ImageInfo(
                        name: String(cString: key),
                        colorSpaces: colorSpaces,
                        filter: filter,
                        format: format,
                        data: data
                    )
                )
                
                return true
            }
            
            CGPDFDictionaryApplyBlock(xObject, extractImage, nil)
        }
    }
    
    struct ImageInfo: CustomDebugStringConvertible {
        let name: String
        let colorSpaces: [String]
        let filter: [String]
        let format: CGPDFDataFormat
        let data: Data
        
        var debugDescription: String {
            """
            Image "\(name)"
            - color spaces: \(colorSpaces)
            - format: \(format == .JPEG2000 ? "JPEG2000" : format == .jpegEncoded ? "jpeg" : "raw")
            - filters: \(filter)
            - size: \(ByteCountFormatter.string(fromByteCount: Int64(data.count), countStyle: .binary))
            """
        }
    }
    
    enum PDFReadError: Error {
        case couldNotOpenPageNumber(Int)
        case couldNotOpenPage(String)
        case couldNotOpenDictionaryOfPage(String)
        case couldNotReadResources(String)
        case cannotReadXObjectStream(xObject: String, page: String)
    }
}

extension CGPDFObjectRef {
    func getName<K>(_ key: K, _ getter: (OpaquePointer, K, UnsafeMutablePointer<UnsafePointer<Int8>?>)->Bool) -> String? {
        guard let pointer = self[getter, key] else { return nil }
        return String(cString: pointer)
    }
    
    func getName<K>(_ key: K, _ getter: (OpaquePointer, K, UnsafeMutableRawPointer?)->Bool) -> String? {
        guard let pointer: UnsafePointer<UInt8> = self[getter, key] else { return nil }
        return String(cString: pointer)
    }
    
    subscript<R, K>(_ getter: (OpaquePointer, K, UnsafeMutablePointer<R?>)->Bool, _ key: K) -> R? {
        var result: R!
        guard getter(self, key, &result) else { return nil }
        return result
    }
    
    subscript<R, K>(_ getter: (OpaquePointer, K, UnsafeMutableRawPointer?)->Bool, _ key: K) -> R? {
        var result: R!
        guard getter(self, key, &result) else { return nil }
        return result
    }
    
    func getNameArray(for key: String) -> [String]? {
        var object: CGPDFObjectRef!
        guard CGPDFDictionaryGetObject(self, key, &object) else { return nil }
        
        if let name = object.getName(.name, CGPDFObjectGetValue) {
            return [name]
        } else {
            guard let array: CGPDFArrayRef = object[CGPDFObjectGetValue, .array] else {return nil}
            var names = [String]()
            for index in 0..<CGPDFArrayGetCount(array) {
                guard let name = array.getName(index, CGPDFArrayGetName) else { continue }
                names.append(name)
            }
            return names
        }
    }
}
