//
//  Search.swift
//  StoreSearch
//
//  Created by Olexsii Levchenko on 9/22/22.
//

import Foundation


class Search {
    var searchResults: [SearchResult] = []
    var hasSearched = false
    var isLoading = false
    
    private var dataTask: URLSessionDataTask?
    
    typealias SearchComplete = (Bool) -> Void
    
    func performSearch(for text: String, category: Int, completion: @escaping SearchComplete) {
        if !text.isEmpty {
            dataTask?.cancel()
            
            isLoading = true
            hasSearched = true
            searchResults = []
            
            let url = self.iTunesURL(searchText: text, category: category)
            let session = URLSession.shared
            
            dataTask = session.dataTask(with: url) { data, response, error in
                var success = false
                
                if let error = error as NSError?, error.code == -999 {
                    print("Failure! \(error.localizedDescription)")
                    return
                } else if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                    if let data = data {
                        self.searchResults = self.parse(data: data)
                        self.searchResults.sort (by: <)
                        
                        self.isLoading = false
                        success = true
                    }
                    
                    if !success {
                        self.hasSearched = false
                        self.isLoading = false
                    }
                    
                    DispatchQueue.main.async {
                        completion(success)
                    }
                }
            }
            dataTask?.resume()
        }
    }
    
    
    private func iTunesURL(searchText: String, category: Int) -> URL {
        let kind: String
        
        switch category {
        case 1: kind = "musicTrack"
        case 2: kind = "software"
        case 3: kind = "ebook"
        default: kind = ""
        }
        
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
