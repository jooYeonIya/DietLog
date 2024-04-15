//  BaseUIViewController.swift
//  DiegLog
//
//  Created by Jooyeon Kang on 2024/04/04.
//

import Alamofire
import Foundation
import RealmSwift

enum YoutubeAPI {
    static let URL: String = "https://youtube.googleapis.com/youtube/v3/"
    static let key: String = "AIzaSyA1uvssw0V5bvimj5fS3N7SjTW_8qaR-Dg"
}

class YoutubeAPIManager {
    static let shared = YoutubeAPIManager()
    private init() {}
    
    func saveExercise(with url: String, categoryID: ObjectId, completion: @escaping () -> Void) {
        let exercise = Exercise()
        exercise.URL = url
        exercise.categoryID = categoryID
        
        let videoId = extractVideoId(from: url)
        getVideoInfo(for: exercise, from: videoId) {
            Exercise.addExercise(exercise)
            completion()
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
    
    func getVideoInfo(for exercise: Exercise, from videoId: String, completion: @escaping () -> Void) {

        let url = YoutubeAPI.URL + "videos"
        let parameters = [
            "id": videoId,
            "part": "snippet",
            "regionCode": "KR",
            "key": YoutubeAPI.key,
        ]
        
        AF.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default)
            .response { response in
                switch response.result {
                case .success(_):
                    if let data = response.data,
                       let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                       let items = json["items"] as? [[String: Any]] {
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
}
