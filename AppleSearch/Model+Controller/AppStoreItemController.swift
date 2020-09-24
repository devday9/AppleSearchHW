//
//  AppStoreItemController.swift
//  AppleSearch
//
//  Created by Deven Day on 9/23/20.
//

import UIKit

class AppStoreItemController {
    static func getItemsOf(type: AppStoreItem.ItemType, searchText: String, completion: @escaping (([AppStoreItem]) -> Void)) {
        
        let baseURL = URL(string: "https://itunes.apple.com/search")!
        guard var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: true) else
        {
            print("Our URL is not working right.")
            completion([])
            return
        }
        let searchTermQuery = URLQueryItem(name: "term", value: searchText)
        let entityQuery = URLQueryItem(name: "entity", value: type.rawValue)
        components.queryItems = [searchTermQuery, entityQuery]
        
        print(components.url!)
        
        guard let url = components.url else {
            print("Our query items are causing trouble")
            completion([])
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                print("Error getting stuff back from apple: \(error.localizedDescription)")
                completion([])
                return
            }
            
            guard let data = data else {
                print("No data was received from apple")
                completion([])
                return
            }
            
            guard let topLeveJSON = (try?JSONSerialization.jsonObject(with: data, options: .allowFragments)) as?[String : Any] else {
                print("Could not convert data from JSON")
                completion([])
                return
            }
            
            guard let appStoreItemDictionaries = topLeveJSON["results"] as? [[String : Any]] else {
                print("Could not get dictionaries from results")
                completion([])
                return
            }
            
            var allItems: [AppStoreItem] = []
            
            for itemDictionary in appStoreItemDictionaries {
                if let newItem = AppStoreItem(itemType: type, dict: itemDictionary) {
                    allItems.append(newItem)
                }
            }
            
            completion(allItems)
            
        }.resume()
    }
    
    static func getImageFor(item: AppStoreItem, completion: @escaping((UIImage?) -> Void)) {
        
        guard let imageURLAsString = item.imageURL,
              let url = URL(string: imageURLAsString) else {
            print("item did not have an image that could be made into a URL")
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let data = data else {
                print("Could not get data back from image")
                completion(nil)
                return
            }
            
            let image = UIImage(data: data)
            completion(image)
            
        }.resume()
        
        
    }
}//END OF CLASS
