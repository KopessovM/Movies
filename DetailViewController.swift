//
//  DetailViewController.swift
//  Movies
//
//  Created by Madi Kupesov on 2/7/21.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {

    var movieID: Int = 0
    var movieTitle: String = ""
    var movieDescription: String = ""
    var favMovies: [String] = []
    
    lazy var webView: WKWebView = {
        let web = WKWebView()
        return web
    }()
    
    lazy var movieLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        return label
    }()
    
    lazy var lineBetweenTwoLabels: UIView = {
        let line = UIView()
        line.backgroundColor = .black
        return line
    }()
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.numberOfLines = 0
        return label
    }()
    
    lazy var favButton: UIButton = {
        let button = UIButton()
        
        button.addTarget(self, action: #selector(action), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = movieTitle
        navigationController?.navigationBar.tintColor = .black
        view.backgroundColor = .white
        movieLabel.text = movieTitle
        descriptionLabel.text = movieDescription
        setUpViews()
        getMoviesDetail()
        
        let rightBarButton = UIBarButtonItem(customView: favButton)
        self.navigationItem.rightBarButtonItem = rightBarButton
        
        favMovies = UserDefaults.standard.stringArray(forKey: "Movie") ?? []
        
        if favMovies.contains(movieTitle) {
            favButton.setBackgroundImage(UIImage(named: "star.filled"), for: .normal)
        }
        else {
            favButton.setBackgroundImage(UIImage(named: "star"), for: .normal)
        }
        
    }
    
    @objc func action() {
        favMovies.append(movieTitle)
        UserDefaults.standard.setValue(favMovies, forKey: "Movie")
        favButton.setBackgroundImage(UIImage(named: "star.filled"), for: .normal)
    }
    
    func getMoviesDetail() {
        let api_token = "d8452139f6c9d5bc8c79dba460df2c84"
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(self.movieID)/videos?api_key=\(api_token)")
        
        var request = URLRequest(url: url!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 60.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = ["cache-control" : "no-cache"]
        
        let session = URLSession.shared
        session.dataTask(with: request) {
            rowdata, response, error in
            
            if let error = error {
                print(#function, "Error", error.localizedDescription)
                return
            }
            
            guard let data = rowdata,
                  let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                    print(#function, "Error", "\(String(describing: rowdata))")
                    return
                }
            
            guard let trailersJSON = json["results"] as? [[String: Any]], let key = trailersJSON[0]["key"] as? String else { return }
            
            DispatchQueue.main.async() {
                self.playVideo(key)
            }
        }.resume()
    }
    
    func playVideo(_ key: String) {
        let url = URL(string: "https://www.youtube.com/embed/\(key)?playsinline=1?autoplay=1")
        let youtubeRequest = URLRequest(url: url!)
        self.webView.load(youtubeRequest)
    }
    
    func setUpViews() {
        [webView, movieLabel, lineBetweenTwoLabels, descriptionLabel, favButton].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        
        webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        webView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        webView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        webView.heightAnchor.constraint(equalToConstant: 250).isActive = true
        
        movieLabel.topAnchor.constraint(equalTo: webView.bottomAnchor, constant: 20).isActive = true
        movieLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        movieLabel.widthAnchor.constraint(equalToConstant: 375).isActive = true
        movieLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        lineBetweenTwoLabels.topAnchor.constraint(equalTo: movieLabel.bottomAnchor, constant: 20).isActive = true
        lineBetweenTwoLabels.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        lineBetweenTwoLabels.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        lineBetweenTwoLabels.heightAnchor.constraint(equalToConstant: 1).isActive = true
        lineBetweenTwoLabels.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        descriptionLabel.topAnchor.constraint(equalTo: movieLabel.bottomAnchor, constant: 40).isActive = true
        descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        descriptionLabel.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        favButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        favButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        favButton.widthAnchor.constraint(equalToConstant: 25).isActive = true
        favButton.heightAnchor.constraint(equalToConstant: 25).isActive = true

    }
    
}
