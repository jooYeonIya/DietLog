//  BaseUIViewController.swift
//  DiegLog
//
//  Created by Jooyeon Kang on 2024/04/04.
//

import Alamofire
import Foundation
import RealmSwift
import UIKit

enum YoutubeAPI {
    static let URL: String = "https://youtube.googleapis.com/youtube/v3/"
}

class YoutubeAPIManager {
    static let shared = YoutubeAPIManager()
    private init() {}
    
    func saveExercise(with url: String, categoryID: ObjectId) {
        let exercise = Exercise()
        exercise.URL = url
        exercise.categoryID = categoryID
        
        let videoId = extractVideoId(from: url)
        
        getVideoInfo(for: exercise, from: videoId) {
            Exercise.addExercise(exercise)
        }
    }
    
    func extractVideoId(from url: String) -> String {
        
        guard let url = URL(string: url) else { return "" }
        
        if let host = url.host, host.contains("youtu.be") {
            return url.lastPathComponent
        } else {
            if let item = URLComponents(url: url, resolvingAgainstBaseURL: true)?.queryItems {
                for i in item  {
                    if i.name == "v" {
                        return i.value ?? ""
                    }
                }
            }
        }
        
        return ""
    }
    
    func getYoutubeAPIKeyFromInfoPlist() -> String? {
        return Bundle.main.object(forInfoDictionaryKey: "YoutubeAPIKey") as? String
    }
    
    func getVideoInfo(for exercise: Exercise, from videoId: String, completion: @escaping () -> Void) {
        
        guard let key = getYoutubeAPIKeyFromInfoPlist() else { return }

        let url = YoutubeAPI.URL + "videos"
        let parameters = [
            "id": videoId,
            "part": "snippet",
            "regionCode": "KR",
            "key": key,
        ]
        
        AF.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default)
            .response { response in
                switch response.result {
                case .success(_):
                    if let data = response.data,
                       let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                       let items = json["items"] as? [[String: Any]] {
                        print("Data received: \(items.count) items found")

                        for item in items {
                            if let snippet = item["snippet"] as? [String: Any],
                               let title = snippet["title"] as? String,
                               let thumbnails = snippet["thumbnails"] as? [String: Any],
                               let defaultThumbnail = thumbnails["default"] as? [String: Any],
                               let thumbnailUrl = defaultThumbnail["url"] as? String {
                                exercise.title = title
                                exercise.thumbnailURL = thumbnailUrl
                                
                                completion()
                            }
                        }
                    }

                case .failure(let error):
                    print("Error \(error)")
                }
            }
    }
    
    func getThumbnailImage(with url: String, completion: @escaping (UIImage?) -> Void) {
        AF.request(url).responseData { response in
            switch response.result {
            case .success(let data):
                let image = UIImage(data: data)
                completion(image)
            case .failure(let error):
                print("Error in getThumbnailImage(with url: String): \(error)")
                completion(nil)
            }
        }
    }
}
