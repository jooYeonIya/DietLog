//
//  ImageFileManager.swift
//  DiegLog
//
//  Created by Jooyeon Kang on 2024/04/18.
//

import UIKit

class ImageFileManager {
    
    static let shared = ImageFileManager()
    
    private let fileManager = FileManager.default
    private var documentDirectory: URL? {
        return fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
    }
    
    func saveImage(folderName: String, imageName: String, image: UIImage) {
        guard let documentDirectory = documentDirectory else { return }
        
        let folderDirectory = documentDirectory.appendingPathComponent(folderName)
        
        if !fileManager.fileExists(atPath: folderDirectory.path) {
            do {
                try fileManager.createDirectory(atPath: folderDirectory.path, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("Error saveImage() \(error)")
            }
        }
        
        let imageDirectory = folderDirectory.appendingPathComponent(imageName)
        
        guard let imageData = image.pngData() else {
            print("이미지 압축 실패")
            return
        }
        
        do {
            try imageData.write(to: imageDirectory, options: [.atomic])
        } catch {
            print("이미지 저장 실패 \(error)")
        }
    }
    
    func loadImage(with imagePath: String) -> UIImage? {
        guard let documentDirectory = documentDirectory else {
            return UIImage(named: "FoodBasicImage")
        }
        
        let imageDirectory = documentDirectory.appendingPathComponent(imagePath)
        
        return UIImage(contentsOfFile: imageDirectory.path)
    }
    
    func removeImage(with imagePath: String) {
        guard let documentDirectory = documentDirectory else { return }
        
        let imageDirectory = documentDirectory.appendingPathComponent(imagePath)
        
        do {
            try fileManager.removeItem(at: imageDirectory)
        } catch {
            print("Error removing file: \(error)")
        }
    }
}
