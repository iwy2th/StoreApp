//
//  DetailViewController.swift
//  StoreSearch
//
//  Created by Iwy2th on 01/07/2023.
//

import UIKit

class DetailViewController: UIViewController {
  @IBOutlet weak var artworkImageView: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var artistNameLabel: UILabel!
  @IBOutlet weak var kindLabel: UILabel!
  @IBOutlet weak var genreLabel: UILabel!
  @IBOutlet weak var priceButton: UIButton!
  @IBOutlet weak var popupView: UIView!
  @IBOutlet weak var closeButton: UIButton!
  var searchResult: SearchResult!
  var downloadTask: URLSessionDownloadTask?
  deinit {
    print("deinit \(self)")
    downloadTask?.cancel()
  }
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    transitioningDelegate = self
  }
  // MARK: - ViewDidLoad
  override func viewDidLoad() {
    super.viewDidLoad()
    // rounded corner views
    closeButton.setTitle("", for: .normal)
    popupView.layer.cornerRadius = 10
    let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(close))
    gestureRecognizer.cancelsTouchesInView = false
    gestureRecognizer.delegate = self
    view.addGestureRecognizer(gestureRecognizer)
    // Update Label
    if searchResult != nil {
      updateUI()
    }
    // Gradient view
    view.backgroundColor = UIColor.clear
    let dimmingView = GradientView(frame: CGRect.zero)
    dimmingView.frame = view.bounds
    view.insertSubview(dimmingView, at: 0)
  }
  @IBAction func close(_ sender: Any) {
    dismiss(animated: true)
  }
  @IBAction func openInStore() {
    if let url = URL(string: searchResult.storeURL) {
      UIApplication.shared.open(url, options: [:])
    }
  }
  // MARK: - Helper Methods
  func updateUI() {
    nameLabel.text = searchResult.name
    if searchResult.artist.isEmpty {
      artistNameLabel.text = "Unknown"
    } else {
      artistNameLabel.text = searchResult.artist
    }
    kindLabel.text = searchResult.type
    genreLabel.text = searchResult.genre
    // show price
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    formatter.currencyCode = searchResult.currency
    let priceText: String
    if searchResult.price == 0 {
      priceText = "Free"
    } else if let text = formatter.string(from: searchResult.price as NSNumber) {
      priceText = text
    } else {
      priceText = ""
    }
    priceButton.setTitle(priceText, for: .normal)
    // get image
    if let largeURL = URL(string: searchResult.imageLarge) {
      downloadTask = artworkImageView.loadImage(url: largeURL)
    }
  }

}
// MARK: - Extension Gesture recognizer
extension DetailViewController: UIGestureRecognizerDelegate {
  func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
    return (touch.view === self.view)
  }
}
// MARK: - Extension Animation
extension DetailViewController: UIViewControllerTransitioningDelegate {
  func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return BounceAnimationController()
  }
  func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return SlideOutAnimationController() 
  }

}
