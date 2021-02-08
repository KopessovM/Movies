//
//  MoviesTableViewCell.swift
//  Movies
//
//  Created by Madi Kupesov on 2/6/21.
//

import UIKit

class MoviesTableViewCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    lazy var movieImage: UIImageView = {
        let movie = UIImageView()
        movie.layer.cornerRadius = 10
        movie.clipsToBounds = true
        return movie
    }()
    
    lazy var movieTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .black
        return label
    }()
    
    lazy var dateOfRealease: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .gray
        return label
    }()
    
    func setUpViews() {
        [movieImage, movieTitle, dateOfRealease].forEach {
            self.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        movieImage.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        movieImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        movieImage.widthAnchor.constraint(equalToConstant: 100).isActive = true
        movieImage.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        movieTitle.leadingAnchor.constraint(equalTo: movieImage.trailingAnchor, constant: 20).isActive = true
        movieTitle.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        movieTitle.widthAnchor.constraint(equalToConstant: 250).isActive = true
        
        dateOfRealease.leadingAnchor.constraint(equalTo: movieImage.trailingAnchor, constant: 20).isActive = true
        dateOfRealease.topAnchor.constraint(equalTo: movieTitle.bottomAnchor, constant: 10).isActive = true
        dateOfRealease.widthAnchor.constraint(equalToConstant: 250).isActive = true
    }
}
