//
//  FlixDetailsViewController.swift
//  Flix
//
//  Created by Rutvij Shah on 2/26/22.
//

import UIKit

class FlixDetailsViewController: UIViewController {

    @IBOutlet weak var movieBackdrop: UIImageView!
    @IBOutlet weak var moviePoster: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieReleaseDate: UILabel!
    @IBOutlet weak var movieSynopsis: UILabel!

    var movie: [String: Any]!
    var previews = [[String: Any]]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        movieTitle.text = movie["title"] as? String

        movieReleaseDate.text = movie["release_date"] as? String

        movieSynopsis.text = movie["overview"] as? String
        // set the poster and backdrop
        setImages()

        // pre-load previews
        loadPreviews()

        // set tap gesture recognizer
        let tapGestureRecog = UITapGestureRecognizer(target: self, action: #selector(userDidTap(sender:)))

        tapGestureRecog.numberOfTapsRequired = 1

        moviePoster.isUserInteractionEnabled = true
        moviePoster.addGestureRecognizer(tapGestureRecog)

    }

    private func setImages() {

        let baseUrl = "https://image.tmdb.org/t/p/original"
        // swiftlint:disable force_cast
        let posterPath = movie["poster_path"] as! String
        let posterUrl = URL(string: baseUrl + posterPath)
        moviePoster.af.setImage(withURL: posterUrl!)

        let backdropPath = movie["backdrop_path"] as! String
        let backdropUrl = URL(string: baseUrl + backdropPath)
        movieBackdrop.af.setImage(withURL: backdropUrl!)

    }

    private func loadPreviews() {
        let movieId = self.movie["id"]

        // swiftlint:disable force_try force_cast line_length
        let urlString = "https://api.themoviedb.org/3/movie/\(movieId as! Int)/videos?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = URL(string: urlString)!

        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)

        let task = session.dataTask(with: request) { (data, _, error) in
             // This will run when the network request returns
             if let error = error {
                    print(error.localizedDescription)
             } else if let data = data {

                 let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                 self.previews = dataDictionary["results"] as! [[String: Any]]
             }
        }

        task.resume()
    }

    @objc func userDidTap(sender: UITapGestureRecognizer) {
        if !previews.isEmpty {
            performSegue(withIdentifier: "flixPreviewSegue", sender: nil)
        }
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        let flixPreviewViewController = segue.destination as! FlixPreviewViewController
        flixPreviewViewController.previews = self.previews

    }

}
