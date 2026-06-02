//
//  ContentView.swift
//  URL Organizer
//
//  Created by Godsfavour Ngo Kio on 2026-06-02.
//

import SwiftUI

struct ContentView: View {
    @State var urlViewModel = URLViewModel()
    
    var body: some View {
        VStack {
            TextField("Enter a url here...", text: $urlViewModel.currentURL)
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray, lineWidth: 1)
                )
            
            List(urlViewModel.urlList){ item in
                Button(action: {
                    urlViewModel.showWebSheet(for: item)
                }){
                    Text(item.urlString)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .onLongPressGesture {
                            urlViewModel.showOptionsDialog(for: item)
                        }
                }
                .buttonStyle(.plain)
            }
            
            Spacer()
            
            Button(action: {
                urlViewModel.isEditing ? urlViewModel.saveEdits() : urlViewModel.addURL()
            }){
                Text(urlViewModel.isEditing ? "Save Edit" : "Add URL")
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.blue)
                    )
            }
            .buttonStyle(.plain)
        }
        .padding()
        .alert(urlViewModel.validationErrorMessage, isPresented: $urlViewModel.showErrorAlert) {
            Button("Ok", role: .cancel) {}
        }
        .sheet(isPresented: $urlViewModel.showWebView){
            if let safeURL = urlViewModel.urlToShow {
                WebView(url: safeURL)
            }
        }
        .confirmationDialog("", isPresented: $urlViewModel.showOptions) {
            Button("Edit") {
                if let selected = urlViewModel.selectedURLItem {
                    urlViewModel.editURL(selected)
                }
            }
            Button("Remove") {
                if let selected = urlViewModel.selectedURLItem {
                    urlViewModel.removeUrlItem(selected)
                }
            }
            Button("Remove All") {
                urlViewModel.removeAllURLs()
            }
            Button("Remove Duplicates") {
                if let selected = urlViewModel.selectedURLItem {
                    urlViewModel.removeDuplicates(of: selected)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
