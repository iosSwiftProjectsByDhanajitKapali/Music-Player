//
//  Download.swift
//  Music Player
//
//  Created by unthinkable-mac-0025 on 02/07/21.
//

import Foundation


class Download {
  var isDownloading = false
  var progress: Float = 0
  var resumeData: Data?
  var task: URLSessionDownloadTask?
  var track: Track
  
  init(track: Track) {
    self.track = track
  }
}
