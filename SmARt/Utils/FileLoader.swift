//
//  FileLoader.swift
//  SmARt
//
//  Created by MacBook on 11.03.21.
//

import Foundation
import Combine
import Alamofire

class FileLoader: NSObject, URLSessionDownloadDelegate {
    private var taskProgresses: [String: Float] = [:]
    private var urlSession: URLSession?
    private var files: [String: FileProtocol] = [:]
    private var lock = NSLock()
    
    var progress = PassthroughSubject<Float, Never>()
    
    override init() {
        super.init()
        
        let config = URLSessionConfiguration.background(withIdentifier: "\(Bundle.main.bundleIdentifier!).background")
        config.timeoutIntervalForRequest = 1000
        config.timeoutIntervalForResource = 1000
        config.allowsCellularAccess = true
        urlSession = URLSession(configuration: config, delegate: self, delegateQueue: OperationQueue())
    }
    
    func stopAllOperations() {
        urlSession?.invalidateAndCancel()
    }
    
    private func download(file: FileProtocol) {
        guard let url = URL(string: file.url),
              let task = urlSession?.downloadTask(with: URLRequest(url: url)) else { return }
        taskProgresses[url.absoluteString] = 0
        files[url.absoluteString] = file
        task.resume()
    }
    
    func download(files: [FileProtocol]) {
        files.forEach(download)
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        if totalBytesExpectedToWrite > 0, let url = downloadTask.originalRequest?.url?.absoluteString {
            let progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
            refreshProgress(url, progress)
        }
    }

    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        if let dataFromURL = try? Data(contentsOf: location),
           let file = files[downloadTask.originalRequest?.url?.absoluteString ?? .empty] {
            try? dataFromURL.write(to: URL.constructFilePath(withName: file.nameWithExtension))
            refreshProgress(file.url, 1)
        }
    }

    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {}
    
    func refreshProgress(_ url: String, _ progressForTask: Float) {
        lock.lock()
        taskProgresses[url] = progressForTask
        let taskProgressesCount = Float(taskProgresses.values.count == 0 ? 1 : taskProgresses.values.count)
        let progress = Float(taskProgresses.values.reduce(0, +)) / taskProgressesCount
        progress > Constants.completeProgressValue
            ? self.progress.send(completion: .finished)
            : self.progress.send(progress)
        lock.unlock()
    }
    
    func urlSession(_ session: URLSession, taskIsWaitingForConnectivity task: URLSessionTask) {}
}
