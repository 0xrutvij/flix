//
//  FlixPreviewViewController.swift
//  Flix
//
//  Created by Rutvij Shah on 2/27/22.
//

import UIKit
import WebKit

class FlixPreviewViewController: UIViewController {

    // swiftlint:disable force_cast
    var previews = [[String: Any]]()

    var ytUrl = ""

    @IBOutlet weak var webTab: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        var key = ""

        for preview in previews {

            if preview["type"] as! String == "Trailer" && preview["site"] as! String == "YouTube" {
                key = preview["key"] as! String
            }
        }

        self.ytUrl = "https://www.youtube.com/watch?v=\(key)"
        let url = URL(string: self.ytUrl)!
        let req = URLRequest(url: url)
        webTab.load(req)
    }

    @IBAction func backAction() {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func launchExternalApp(_ sender: UIButton) {
        UIApplication.shared.open(NSURL(string: self.ytUrl)! as URL)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
