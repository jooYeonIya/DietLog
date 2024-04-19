//
//  WebViewController.swift
//  DiegLog
//
//  Created by Jooyeon Kang on 2024/04/17.
//

import UIKit
import WebKit

class WebViewController: BaseUIViewController {
    private lazy var wkWebView = WKWebView()

    private let youtubeURL: String?
        
    init(youtubeURL: String) {
        self.youtubeURL = youtubeURL
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let youtubeURL = URL(string: youtubeURL ?? "https://www.youtube.com/") {
            let request = URLRequest(url: youtubeURL)
            wkWebView.load(request)
        }
    }
    
    override func setUI() {
        view.addSubview(wkWebView)
    }
    
    override func setLayout() {
        wkWebView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
