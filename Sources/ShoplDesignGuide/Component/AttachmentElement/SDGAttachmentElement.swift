//
//  SDGAttachmentElement.swift
//  ShoplDesignGuide
//
//  Created by jerry on 1/6/26.
//

import SwiftUI

import Kingfisher

public struct SDGAttachmentElement: View {
  public static var version: String { "2.3.40" }
  
  public enum State: Equatable {
    case `default`
    case uploading
    case failed
  }
  
  public struct Model: Equatable {
    public enum `Type`: Equatable {
      case photo(image: Image?, url: URL? = nil)
      case document
      case video(thumbnail: Image?, url: URL? = nil)
    }
    
    public let type: `Type`
    public let id: String
    public let fileName: String
    public let fileSize: String
    
    public init(
      type: Type,
      id: String,
      fileName: String,
      fileSize: String
    ) {
      self.type = type
      self.id = id
      self.fileName = fileName
      self.fileSize = fileSize
    }

    @available(*, deprecated, renamed: "init(type:id:fileName:fileSize:)")
    public init(type: Type, id: String, name: String, size: String) {
      self.init(
        type: type,
        id: id,
        fileName: name,
        fileSize: size
      )
    }
  }
  
  public let model: Model
  public let state: State
  private let onSelect: ((Model) -> Void)?
  private let onRetry: (() -> Void)?
  
  public init(
    model: Model,
    state: State = .default,
    selectedItem: ((Model) -> Void)? = nil,
    onRetry: (() -> Void)? = nil
  ) {
    self.model = model
    self.state = state
    self.onSelect = selectedItem
    self.onRetry = onRetry
  }
  
  @ViewBuilder
  public var body: some View {
    if state == .default, let onSelect {
      Button {
        onSelect(model)
      } label: {
        content
          .contentShape(Rectangle())
      }
      .buttonStyle(.plain)
    } else {
      content
    }
  }

  private var content: some View {
    HStack(spacing: 12) {
      thumbnailBox
        .opacity(state == .default ? 1 : 0.1)

      fileInfo
        .opacity(state == .default ? 1 : 0.1)
        .overlay {
          stateIndicator
        }
    }
    .frame(height: 36)
  }
  
  // MARK: - Subviews
  
  private var fileInfo: some View {
    VStack(alignment: .leading, spacing: 0) {
      Text(model.fileName)
        .typo(.body2_R, .neutral600)
        .lineLimit(1)
        .truncationMode(.middle)
      
      Text("(\(model.fileSize))")
        .typo(.body3_R, .neutral400)
        .lineLimit(1)
    }
    .frame(maxWidth: .infinity, alignment: .leading)
  }

  @ViewBuilder
  private var stateIndicator: some View {
    switch state {
    case .default:
      EmptyView()

    case .uploading:
      SDGCircularProgress(size: 22, lineWidth: 2)

    case .failed:
      if let onRetry {
        Button(action: onRetry) {
          retryIcon
        }
        .buttonStyle(.plain)
        .frame(width: 36, height: 36)
      } else {
        retryIcon
      }
    }
  }

  private var retryIcon: some View {
    Image(sdg: .icRetry)
      .resizable()
      .foregroundStyle(.red300)
      .frame(width: 24, height: 24)
  }
  
  private var thumbnailBox: some View {
    ZStack {
      thumbnailContent
      playIconIfNeeded
    }
    .frame(width: 36, height: 36)
    .cornerRadius(4)
  }
  
  @ViewBuilder
  private var thumbnailContent: some View {
    switch model.type {
    case let .photo(image, url):
      thumbnailImage(image: image, url: url)
      
    case .document:
      ZStack {
        Color.neutral150
        iconView(Image(sdg: .icClip))
      }
      
    case let .video(thumbnail, url):
      thumbnailImage(image: thumbnail, url: url)
    }
  }
  
  @ViewBuilder
  private var playIconIfNeeded: some View {
    if case .video = model.type {
      iconView(Image(sdg: .icCommonPlay))
    }
  }
  
  // MARK: - Helper Views
  
  @ViewBuilder
  private func thumbnailImage(image: Image?, url: URL?) -> some View {
    if let image {
      image.thumbnailStyle()
    } else if let url {
      KFImage(url)
        .resizable()
        .aspectRatio(contentMode: .fill)
        .frame(width: 36, height: 36)
        .cornerRadius(4)
    }
  }
  
  private func iconView(_ image: Image) -> some View {
    image
      .resizable()
      .foregroundStyle(.secondary200)
      .frame(width: 14, height: 14)
  }
}

// MARK: - Image Extension

private extension Image {
  func thumbnailStyle() -> some View {
    self
      .resizable()
      .aspectRatio(contentMode: .fill)
      .frame(width: 36, height: 36)
      .cornerRadius(4)
  }
}


#Preview {
  
  VStack {
    
    SDGAttachmentElement(
      model: .init(
        type: .photo(image: Image(sdg: .avatarEmpty)),
        id: UUID().uuidString,
        fileName: "이미지파일.jpg",
        fileSize: "4MB"
      ),
      selectedItem: { _ in }
    )
    
    SDGAttachmentElement(
      model: .init(
        type: .document,
        id: UUID().uuidString,
        fileName: "문서파일.jpg",
        fileSize: "4MB"
      ),
      selectedItem: { _ in }
    )
    
    SDGAttachmentElement(
      model: .init(
        type: .video(thumbnail: Image(sdg: .profileSmall)),
        id: UUID().uuidString,
        fileName: "비디오파일.jpg",
        fileSize: "4MB"
      ),
      selectedItem: { _ in }
    )
    
    SDGAttachmentElement(
      model: .init(
        type: .photo(image: Image(sdg: .avatarEmpty)),
        id: UUID().uuidString,
        fileName: "이미지파일 제목이 길어지면 아아아아아아아아아아아아아아아아아아아아아아어ㅏ어어엉아아ㅏ줄임말로.jpg",
        fileSize: "4MB"
      ),
      state: .uploading
    )
    
    
    SDGAttachmentElement(
      model: .init(
        type: .document,
        id: UUID().uuidString,
        fileName: "문서파일 제목이 길어지면 아아아아아아아아아아아아아아아아아아아아아아어ㅏ어어엉아아ㅏ줄임말로.pdf",
        fileSize: "4MB"
      ),
      state: .failed,
      onRetry: {}
    )
    
    SDGAttachmentElement(
      model: .init(
        type: .video(thumbnail: Image(sdg: .profileSmall)),
        id: UUID().uuidString,
        fileName: "비디오파일 제목이 길어지면 아아아아아아아아아아아아아아아아아아아아아아어ㅏ어어엉아아ㅏ줄임말로.mov",
        fileSize: "4MB"
      ),
      selectedItem: { _ in }
    )
    
  }
  .padding(30)
}
