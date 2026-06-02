//
//  URLViewModel.swift
//  URL Organizer
//
//  Created by Godsfavour Ngo Kio on 2026-06-02.
//

import Foundation

@Observable
@MainActor
class URLViewModel {
    var urlList: [URLItem] = []
    var selectedURLItem: URLItem? = nil
    var currentURL: String = ""
    var validationErrorMessage: String = ""
    
    // MARK: - Functions to be called from the View
    // TODO: - edit, remove, removeAll, removeDuplicates, addURL, validateURL
    
    func validateURL() -> Bool {
        validationErrorMessage = ""
        guard let safeUrl = URL(string: currentURL),
              safeUrl.scheme?.lowercased() == "https" || safeUrl.scheme?.lowercased() == "http",
              safeUrl.host != nil else {
            validationErrorMessage = "Please enter a valid URL."
            return false
        }
        return true
    }
    
    func addURL() {
        guard !currentURL.isEmpty, validateURL() else { return }
        urlList.append(URLItem(urlString: currentURL))
        currentURL = ""
    }
    
    func removeAllURLs() {
        urlList.removeAll()
    }
    
    func removeUrlItem(_ item: URLItem){
        urlList.removeAll { $0.id == item.id }
    }
    
    func removeDuplicates() {
        
    }
    
    func editURL(_ item: URLItem){
        selectedURLItem = item
        currentURL = item.urlString
    }
    
    func saveEdits(){
        guard let selectedURLItem, !currentURL.isEmpty, validateURL() else { return }
        // find the index of the selectedItem in the urlList
        if let index = urlList.firstIndex(where: {$0.id == selectedURLItem.id}){
            urlList[index].urlString = currentURL
        }
        self.selectedURLItem = nil
        currentURL = ""
    }
}
