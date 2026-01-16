//
//  File.swift
//  shopl-design-guide-ios
//
//  Created by Jerry on 5/28/25.
//

import SwiftUI

public struct SDGThumbnails: View {
  
  private var urls: [URL] = []
  private var images: [Image] = []
  private var rowCount: Int?
  private var isDeletable: Bool
  private var onDelete: ((Int) -> Void)?
  
  public init(urls: [URL], rowCount: Int? = nil,
              isDeletable: Bool = false, onDelete: ((Int) -> Void)? = nil ) {
    self.urls = urls
    self.rowCount = rowCount
    self.isDeletable = isDeletable
    self.onDelete = onDelete
  }
  
  public init(images: [Image], rowCount: Int? = nil,
              isDeletable: Bool = false, onDelete: ((Int) -> Void)? = nil ) {
    self.images = images
    self.rowCount = rowCount
    self.isDeletable = isDeletable
    self.onDelete = onDelete
  }
  
  public var body: some View {
    Grid(horizontalSpacing: 8, verticalSpacing: 8) {
      
      if urls.isNotEmpty {
        let displayRowCount = rowCount ?? ((urls.count + 3) / 4)
        ForEach(Array(stride(from: 0, to: displayRowCount * 4, by: 4)), id: \.self) { rowStartIndex in
          
          GridRow {
            ForEach(0..<4, id: \.self) { offset in
              let index = rowStartIndex + offset
              
              if index < urls.count {
                AsyncImage(url: self.urls[index]) { image in
                  image
                    .resizable()
                    .aspectRatio(1, contentMode: .fit)
                    .cornerRadius(12)
                } placeholder: {
                  ProgressView()
                }
                .makeDeletable(index: index, isDeletable: isDeletable, onDelete: onDelete)
                .showRemainingCount(isShowingCount: index == displayRowCount * 4 - 1, count: images.count - displayRowCount * 4)
                
              } else {
                Color.clear
                  .aspectRatio(1, contentMode: .fit)
              }
            }
          }
        }
      }
      
      if images.isNotEmpty {
        let displayRowCount = rowCount ?? ((images.count + 3) / 4)
        ForEach(Array(stride(from: 0, to: displayRowCount * 4, by: 4)), id: \.self) { rowStartIndex in
          
          GridRow {
            ForEach(0..<4, id: \.self) { offset in
              let index = rowStartIndex + offset
              
              if index < images.count {
                images[index]
                  .resizable()
                  .aspectRatio(1, contentMode: .fill)
                  .cornerRadius(12)
                  .makeDeletable(index: index, isDeletable: isDeletable, onDelete: onDelete)
                  .showRemainingCount(isShowingCount: index == displayRowCount * 4 - 1, count: images.count - displayRowCount * 4)
                
              } else {
                Color.clear
                  .aspectRatio(1, contentMode: .fill)
              }
            }
          }
        }
      }
      
      
    }
  }
}

extension View {
  
  fileprivate func makeDeletable(index: Int, isDeletable: Bool, onDelete: ((Int) -> Void)?) -> some View {
    ZStack(alignment: .topTrailing) {
      self
      
      if isDeletable {
        Button {
          onDelete?(index)
        } label: {
          Image(sdg: .icRemoveM)
            .resizable()
            .frame(width: 20, height: 20)
            .padding(2)
        }
      }
    }
  }
  
  fileprivate func showRemainingCount(isShowingCount: Bool, count: Int) -> some View {
    
    ZStack(alignment: .center) {
      self
      
      if isShowingCount && count != 0 {
        Color.neutral900.opacity(0.4)
          .cornerRadius(12)
        Text("+\(min(count, 999))")
          .typo(.body2_SB, .neutral0)
      }
    }
  }
}
