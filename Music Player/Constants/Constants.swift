//
//  Constants.swift
//  Music Player
//
//  Created by unthinkable-mac-0025 on 05/07/21.
//

import Foundation


import UIKit

struct K {
    struct StoryBoardID {
        static let MAIN = "Main"
    }
    struct SceneID {

    }
    
    struct SegueID{
        
    }
    
    struct XibWithName {
        static let TRACK_CELL = "TrackCell"
    }
    
    struct TableViewCellID {
        static let TRACK_CELL_ID = "TrackCell"
    }
    
    struct Image {
        struct AssetImage{
           
        }
       
        struct SystemImage {
            
        }
    }
    
    struct Title {
        struct ButtonTitle {
            static let PAUSE = "Pause"
            static let RESUME = "Resume"
        }
        struct TabBarItem {
            
        }
        
      
    }
    
    struct URLString{
        struct BaseURL{
            static let ITUNES = "https://itunes.apple.com/search"
        }
        struct QueryURL {
            static let ITUNES = "media=music&entity=song&term="
        }
    }
    
    struct StringFormatter {
        static let TRACK_PROGRESS_LABEL = "%.1f%% of %@"
    }
    
    struct TextMessage {
        static let DOWNLOADING = "Downloading..."
        static let PAUSED = "Paused"
        static let ERROR = "Error"
        static let DISMISS = "Dismiss"
        static let ALERT = "Alert"
        

    }
    
    struct ErrorMessage {
        static let SEARCH_ERROR = "Search error: "
        static let API_CALL_ERROR = "Error in API Call"
        static let NO_DATA_RECIEVED = "No Data Recieved"
        static let INVALID_RESPONSE = "Invalid Response Recieved"
        static let JSON_PARSING_ERROR = "Error while parsing JSON data"
        static let FILE_COPY_ERROR = "Could not copy file to disk:"
        static let DATA_TASK_ERROR = "DataTask error: "
        static let JSON_SERIALIZATION_ERROR = "JSONSerialization error:"
        static let DICTIONARY_PARSING_ERROR = "Problem parsing Dictionary"
    }
    
    struct Networking{
        struct HttpMethod {
            static let POST_METHOD = "post"
            static let GET_METHOD = "get"
        }
        struct HeaderFieldValue {
            static let CONTENT_TYPE = "content-type"
            static let BODY_DATA_TYPE_IS_JSON = "application/json"
        }
    }
    
    struct DictionaryKey{
        static let PREVIEW_URL = "previewUrl"
        static let TRACK_NAME = "trackName"
        static let ARTIST_NAME = "artistName"
        static let RESULTS = "results"
    }
    
    struct Array {
       
    }
    
    
    
   
}
