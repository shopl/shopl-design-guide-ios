//
//  SDGThumbnails.swift
//  ShoplDesignGuide
//
//  Created by kai.kim on 7/30/26.
//

import SwiftUI

import Kingfisher

public struct SDGThumbnails: View {
  public static let version: String = "2.3.43"

  public typealias ThumbnailType = SDGThumbnailElement.ThumbnailType
  public typealias Thumbnail = SDGThumbnailElement.Thumbnail

  @available(*, deprecated, renamed: "Thumbnail")
  public typealias Photo = Thumbnail

  private enum Constants {
    static let columnCount = 4
    static let spacing = SDGSpacing.spacing8.rawValue
    static let radius = SDGCornerRadius.radius12.rawValue
  }

  private let thumbnails: [Thumbnail]
  private let type: ThumbnailType
  private let rowCount: Int?
  private let onDelete: ((Thumbnail) -> Void)?
  private let onThumbnailTapped: ((Thumbnail) -> Void)?
  private let onRemainingCountTapped: (() -> Void)?

  private var requiredRowCount: Int {
    guard thumbnails.isNotEmpty else { return 0 }
    return Int(ceil(Double(thumbnails.count) / Double(Constants.columnCount)))
  }

  private var displayRowCount: Int {
    guard thumbnails.isNotEmpty else { return 0 }
    // 삭제 버튼과 +N 오버레이를 함께 노출할 수 없으므로 편집 상태에서는 전체 항목을 표시함.
    guard onDelete == nil else { return requiredRowCount }
    guard let rowCount else { return requiredRowCount }
    return min(max(rowCount, 0), requiredRowCount)
  }

  private var displaySlotCount: Int {
    displayRowCount * Constants.columnCount
  }

  private var remainingCount: Int {
    guard rowCount != nil else { return 0 }
    return max(thumbnails.count - displaySlotCount, 0)
  }

  public init(
    thumbnails: [Thumbnail],
    type: ThumbnailType = .photo,
    rowCount: Int? = nil,
    onDelete: ((Thumbnail) -> Void)? = nil,
    onThumbnailTapped: ((Thumbnail) -> Void)? = nil,
    onRemainingCountTapped: (() -> Void)? = nil
  ) {
    self.thumbnails = thumbnails
    self.type = type
    self.rowCount = rowCount
    self.onDelete = onDelete
    self.onThumbnailTapped = onThumbnailTapped
    self.onRemainingCountTapped = onRemainingCountTapped
  }

  /// 기존 Photo 전용 API를 사용하는 화면의 동작과 호출 방식을 유지함.
  @available(*, deprecated, renamed: "init(thumbnails:type:rowCount:onDelete:onThumbnailTapped:onRemainingCountTapped:)")
  public init(
    photos: [Photo],
    rowCount: Int? = nil,
    onDelete: ((Photo) -> Void)? = nil,
    onThumbnailTapped: ((Photo) -> Void)? = nil,
    onRemainingCountTapped: (() -> Void)? = nil
  ) {
    self.init(
      thumbnails: photos,
      type: .photo,
      rowCount: rowCount,
      onDelete: onDelete,
      onThumbnailTapped: onThumbnailTapped,
      onRemainingCountTapped: onRemainingCountTapped
    )
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
            if index < thumbnails.count {
              thumbnailCell(
                thumbnail: thumbnails[index],
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
  private func thumbnailCell(
    thumbnail: Thumbnail,
    showsRemainingCount: Bool
  ) -> some View {
    if showsRemainingCount {
      SDGThumbnailElement(
        thumbnail: thumbnail,
        type: type
      )
        .overlay {
          remainingCountOverlay
        }
    } else {
      SDGThumbnailElement(
        thumbnail: thumbnail,
        type: type,
        onDelete: onDelete,
        onThumbnailTapped: onThumbnailTapped
      )
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
}

public struct SDGThumbnailElement: View {
  public enum ThumbnailType: Equatable {
    case photo
    case video
  }

  public struct Thumbnail: Identifiable, Equatable {
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

    public static func == (lhs: Thumbnail, rhs: Thumbnail) -> Bool {
      lhs.id == rhs.id
    }
  }

  private enum Constants {
    static let radius = SDGCornerRadius.radius12.rawValue
    static let indicatorSize: CGFloat = 20
    static let playIconSize: CGFloat = 14
    static let deleteTouchPadding = SDGSpacing.spacing2.rawValue
  }

  private let thumbnail: Thumbnail
  private let type: ThumbnailType
  private let onDelete: ((Thumbnail) -> Void)?
  private let onThumbnailTapped: ((Thumbnail) -> Void)?

  public init(
    thumbnail: Thumbnail,
    type: ThumbnailType = .photo,
    onDelete: ((Thumbnail) -> Void)? = nil,
    onThumbnailTapped: ((Thumbnail) -> Void)? = nil
  ) {
    self.thumbnail = thumbnail
    self.type = type
    self.onDelete = onDelete
    self.onThumbnailTapped = onThumbnailTapped
  }

  public var body: some View {
    ZStack(alignment: .topTrailing) {
      thumbnailActionContent
      deleteButton
    }
  }

  @ViewBuilder
  private var thumbnailActionContent: some View {
    if let onThumbnailTapped {
      Button {
        onThumbnailTapped(thumbnail)
      } label: {
        thumbnailContent
      }
      .buttonStyle(.plain)
    } else {
      thumbnailContent
    }
  }

  private var thumbnailContent: some View {
    Color.clear
      .aspectRatio(1, contentMode: .fit)
      .overlay {
        ZStack {
          thumbnailImage
            .scaledToFill()
            .frame(maxWidth: .infinity, maxHeight: .infinity)

          if type == .video {
            playButton
          }
        }
      }
      .clipShape(RoundedRectangle(cornerRadius: Constants.radius))
      .contentShape(RoundedRectangle(cornerRadius: Constants.radius))
  }

  private var playButton: some View {
    ZStack {
      Circle()
        .fill(Color.neutral700.opacity(0.5))

      Image(sdg: .icCommonTriangleup)
        .templateIcon(size: Constants.playIconSize, color: Color.neutral0)
        .rotationEffect(.degrees(90))
    }
    .frame(width: Constants.indicatorSize, height: Constants.indicatorSize)
  }

  @ViewBuilder
  private var deleteButton: some View {
    if let onDelete {
      Button {
        onDelete(thumbnail)
      } label: {
        Image(sdg: .icRemoveM)
          .resizable()
          .frame(width: Constants.indicatorSize, height: Constants.indicatorSize)
          .padding(Constants.deleteTouchPadding)
      }
      .buttonStyle(.plain)
    }
  }

  @ViewBuilder
  private var thumbnailImage: some View {
    switch thumbnail.source {
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

@available(*, deprecated, renamed: "SDGThumbnails")
public typealias SDGPhotoThumbnailGrid = SDGThumbnails

#Preview {
  VStack(alignment: .leading, spacing: 24) {
    SDGThumbnails(
      thumbnails: [
        .init(id: "photo-0", image: Image(sdg: .avatarEmptyDot))
      ],
      onDelete: { _ in },
      onThumbnailTapped: { _ in },
      onRemainingCountTapped: {}
    )

    SDGThumbnails(
      thumbnails: (0..<4).map {
        .init(id: "video-\($0)", image: Image(sdg: .avatarEmptyDot))
      },
      type: .video,
      onThumbnailTapped: { _ in }
    )

    SDGThumbnails(
      thumbnails: (0..<8).map {
        .init(id: "photo-\($0)", image: Image(sdg: .avatarEmptyDot))
      },
      rowCount: 1,
      onThumbnailTapped: { _ in },
      onRemainingCountTapped: {}
    )
  }
  .padding(20)
}
