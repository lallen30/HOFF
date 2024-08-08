//
//  ImageExtension.swift
//  HOFFER
//

//

import Foundation
import UIKit

extension UIImage {
    func saveToDocuments(filename:String) -> String? {
        var strName = ""
        if let date = Singleton.sharedSingleton.dateFormatterForUniqueName().string(from: Date()) as? String {
            strName = "\(filename)_\(date)"
        }else{
            strName = filename
        }
        strName = strName.replace(" ", replacement: "_")
        strName = strName + ".png"
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsDirectory.appendingPathComponent(strName)
        //jpegData(compressionQuality: 1.0)
		if let data = self.pngData(){
            do {
                try data.write(to: fileURL)
            } catch {
                print("error saving file to documents:", error)
                return nil
            }
            return strName
        }else{
            return nil
        }
    }
}


