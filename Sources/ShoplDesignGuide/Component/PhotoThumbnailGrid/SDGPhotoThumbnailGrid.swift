//
//  SDGPhotoThumbnailGrid.swift
//  ShoplDesignGuide
//
//  Created by Codex on 6/15/26.
//

import SwiftUI

import Kingfisher

public struct SDGPhotoThumbnailGrid: View {
  public static let version: String = "2.1.30"

  public struct Photo: Identifiable, Equatable {
    public enum Source {
      case image(Image)
      case url(URL)
    }
    
    public let id: String
    public let source: Source
    
    public init(id: String, source: Source) {
      self.id = id
      self.source = source
    }
    
    public init(id: String, image: Image) {
      self.init(id: id, source: .image(image))
    }
    
    public init(id: String, url: URL) {
      self.init(id: id, source: .url(url))
    }
    
    public static func == (lhs: Photo, rhs: Photo) -> Bool {
      lhs.id == rhs.id
    }
  }
  
  private enum Constants {
    static let columnCount = 4
    static let spacing = SDGSpacing.spacing8.rawValue
    static let radius = SDGCornerRadius.radius12.rawValue
    static let deleteIconSize: CGFloat = 20
    static let deleteTouchPadding = SDGSpacing.spacing2.rawValue
  }
  
  private let photos: [Photo]
  private let rowCount: Int?
  private let onDelete: ((Photo) -> Void)?
  private let onThumbnailTapped: ((Photo) -> Void)?
  private let onRemainingCountTapped: (() -> Void)?
  private let thumbnailMenuContent: ((Photo) -> AnyView)?
  
  private var requiredRowCount: Int {
    guard photos.isNotEmpty else { return 0 }
    return Int(ceil(Double(photos.count) / Double(Constants.columnCount)))
  }
  
  private var displayRowCount: Int {
    guard photos.isNotEmpty else { return 0 }
    guard let rowCount else { return requiredRowCount }
    return min(max(rowCount, 0), requiredRowCount)
  }
  
  private var displaySlotCount: Int {
    displayRowCount * Constants.columnCount
  }
  
  private var remainingCount: Int {
    guard rowCount != nil else { return 0 }
    return max(photos.count - displaySlotCount, 0)
  }
  
  public init(
    photos: [Photo],
    rowCount: Int? = nil,
    onDelete: ((Photo) -> Void)? = nil,
    onThumbnailTapped: ((Photo) -> Void)? = nil,
    onRemainingCountTapped: (() -> Void)? = nil
  ) {
    self.photos = photos
    self.rowCount = rowCount
    self.onDelete = onDelete
    self.onThumbnailTapped = onThumbnailTapped
    self.onRemainingCountTapped = onRemainingCountTapped
    self.thumbnailMenuContent = nil
  }
  
  public init<MenuContent: View>(
    photos: [Photo],
    rowCount: Int? = nil,
    onDelete: ((Photo) -> Void)? = nil,
    onRemainingCountTapped: (() -> Void)? = nil,
    @ViewBuilder thumbnailMenuContent: @escaping (Photo) -> MenuContent
  ) {
    self.photos = photos
    self.rowCount = rowCount
    self.onDelete = onDelete
    self.onThumbnailTapped = nil
    self.onRemainingCountTapped = onRemainingCountTapped
    self.thumbnailMenuContent = { photo in
      AnyView(thumbnailMenuContent(photo))
    }
  }
  
  public var body: some View {
    Grid(
      horizontalSpacing: Constants.spacing,
      verticalSpacing: Constants.spacing
    ) {
      ForEach(0..<displayRowCount, id: \.self) { rowIndex in
        GridRow {
          ForEach(0..<Constants.columnCount, id: \.self) { columnIndex in
            let index = rowIndex * Constants.columnCount + columnIndex
            if index < photos.count {
              thumbnailCell(
                photo: photos[index],
                showsRemainingCount: index == displaySlotCount - 1 && remainingCount > 0
              )
            } else {
              Color.clear
                .aspectRatio(1, contentMode: .fit)
            }
          }
        }
      }
    }
  }
  
  @ViewBuilder
  private func thumbnailCell(photo: Photo, showsRemainingCount: Bool) -> some View {
    if showsRemainingCount {
      thumbnailCellContent(for: photo)
        .overlay {
          remainingCountOverlay
        }
    } else {
      ZStack(alignment: .topTrailing) {
        thumbnailActionContent(for: photo)
        deleteButton(for: photo)
      }
    }
  }
  
  @ViewBuilder
  private func thumbnailActionContent(for photo: Photo) -> some View {
    if let thumbnailMenuContent {
      Menu {
        thumbnailMenuContent(photo)
      } label: {
        thumbnailCellContent(for: photo)
      }
      .buttonStyle(.plain)
    } else if let onThumbnailTapped {
      Button {
        onThumbnailTapped(photo)
      } label: {
        thumbnailCellContent(for: photo)
      }
      .buttonStyle(.plain)
    } else {
      thumbnailCellContent(for: photo)
    }
  }
  
  private func thumbnailCellContent(for photo: Photo) -> some View {
    Color.clear
      .aspectRatio(1, contentMode: .fit)
      .overlay {
        thumbnailContent(for: photo)
          .scaledToFill()
          .frame(maxWidth: .infinity, maxHeight: .infinity)
      }
      .clipShape(RoundedRectangle(cornerRadius: Constants.radius))
      .contentShape(RoundedRectangle(cornerRadius: Constants.radius))
  }
  
  @ViewBuilder
  private func deleteButton(for photo: Photo) -> some View {
    if let onDelete {
      Button {
        onDelete(photo)
      } label: {
        Image(sdg: .icRemoveM)
          .resizable()
          .frame(width: Constants.deleteIconSize, height: Constants.deleteIconSize)
          .padding(Constants.deleteTouchPadding)
      }
      .buttonStyle(.plain)
    }
  }
  
  private var remainingCountOverlay: some View {
    ZStack {
      RoundedRectangle(cornerRadius: Constants.radius)
        .fill(Color.neutral900.opacity(0.4))
      
      Text("+\(min(remainingCount, 999))")
        .typo(.body2_SB, .neutral0)
    }
    .contentShape(Rectangle())
    .onTapGesture {
      onRemainingCountTapped?()
    }
  }
  
  @ViewBuilder
  private func thumbnailContent(for photo: Photo) -> some View {
    switch photo.source {
    case .image(let image):
      image
        .resizable()
    case .url(let url):
      KFImage(url)
        .placeholder {
          Color.neutral150
        }
        .resizable()
    }
  }
}

#Preview {
  VStack(alignment: .leading, spacing: 24) {
    SDGPhotoThumbnailGrid(
      photos: [
        .init(id: "image-0", image: Image(sdg: .profileSmall))
      ],
      onDelete: { _ in },
      onThumbnailTapped: { _ in },
      onRemainingCountTapped: {}
    )
    
    SDGPhotoThumbnailGrid(
      photos: (0..<5).map {
        .init(id: "image-\($0)", image: Image(sdg: .profileSmall))
      },
      rowCount: 1,
      onDelete: { _ in },
      onThumbnailTapped: { _ in },
      onRemainingCountTapped: {}
    )
    
    SDGPhotoThumbnailGrid(
      photos: (0..<8).map {
        .init(id: "image-\($0)", image: Image(sdg: .profileSmall))
      },
      rowCount: 2,
      onThumbnailTapped: { _ in },
      onRemainingCountTapped: {}
    )
  }
  .padding(20)
}
