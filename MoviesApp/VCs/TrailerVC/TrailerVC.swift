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
    
    @IBOutlet weak var containerView: UIView!
    private var webView: WKWebView!
    
    @IBOutlet weak var loader: UIActivityIndicatorView! {
        didSet {
            loader.startAnimating()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        vm?.delegate = self
        vm?.loadVideo()
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
            self.loader.stopAnimating()
        }
    }
}
