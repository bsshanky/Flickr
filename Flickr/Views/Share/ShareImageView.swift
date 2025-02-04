//
//  ShareImageView.swift
//  Flickr
//
//  Created by Shashank  on 2/3/25.
//

import SwiftUI

struct ShareImageView: View {
    
    let item: ImageItem
    @Binding var showShareView: Bool
    
    @State private var showActivitySheet = false
    @State private var shareItems: [Any] = []
        
    var body: some View {
        VStack(spacing: 20) {
            
            Spacer()
            // Cancel
            HStack {
                Button {
                    showShareView = false
                } label: {
                    HStack {
                        Image(systemName: "x.square")
                        Text("Cancel")
                    }
                }
                Spacer()
            }
                        
            // Image
            ZStack {
                ImageGridItem(imageURL: item.media.imageURL, width: 350, height: 650)
                    .blur(radius: 40)
                    .clipped()
                    .cornerRadius(20)
                
                ImageGridItem(imageURL: item.media.imageURL, width: 300, height: 250)
                
            }
            .padding(.horizontal, 20)
                        
            // Actions
            HStack {
                Spacer()
                Button {
                    Task {
                        if let uiImage = await downloadUIImage(from: item.media.imageURL) {
                            shareItems = [uiImage, item.link]
                            showActivitySheet = true
                        }
                    }
                } label: {
                    VStack(spacing: 10) {
                        Image(systemName: "square.and.arrow.up")
                        Text("Share Via..")
                    }
                }
                
                Spacer()
                
                Button {
                    Task {
                        if let uiImage = await downloadUIImage(from: item.media.imageURL) {
                            UIImageWriteToSavedPhotosAlbum(uiImage, nil, nil, nil)
                        }
                    }
                    
                } label: {
                    VStack(spacing: 10) {
                        Image(systemName: "arrow.down.circle")
                        Text("Save Image")
                    }
                }
                Spacer()
            }
            
        }
        .padding()
        .sheet(isPresented: $showActivitySheet) {
            ShareSheet(items: shareItems)
        }
    }
        
    func downloadUIImage(from urlString: String) async -> UIImage? {
        guard let url = URL(string: urlString) else { return nil }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            return UIImage(data: data)
        } catch {
            print("Error downloading image: \(error)")
            return nil
        }
    }
}

// MARK: - ShareSheet UIViewControllerRepresentable

struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: nil)
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) { }
}

// MARK: PREVIEW

#Preview {
    @Previewable @State var showShareView = true
    ShareImageView(item: ImageAPIResponse.mockImageItems[0], showShareView: $showShareView)
}
