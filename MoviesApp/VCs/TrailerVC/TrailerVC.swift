//
//  TrailerVC.swift
//  MoviesApp
//
//  Created by Guy Twig on 20/06/2024.
//

import UIKit
import WebKit

class TrailerVC: UIViewController {
    
    var vm: TrailerVM?
    var videoKey: String?
    
    @IBOutlet weak var containerView: UIView!
    private var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        vm = TrailerVM()
        vm?.delegate = self
        if let videoKey {
            vm?.loadVideo(key: videoKey)
        }
        webView = WKWebView(frame: containerView.frame)
        containerView.addSubview(webView)
    }
}

extension TrailerVC: TrailerVMDelegate {
    func showVideo(request: URLRequest?) {
        DispatchQueue.main.async { [weak self] in
            guard let self else {
                return
            }
            
            if let request {
                webView.load(request)
            } else {
                self.showAlert(title: "Fail To Present Trailer", message: "")
            }
        }
    }
}
