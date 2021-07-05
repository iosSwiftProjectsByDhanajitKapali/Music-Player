//
//  ViewController.swift
//  Music Player
//
//  Created by unthinkable-mac-0025 on 02/07/21.
//

import UIKit

import AVFoundation
import AVKit
import UIKit

class SearchViewController: UIViewController {
  //
  // MARK: - Constants
  //
  
  /// Get local file path: download task stores tune here; AV player plays it.
  let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
  
  let downloadService = DownloadService()
  let queryService = QueryService()
  
  //
  // MARK: - IBOutlets
  //
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var searchBar: UISearchBar!
  
  //
  // MARK: - Variables And Properties
  //
  lazy var downloadsSession: URLSession = {
    //let configuration = URLSessionConfiguration.default
    let configuration =
      URLSessionConfiguration.background(withIdentifier:
                                           "com.dhanajitkapali.Music-Player")

    return URLSession(configuration: configuration,
                      delegate: self,
                      delegateQueue: nil)
  }()

  
  var searchResults: [Track] = []
  
  lazy var tapRecognizer: UITapGestureRecognizer = {
    var recognizer = UITapGestureRecognizer(target:self, action: #selector(dismissKeyboard))
    return recognizer
  }()
  
  //MARK: -
  @objc func dismissKeyboard() {
    searchBar.resignFirstResponder()
  }
  
    ///Function to get the path to documents folder
  func localFilePath(for url: URL) -> URL {
    return documentsPath.appendingPathComponent(url.lastPathComponent)
  }
  
  ///Function to play the Downloaded Track
  func playDownload(_ track: Track) {
    let playerViewController = AVPlayerViewController()
    present(playerViewController, animated: true, completion: nil)
    
    //get the track from Documents folder, According to the URl of song
    let url = localFilePath(for: track.previewURL)
    let player = AVPlayer(url: url)
    playerViewController.player = player
    player.play()
  }
  
  func position(for bar: UIBarPositioning) -> UIBarPosition {
    return .topAttached
  }
  
  func reload(_ row: Int) {
    tableView.reloadRows(at: [IndexPath(row: row, section: 0)], with: .none)
  }
  
  //
  // MARK: - View Controller
  //
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.tableFooterView = UIView()
    
    //Initiate the shared downloadSession
    downloadService.downloadsSession = downloadsSession

    //register the cell in the tableView and set its delegate and datasource
    tableView.register(UINib(nibName: "TrackCell", bundle: nil), forCellReuseIdentifier: TrackCell.identifier)
    tableView.delegate = self
    tableView.dataSource = self
  }
    @IBAction func searchButtonPressed(_ sender: UIButton) {
        dismissKeyboard()
        
        guard let searchText = searchBar.text, !searchText.isEmpty else {
          return
        }
        
        //UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        queryService.getSearchResults(searchTerm: searchText) { [weak self] results, errorMessage in
          //UIApplication.shared.isNetworkActivityIndicatorVisible = false
          
          if let results = results {
            self?.searchResults = results
            self?.tableView.reloadData()
            self?.tableView.setContentOffset(CGPoint.zero, animated: false)
          }
          
          if !errorMessage.isEmpty {
            print("Search error: " + errorMessage)
          }
        }
    }
    
}

//
// MARK: - Search Bar Delegate
//
extension SearchViewController: UISearchBarDelegate {
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    dismissKeyboard()
    
    guard let searchText = searchBar.text, !searchText.isEmpty else {
      return
    }
    
    //UIApplication.shared.isNetworkActivityIndicatorVisible = true
    
    queryService.getSearchResults(searchTerm: searchText) { [weak self] results, errorMessage in
      //UIApplication.shared.isNetworkActivityIndicatorVisible = false
      
      if let results = results {
        self?.searchResults = results
        self?.tableView.reloadData()
        self?.tableView.setContentOffset(CGPoint.zero, animated: false)
      }
      
      if !errorMessage.isEmpty {
        print("Search error: " + errorMessage)
      }
    }
  }
  
  func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    view.addGestureRecognizer(tapRecognizer)
  }
  
  func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
    view.removeGestureRecognizer(tapRecognizer)
  }
}

//
// MARK: - Table View Data Source
//
extension SearchViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell: TrackCell = tableView.dequeueReusableCell(withIdentifier: TrackCell.identifier, for: indexPath) as! TrackCell
    //setting the delegate of cell
    cell.delegate = self
    
    let track = searchResults[indexPath.row]
    
    //update the UI of TableView cell
    cell.configure(track: track, downloaded: track.downloaded, download: downloadService.activeDownloads[track.previewURL])

    
    return cell
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return searchResults.count
  }
}

//
// MARK: - Table View Delegate
//
extension SearchViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //When user taps cell, play the local file, if it's downloaded.
    
    let track = searchResults[indexPath.row]
    
    if track.downloaded {
      playDownload(track)
    }
    
    tableView.deselectRow(at: indexPath, animated: true)
  }

}

// MARK: - Track Cell Delegate
extension SearchViewController: TrackCellDelegate {
  func cancelTapped(_ cell: TrackCell) {
    if let indexPath = tableView.indexPath(for: cell) {
      let track = searchResults[indexPath.row]
      downloadService.cancelDownload(track)
      reload(indexPath.row)
    }
  }
  
  func downloadTapped(_ cell: TrackCell) {
    if let indexPath = tableView.indexPath(for: cell) {
      let track = searchResults[indexPath.row]
      downloadService.startDownload(track)
      reload(indexPath.row)
    }
  }
  
  func pauseTapped(_ cell: TrackCell) {
    if let indexPath = tableView.indexPath(for: cell) {
      let track = searchResults[indexPath.row]
      downloadService.pauseDownload(track)
      reload(indexPath.row)
    }
  }
  
  func resumeTapped(_ cell: TrackCell) {
    if let indexPath = tableView.indexPath(for: cell) {
      let track = searchResults[indexPath.row]
      downloadService.resumeDownload(track)
      reload(indexPath.row)
    }
  }
}


//MARK: - URLSessionDelegate

///Function to Manange Download the download when app is not in memory
//extension SearchViewController: URLSessionDelegate {
//  func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
//    DispatchQueue.main.async {
//      if let appDelegate = UIApplication.shared.delegate as? AppDelegate,
//        let completionHandler = appDelegate.backgroundSessionCompletionHandler {
//        appDelegate.backgroundSessionCompletionHandler = nil
//
//        completionHandler()
//      }
//    }
//  }
//}


//MARK: - URLSessionDownloadDelegate Functions
extension SearchViewController: URLSessionDownloadDelegate {
  func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask,
                  didFinishDownloadingTo location: URL) {
    //print("Finished downloading to \(location).")
    
    //get the original url
    guard let sourceURL = downloadTask.originalRequest?.url else {
      return
    }
    
    //remove the download from the activeDownloads[]
    let download = downloadService.activeDownloads[sourceURL]
    downloadService.activeDownloads[sourceURL] = nil
    //get the destination path, i.e., Documents file of the app
    let destinationURL = localFilePath(for: sourceURL)
    print(destinationURL)
    //remove any file from documents with same name
    let fileManager = FileManager.default
    try? fileManager.removeItem(at: destinationURL)
    
    //copy the downloaded track to the Documents folder
    do {
      try fileManager.copyItem(at: location, to: destinationURL)
      download?.track.downloaded = true
    } catch let error {
      print("Could not copy file to disk: \(error.localizedDescription)")
    }
    //get the index of the downloaded track, to update its UI in the tableView
    if let index = download?.track.index {
      print("the index is -> \(index)")
      //print("the index is -> \(download?.track.name)")
      DispatchQueue.main.async { [weak self] in
        self?.tableView.reloadRows(at: [IndexPath(row: index, section: 0)],
                                   with: .none)
      }
    }

  }
  
  func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
    
    //get the original url of the download, and then get the download according to the url
    guard
      let url = downloadTask.originalRequest?.url,
      let download = downloadService.activeDownloads[url]
      else {
        return
    }
    //calculate the progress
    download.progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
    let totalSize = ByteCountFormatter.string(fromByteCount: totalBytesExpectedToWrite, countStyle: .file)
    
    //update the progress bar for the current downloading song
    DispatchQueue.main.async {
      if let trackCell =
        self.tableView.cellForRow(at: IndexPath(row: download.track.index, section: 0)) as? TrackCell {
        trackCell.updateDisplay(progress: download.progress, totalSize: totalSize)
      }
    }
  }

}
