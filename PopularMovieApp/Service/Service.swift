//
//  Service.swift
//  PopularMovieApp
//
//  Created by Yusuf Eren Bulam on 21.05.2023.
//

import Foundation

//https://api.themoviedb.org/3/movie/popular?api_key=4e0be2c22f7268edffde97481d49064a&language=en-US&page=1

class Service {
    
    private var datakTask: URLSessionDataTask?
    
    func getPopularMoviesData(completion: @escaping (Result<MoviesData,Error>) -> Void) {
        
        let popularMoviesURL = "https://api.themoviedb.org/3/movie/popular?api_key=4e0be2c22f7268edffde97481d49064a&language=en-US&page=1"
        
        guard let url = URL(string: popularMoviesURL) else { return }
        
        datakTask = URLSession.shared.dataTask(with: url, completionHandler: { data, response, error in
            
            if let error = error {
                completion(.failure(error))
                print("DataTask error: \(error.localizedDescription)")
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                print("Empty Response")
                return
            }
            print("Response status code:\(response.statusCode)")
            
            guard let data = data else {
             print("Empty Data")
                return
            }

            do {
                // Parse to Data
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(MoviesData.self, from: data)
                
                //Back to the main thread
                DispatchQueue.main.async {
                    completion(.success(jsonData))
                }
            } catch let error {
                completion(.failure(error))
            }
        })
        datakTask?.resume()
    }
    
    
    // 
}
