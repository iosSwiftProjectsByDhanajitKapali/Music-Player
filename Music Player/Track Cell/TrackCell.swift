//
//  TrackCell.swift
//  Music Player
//
//  Created by unthinkable-mac-0025 on 02/07/21.
//

import UIKit

protocol TrackCellDelegate {
  func cancelTapped(_ cell: TrackCell)
  func downloadTapped(_ cell: TrackCell)
  func pauseTapped(_ cell: TrackCell)
  func resumeTapped(_ cell: TrackCell)
}

class TrackCell: UITableViewCell {

    var delegate: TrackCellDelegate?
    static let identifier = "TrackCell"
    
    @IBOutlet var containerView: UIView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var artistLabel: UILabel!
    @IBOutlet var progressLabel: UILabel!
    @IBOutlet var progressView: UIProgressView!
    @IBOutlet var cancelButton: UIButton!
    @IBOutlet var pauseButton: UIButton!
    @IBOutlet var downloadButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func cancelTapped(_ sender: AnyObject) {
      delegate?.cancelTapped(self)
    }
    
    @IBAction func downloadTapped(_ sender: AnyObject) {
      delegate?.downloadTapped(self)
    }
    
    @IBAction func pauseOrResumeTapped(_ sender: AnyObject) {
      if(pauseButton.titleLabel?.text == "Pause") {
        delegate?.pauseTapped(self)
      } else {
        delegate?.resumeTapped(self)
      }
    }
    
    func configure(track: Track, downloaded: Bool, download: Download?) {
      titleLabel.text = track.name
      artistLabel.text = track.artist
      
      // Show/hide download controls Pause/Resume, Cancel buttons, progress info.
      var showDownloadControls = false
      
      // Non-nil Download object means a download is in progress.
      if let download = download {
        showDownloadControls = true
        let title = download.isDownloading ? "Pause" : "Resume"
        pauseButton.setTitle(title, for: .normal)
        progressLabel.text = download.isDownloading ? "Downloading..." : "Paused"
      }
      pauseButton.isHidden = !showDownloadControls
      cancelButton.isHidden = !showDownloadControls
      progressView.isHidden = !showDownloadControls
      progressLabel.isHidden = !showDownloadControls
      
      // If the track is already downloaded, enable cell selection and hide the Download button.
      selectionStyle = downloaded ? UITableViewCell.SelectionStyle.gray : UITableViewCell.SelectionStyle.none
      downloadButton.isHidden = downloaded || showDownloadControls

    }
    
    /// Function to update the progress bar
    func updateDisplay(progress: Float, totalSize : String) {
      progressView.progress = progress
      progressLabel.text = String(format: "%.1f%% of %@", progress * 100, totalSize)
    }
}
