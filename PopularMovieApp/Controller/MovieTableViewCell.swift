//
//  MovieTableViewCell.swift
//  PopularMovieApp
//
//  Created by Yusuf Eren Bulam on 21.05.2023.
//

import UIKit

class MovieTableViewCell: UITableViewCell {

    @IBOutlet weak var MoviePoster: UIImageView!
    @IBOutlet weak var MovieTitle: UILabel!
    @IBOutlet weak var MovieYear: UILabel!
    @IBOutlet weak var MovieOverview: UILabel!
    @IBOutlet weak var MovieRate: UILabel!
    
    private var urlString = ""
    
    func setCellWithValuesOf(_ movie: Movie) {
        updateUI(title: movie.title, releaseData: movie.year, rating: movie.rate, overview: movie.overview, poster: movie.posterImage)
    }
    
    private func updateUI(title:String?,releaseData:String?,rating:Double?,overview:String?,poster:String?) {
        
        self.MovieTitle.text = title
        self.MovieYear.text = convertDateFormater(releaseData)
        guard let rate = rating else { return }
        self.MovieRate.text = String(rate)
        self.MovieOverview.text = overview
        
        guard let posterString = poster else { return }
        urlString = "https://image.tmdb.org/t/p/w300" + posterString
        
        guard let posterImageURL = URL(string: urlString) else {
            self.MoviePoster.image = UIImage(named: "noImageAvailable")
            return
        }
        
        self.MoviePoster.image = nil
        
        getImageDataFrom(url: posterImageURL)
        
    }
    
    // MARK: - Get image data
    
    private func getImageDataFrom(url:URL) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("DataTask error:\(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("Empty Data")
                return
            }
            
            DispatchQueue.main.async {
                if let image = UIImage(data: data) {
                    self.MoviePoster.image = image
                }
            }
        }.resume()
    }
    
    // MARK: - Convert date format
    func convertDateFormater(_ date: String?) -> String {
        var fixDate = ""
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let originalDate = date {
            if let newDate = dateFormatter.date(from: originalDate) {
                dateFormatter.dateFormat = "dd.MM.yyyy"
                fixDate = dateFormatter.string(from: newDate)
            }
        }
        return fixDate
    }
}
