//
//  ImagePicker.swift
//  SnapPatch

import SwiftUI
import Photos

enum PicStatus {
    case denied
    case approved
    case limited
}

struct Asset: Identifiable {
    let asset: PHAsset
    let image: UIImage
    var id: String
    
    init(asset: PHAsset, image: UIImage, id: String = UUID().uuidString) {
        self.asset = asset
        self.image = image
        self.id = asset.localIdentifier
    }
    
}

class ImagePicker: NSObject, ObservableObject, PHPhotoLibraryChangeObserver {
    
    @Published var status = PicStatus.denied
    
    @Published var fetchedPhotos: [Asset] = []
    
    @Published var allPhotos: PHFetchResult<PHAsset>!
    
    @Published var selectedImage: UIImage!
    
    override init() {
        super.init()
        setup()
        openPicker()
    }
    
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        guard let _ = allPhotos else { return }
        
        if let updates = changeInstance.changeDetails(for: allPhotos) {
            
            let updatedPhotos = updates.fetchResultAfterChanges
            
            
            updatedPhotos.enumerateObjects { asset, index, _ in
                
                if !self.allPhotos.contains(asset) {
                    self.getImageFromPHAsset(asset: asset) { image in
                        DispatchQueue.main.async {
                            self.fetchedPhotos.append(.init(asset: asset, image: image))
                        }
                    }
                }
                
            }
            
            allPhotos.enumerateObjects { asset, index, _ in
                if !updatedPhotos.contains(asset) {
                    DispatchQueue.main.async {
                        self.fetchedPhotos.removeAll { result in
                            result.asset == asset
                        }
                    }
                }
            }
            
            DispatchQueue.main.async {
                self.allPhotos = updatedPhotos
            }
            
        }
    }
    
    func openPicker() {
        
        if fetchedPhotos.isEmpty {
            fetchPhotos()
        }
        
    }
 
    func setup() {
        
        PHPhotoLibrary.requestAuthorization(for: .readWrite) { libStatus in
            DispatchQueue.main.async {
                switch libStatus {
                case .denied:
                    self.status = .denied
                case .authorized:
                    self.status = .approved
                case .limited:
                    self.status = .limited
                default:
                    self.status = .denied
                }
            }
        }
        
        PHPhotoLibrary.shared().register(self)
        
    }
    
    func fetchPhotos() {
        
        let options = PHFetchOptions()
        
        options.sortDescriptors = [
            .init(key: "creationDate", ascending: false)
        ]
        
        options.includeHiddenAssets = false
        
        let fetchResults = PHAsset.fetchAssets(with: options)
        
        allPhotos = fetchResults
        
        fetchResults.enumerateObjects { asset, index, _ in
            
            self.getImageFromPHAsset(asset: asset) { [self] image in
                
                fetchedPhotos.append(.init(asset: asset, image: image))
                
            }
            
        }
        
    }
    
    func getImageFromPHAsset(asset: PHAsset, size: CGSize = .init(width: 120, height: 120), completion: @escaping (UIImage) -> Void) {
        
        let imageManager = PHCachingImageManager()
        imageManager.allowsCachingHighQualityImages = true
        
        let imageOptions = PHImageRequestOptions()
        imageOptions.deliveryMode = .highQualityFormat
        imageOptions.isSynchronous = false
        
//        let size = CGSize(width: 150, height: 150)
        
        imageManager.requestImage(for: asset, targetSize: size, contentMode: .aspectFill, options: imageOptions) { image, _ in
            guard let image else { return }
            completion(image)
        }
        
    }
    
    class func getFullImage(for asset: Asset, _ completion: @escaping (UIImage) -> Void) {
        let imageManager = PHCachingImageManager()
        imageManager.allowsCachingHighQualityImages = true
        
        let imageOptions = PHImageRequestOptions()
        imageOptions.deliveryMode = .highQualityFormat
        imageOptions.isSynchronous = false
        
        imageManager.requestImage(for: asset.asset, targetSize: PHImageManagerMaximumSize, contentMode: .aspectFill, options: imageOptions) { image, _ in
            guard let image else { return }
            completion(image)
        }

    }
    
    func extractPreview(_ asset: PHAsset) {
        if asset.mediaType == .image {
            getImageFromPHAsset(asset: asset, size: PHImageManagerMaximumSize) { image in
                DispatchQueue.main.async {
                    self.selectedImage = image
                }
            }
        }
    }
    
}
