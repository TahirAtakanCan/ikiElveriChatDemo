//
//  FileStorage.swift
//  ikiElveriChatDemo
//
//  Created by Tahir Atakan Can on 6.06.2024.
//

import Foundation
import FirebaseStorage
import Toast
import UIKit
import ProgressHUD
import AVFoundation

let storage = Storage.storage()

class FileStorage {
    
    //MARK: -  Images
    class func uploadImage(_ image: UIImage, directory: String, completion: @escaping(_ documentLink: String?) -> Void) {
            let storageRef = storage.reference(forURL: kFILEREFERANCE).child(directory)
            
            guard let imageData = image.jpegData(compressionQuality: 0.6) else {
                print("Error: Could not convert image to data")
                completion(nil)
                return
            }
            
            var task: StorageUploadTask!
            
            task = storageRef.putData(imageData, metadata: nil, completion: { (metadata, error) in
                task.removeAllObservers()
                ProgressHUD.dismiss()
                
                if let error = error {
                    print("Error uploading image: \(error.localizedDescription)")
                    completion(nil)
                    return
                }
                
                storageRef.downloadURL { (url, error) in
                    if let error = error {
                        print("Error getting download URL: \(error.localizedDescription)")
                        completion(nil)
                        return
                    }
                    
                    guard let downloadUrl = url else {
                        completion(nil)
                        return
                    }
                    
                    completion(downloadUrl.absoluteString)
                }
            })
            
            task.observe(StorageTaskStatus.progress) { (snapshot) in
                let progress = snapshot.progress!.completedUnitCount / snapshot.progress!.totalUnitCount
                //ProgressHUD.showProgress(CGFloat(progress))
            }
        }
    
    
    class func downloadImage(imageUrl: String, completion: @escaping (_ image: UIImage?) -> Void) {
        let imageFileName = fileNameFrom(fileUrl: imageUrl)
        
        if fileExistsAtPath(path: imageFileName) {
            //get it locally
            //print("We have local image")
            
            if let contentsOfFile = UIImage(contentsOfFile: fileInDocumentsDirectory(fileName: imageFileName)) {
                completion(contentsOfFile)
            }else{
                //print("couldn't convert local image")
                completion(UIImage(named: "avatar"))
            }
        }else {
            //download from FB
            //print("Lets get from FB")
            
            if imageUrl != "" {
                let documentUrl = URL(string: imageUrl)
                let downloadQueue = DispatchQueue(label: "imageDownloadQueue")
                
                downloadQueue.async {
                    let data = NSData(contentsOf: documentUrl!)
                    
                    if data != nil {
                        //Save Locally
                        FileStorage.saveFileLocally(fileData: data!, fileName: imageFileName)
                        
                        DispatchQueue.main.async {
                            completion(UIImage(data: data! as Data))
                        }
                        
                    }else {
                        print("no document in database")
                        DispatchQueue.main.async {
                            completion(nil)
                        }
                    }
                }
            }
        }
        
    }
    
    //MARK: - Video
    class func uploadVideo(_ video: NSData, directory: String, completion: @escaping(_ videoLink: String?) -> Void) {
            
            let storageRef = storage.reference(forURL: kFILEREFERANCE).child(directory)
            
            var task: StorageUploadTask!
            
            task = storageRef.putData(video as Data, metadata: nil, completion: { (metadata, error) in
                task.removeAllObservers()
                ProgressHUD.dismiss()
                
                if let error = error {
                    print("Error uploading image: \(error.localizedDescription)")
                    completion(nil)
                    return
                }
                
                storageRef.downloadURL { (url, error) in
                    if let error = error {
                        print("Error getting download URL: \(error.localizedDescription)")
                        completion(nil)
                        return
                    }
                    
                    guard let downloadUrl = url else {
                        completion(nil)
                        return
                    }
                    
                    completion(downloadUrl.absoluteString)
                }
            })
            
            task.observe(StorageTaskStatus.progress) { (snapshot) in
                let progress = snapshot.progress!.completedUnitCount / snapshot.progress!.totalUnitCount
                //ProgressHUD.showProgress(CGFloat(progress))
            }
    }
    
    class func downloadVideo(videoLink: String, completion: @escaping (_ isReadyToPlay: Bool, _ videoFileName: String) -> Void) {
        
        let videoUrl = URL(string: videoLink)
        let videoFileName = fileNameFrom(fileUrl: videoLink) + ".mov"
        
        if fileExistsAtPath(path: videoFileName) {
            completion(true, videoFileName)
        } else {
            let downloadQueue = DispatchQueue(label: "VideoDownloadQueue", qos: .userInitiated)
            
            downloadQueue.async {
                let urlSession = URLSession(configuration: .default)
                let downloadTask = urlSession.dataTask(with: videoUrl!) { data, response, error in
                    if let data = data {
                        // Save Locally
                        FileStorage.saveFileLocally(fileData: data as NSData, fileName: videoFileName)
                        
                        DispatchQueue.main.async {
                            completion(true, videoFileName)
                        }
                    } else {
                        print("no document in database")
                        DispatchQueue.main.async {
                            completion(false, "")
                        }
                    }
                }
                downloadTask.resume()
            }
        }
    }
    
    //MARK: - Audio
    class func uploadAudio(_ audioFileName: String, directory: String, completion: @escaping(_ audioLink: String?) -> Void) {
            
            let fileName = audioFileName + ".m4a"
            let storageRef = storage.reference(forURL: kFILEREFERANCE).child(directory)
            
            var task: StorageUploadTask!
        
        if fileExistsAtPath(path: fileName) {
            
            if let audioData = NSData(contentsOfFile: fileInDocumentsDirectory(fileName: fileName)) {
               
                task = storageRef.putData(audioData as Data, metadata: nil, completion: { (metadata, error) in
                    task.removeAllObservers()
                    ProgressHUD.dismiss()
                    
                    if let error = error {
                        print("Error uploading audio: \(error.localizedDescription)")
                        completion(nil)
                        return
                    }
                    
                    storageRef.downloadURL { (url, error) in
                        if let error = error {
                            print("Error getting download URL: \(error.localizedDescription)")
                            completion(nil)
                            return
                        }
                        
                        guard let downloadUrl = url else {
                            completion(nil)
                            return
                        }
                        
                        completion(downloadUrl.absoluteString)
                    }
                })
                
                task.observe(StorageTaskStatus.progress) { (snapshot) in
                    let progress = snapshot.progress!.completedUnitCount / snapshot.progress!.totalUnitCount
                    //ProgressHUD.showProgress(CGFloat(progress))
                }
            } else {
                print("nothing to upload (audio)")
            }
        }
    }
    
    //MARK: - Save Locally
    class func saveFileLocally(fileData: NSData, fileName: String) {
        
        let docUrl = getDocumentURL().appendingPathComponent(fileName, isDirectory: false)
        fileData.write(to: docUrl, atomically: true)
    }
    
}


//Helpers

func fileInDocumentsDirectory(fileName: String) -> String {
    return getDocumentURL().appendingPathComponent(fileName).path
}

func getDocumentURL() -> URL {
    return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last!
}

func fileExistsAtPath(path: String) -> Bool {
    return FileManager.default.fileExists(atPath: fileInDocumentsDirectory(fileName: path))
}
