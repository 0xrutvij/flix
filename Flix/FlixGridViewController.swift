//
//  FlixGridViewController.swift
//  Flix
//
//  Created by Rutvij Shah on 2/27/22.
//

import UIKit
import AlamofireImage

class FlixGridViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    var movies = [[String: Any]]()

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        collectionView.dataSource = self

        // swiftlint:disable force_try force_cast line_length
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout

        // WW: 297762
        let similarTo = 634649

        layout.minimumLineSpacing = 4
        layout.minimumInteritemSpacing = 4

        let width = (view.frame.size.width - layout.minimumInteritemSpacing * 2) / 3
        layout.itemSize = CGSize(width: width, height: width * 1.5)

        let url = URL(string: "https://api.themoviedb.org/3/movie/\(similarTo)/similar?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, _, error) in
             // This will run when the network request returns
             if let error = error {
                    print(error.localizedDescription)
             } else if let data = data {

                 let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                 self.movies = dataDictionary["results"] as! [[String: Any]]
                 self.collectionView.reloadData()
             }
        }
        task.resume()

        // Do any additional setup after loading the view.
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FlixGridCell", for: indexPath) as! FlixGridCell

        let movie = movies[indexPath.item]
        let baseUrl = "https://image.tmdb.org/t/p/original"

        // swiftlint:disable force_cast
        let posterPath = movie["poster_path"] as! String
        let posterUrl = URL(string: baseUrl + posterPath)
        cell.posterView.af.setImage(withURL: posterUrl!)

        return cell
    }

    /*
    // MARK: - Navigation
     */
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Find the selected movie
        let cell = sender as! UICollectionViewCell
        let indexPath = collectionView.indexPath(for: cell)!
        let movie = movies[indexPath.item]

        // Pass the selected movie to the details view controller
        let detailsViewController = segue.destination as! FlixDetailsViewController
        detailsViewController.movie = movie
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}
