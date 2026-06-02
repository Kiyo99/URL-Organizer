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
    var urlToShow: URL? = nil
    var validationErrorMessage: String = ""
    var showErrorAlert: Bool = false
    var showWebView: Bool = false
    var showOptions: Bool = false
    var isEditing: Bool = false
    
    // MARK: - Functions to be called from the View
    func validateURL() -> Bool {
        validationErrorMessage = ""
        guard let safeUrl = URL(string: currentURL),
              safeUrl.scheme?.lowercased() == "https" || safeUrl.scheme?.lowercased() == "http",
              safeUrl.host != nil else {
            validationErrorMessage = "Please enter a valid URL."
            showErrorAlert = true
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
        selectedURLItem = nil
        isEditing = false
    }
    
    func removeUrlItem(_ item: URLItem){
        urlList.removeAll { $0.id == item.id }
        selectedURLItem = nil
        isEditing = false
    }
    
    func removeDuplicates(of item: URLItem) {
        urlList.removeAll { $0.urlString == item.urlString && $0.id != item.id }
        selectedURLItem = nil
        isEditing = false
    }
    
    func editURL(_ item: URLItem){
        selectedURLItem = item
        currentURL = item.urlString
        isEditing = true
    }
    
    func saveEdits(){
        guard let selectedURLItem, !currentURL.isEmpty, validateURL() else {
            return
        }
        if let index = urlList.firstIndex(where: {$0.id == selectedURLItem.id}){
            urlList[index].urlString = currentURL
        }
        self.selectedURLItem = nil
        currentURL = ""
        isEditing = false
    }
    
    func showWebSheet(for item: URLItem){
        urlToShow = URL(string: item.urlString)
        showWebView = true
    }
    
    func showOptionsDialog(for item: URLItem) {
        selectedURLItem = item
        showOptions = true
    }
}
