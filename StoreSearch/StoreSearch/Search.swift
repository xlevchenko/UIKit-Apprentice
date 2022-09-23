//
//  Search.swift
//  StoreSearch
//
//  Created by Olexsii Levchenko on 9/22/22.
//

import Foundation


class Search {
    
    private var dataTask: URLSessionDataTask?
    typealias SearchComplete = (Bool) -> Void
    
    enum Category: Int {
        case all = 0
        case music = 1
        case software = 2
        case ebooks = 3
        
        var type: String {
            switch self {
            case .all:
                return ""
            case .music:
                return "musicTrack"
            case .software:
                return "software"
            case .ebooks:
                return "ebook"
            }
        }
    }
    
    enum State {
        case notSearchedYet
        case loading
        case noResult
        case result([SearchResult])
    }
    
    private(set) var state: State = .notSearchedYet
    
    
    func performSearch(for text: String, category: Category, completion: @escaping SearchComplete) {
        if !text.isEmpty {
            dataTask?.cancel()
            state = .loading
            var success = false
            
            let url = self.iTunesURL(searchText: text, category: category)
            let session = URLSession.shared
            
            dataTask = session.dataTask(with: url) { data, response, error in
                var newState = State.notSearchedYet
                
                if let error = error as NSError?, error.code == -999 {
                    print("Failure! \(error.localizedDescription)")
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                    if let data = data {
                        var searchResults = self.parse(data: data)
                        
                        if searchResults.isEmpty {
                            newState = .noResult
                        } else {
                            searchResults.sort (by: <)
                            newState = .result(searchResults)
                        }
                        success = true
                    }
                }
                DispatchQueue.main.async {
                    self.state = newState
                    completion(success)
                }
            }
        }
        dataTask?.resume()
    }

    
    private func iTunesURL(searchText: String, category: Category) -> URL {
        let kind = category.type
        let encodedText = searchText.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        let urlString = String(format: "https://itunes.apple.com/search?" + "term=\(encodedText)&limit=200&entity=\(kind)", encodedText)
        
        let url = URL(string: urlString)
        return url!
    }
    
    
    private func parse(data: Data) -> [SearchResult] {
        do {
            let decode = JSONDecoder()
            let result = try decode.decode(ResultArray.self, from: data)
            return result.results
        } catch {
            print("JSON Error: \(error)")
            return []
        }
    }
}
