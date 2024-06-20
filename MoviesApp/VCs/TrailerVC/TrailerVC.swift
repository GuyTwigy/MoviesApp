//
//  TrailerVC.swift
//  MoviesApp
//
//  Created by Guy Twig on 20/06/2024.
//

import UIKit
import WebKit

class TrailerVC: UIViewController {
    
    var videoKey: String?
    
    @IBOutlet weak var containerView: UIView!
    private var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView = WKWebView(frame: view.frame)
        view.addSubview(webView)
        
        if let videoKey = videoKey {
            loadVideo(with: videoKey)
        }
    }
    
    private func loadVideo(with key: String) {
        let urlString = "https://www.youtube.com/embed/\(key)"
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
}
