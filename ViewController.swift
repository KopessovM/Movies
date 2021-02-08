//
//  ViewController.swift
//  Movies
//
//  Created by Madi Kupesov on 2/6/21.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var movies: [Movie] = []
    
    lazy var myTableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(MoviesTableViewCell.self, forCellReuseIdentifier: "mycell")
        return tableView
    }()
    
    lazy var favButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "favorites"), for: .normal)
        button.addTarget(self, action: #selector(action), for: .touchUpInside)
        return button
    }()
    
    lazy var indicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.style = .large
        return indicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Movies"
        getMovies()
        setUpViews()
        let alert = UIAlertController(title: "Alert", message: "Message", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertAction.Style.default, handler: nil))
        if movies.isEmpty == false {
            self.present(alert, animated: true, completion: nil)
        }
        let rightBarButton = UIBarButtonItem(customView: favButton)
        self.navigationItem.rightBarButtonItem = rightBarButton
    }

    @objc func action() {
        let fvc = FavoriteTableViewController()
        self.navigationController?.pushViewController(fvc, animated: true)
    }
    
    func getMovies() {
        let api_token = "d8452139f6c9d5bc8c79dba460df2c84"
        let url = URL(string: "https://api.themoviedb.org/4/list/1?api_key=\(api_token)")
        self.indicator.startAnimating()
        var request = URLRequest(url: url!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 60.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = ["cache-control" : "no-cache"]
        
        self.indicator.stopAnimating()
        
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
            
            guard let moviesJSON = json["results"] as? [[String: Any]] else {
                return
            }
            
            for movie in moviesJSON {
                do {
                    let parsedMovie = try Movie(json: movie)
                    self.movies.append(parsedMovie)
                    print(self.movies)
                }
                catch {
                    print("Error")
                }
            }
            
            DispatchQueue.main.async() {
                self.myTableView.reloadData()
            }
        }.resume()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = myTableView.dequeueReusableCell(withIdentifier: "mycell") as! MoviesTableViewCell
        cell.movieTitle.text = movies[indexPath.row].name
        cell.dateOfRealease.text = movies[indexPath.row].date
        
        let poster_path = URL(string: "https://image.tmdb.org/t/p/w500" + self.movies[indexPath.row].posterPath)
        
        var task: URLSessionTask? = nil
        if let url = poster_path {
            task = URLSession.shared.dataTask(with: url, completionHandler: {
                data, response, error in
                if data != nil {
                    var image: UIImage? = nil
                    if let data = data {
                        image = UIImage(data: data)
                    }
                    if image != nil {
                        DispatchQueue.main.async(execute: {
                            let updateCell = tableView.cellForRow(at: indexPath) as? MoviesTableViewCell
                            if updateCell != nil {
                                updateCell?.movieImage.image = image
                            }
                        })
                    }
                }
            })
        }
        task?.resume()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        let dvc = DetailViewController()
        self.navigationController?.pushViewController(dvc, animated: true)
        
        dvc.movieTitle = movies[indexPath.row].name
        dvc.movieID = movies[indexPath.row].id
        dvc.movieDescription = movies[indexPath.row].overview
    }
    
    func setUpViews() {
        view.addSubview(myTableView)
        view.addSubview(favButton)
        view.addSubview(indicator)
        myTableView.translatesAutoresizingMaskIntoConstraints = false
        favButton.translatesAutoresizingMaskIntoConstraints = false
        indicator.translatesAutoresizingMaskIntoConstraints = false
        
        myTableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        myTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        myTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        myTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        favButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        favButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        favButton.widthAnchor.constraint(equalToConstant: 25).isActive = true
        favButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        indicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        indicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
    }

}

