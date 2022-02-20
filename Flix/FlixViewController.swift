//
//  ViewController.swift
//  Flix
//
//  Created by Rutvij Shah on 2/20/22.
//

import UIKit
import AlamofireImage

class FlixViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var moviesTableView: UITableView!

    var movies = [[String: Any]]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // swiftlint:disable line_length
        moviesTableView.dataSource = self
        moviesTableView.delegate = self

        moviesTableView.rowHeight = 150

        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, _, error) in
             // This will run when the network request returns
             if let error = error {
                    print(error.localizedDescription)
             } else if let data = data {
                 // swiftlint:disable force_try force_cast
                 let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]

                 self.movies = dataDictionary["results"] as! [[String: Any]]
                 self.moviesTableView.reloadData()
             }
        }
        task.resume()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = moviesTableView.dequeueReusableCell(withIdentifier: "MoviesCell") as! MoviesCell

        let movie = movies[indexPath.row]

        let title = movie["title"] as! String
        cell.titleLabel.text = title

        let synopsis = movie["overview"] as! String
        cell.synopsisLabel.text = synopsis

        let baseUrl = "https://image.tmdb.org/t/p/w780"
        let posterPath = movie["poster_path"] as! String
        let posterUrl = URL(string: baseUrl + posterPath)
        cell.posterView.af.setImage(withURL: posterUrl!)

        return cell
    }

}
