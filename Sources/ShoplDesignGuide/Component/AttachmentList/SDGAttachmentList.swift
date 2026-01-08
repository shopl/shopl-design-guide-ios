//
//  SDGAttachmentList.swift
//  ShoplDesignGuide
//
//  Created by jerry on 1/6/26.
//

import SwiftUI

import Kingfisher

public struct SDGAttachmentList: View {
  
  public struct Model: Equatable {
    public enum `Type`: Equatable {
      case photo(image: Image?, url: URL? = nil)
      case document
      case video(thumbnail: Image?, url: URL? = nil)
    }
    
    public let type: `Type`
    public let id: String
    public let name: String
    public let size: String
    
    public init(type: Type, id: String, name: String, size: String) {
      self.type = type
      self.id = id
      self.name = name
      self.size = size
    }
    
    public static func == (lhs: Model, rhs: Model) -> Bool {
      lhs.id == rhs.id
    }
  }
  
  public let model: Model
  private let onSelect: (Model) -> Void
  
  public init(model: Model, selectedItem: @escaping (Model) -> Void) {
    self.model = model
    self.onSelect = selectedItem
  }
  
  public var body: some View {
    HStack(spacing: 12) {
      thumbnailBox
      fileInfo
    }
    .onTapGesture { onSelect(model) }
  }
  
  // MARK: - Subviews
  
  private var fileInfo: some View {
    VStack(alignment: .leading, spacing: 0) {
      Text(model.name)
        .typo(.body2_R, .neutral600)
        .lineLimit(1)
        .truncationMode(.middle)
      
      Text("(\(model.size))")
        .typo(.body2_R, .neutral400)
    }
    .frame(maxWidth: .infinity, alignment: .leading)
  }
  
  private var thumbnailBox: some View {
    ZStack {
      thumbnailContent
      playIconIfNeeded
    }
    .frame(width: 36, height: 36)
    .background(.neutral150)
    .cornerRadius(4)
  }
  
  @ViewBuilder
  private var thumbnailContent: some View {
    switch model.type {
    case let .photo(image, url):
      thumbnailImage(image: image, url: url)
      
    case .document:
      iconView(.icClip)
      
    case let .video(thumbnail, url):
      thumbnailImage(image: thumbnail, url: url)
    }
  }
  
  @ViewBuilder
  private var playIconIfNeeded: some View {
    if case .video = model.type {
      iconView(.icCommonPlay)
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
  
  private func iconView(_ resource: ImageResource) -> some View {
    Image(resource)
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
    
    SDGAttachmentList(
      model: .init(
        type: .photo(image: Image(.avatarEmpty)),
        id: UUID().uuidString,
        name: "이미지파일.jpg",
        size: "4MB"
      ),
      selectedItem: { _ in }
    )
    
    SDGAttachmentList(
      model: .init(
        type: .document,
        id: UUID().uuidString,
        name: "문서파일.jpg",
        size: "4MB"
      ),
      selectedItem: { _ in }
    )
    
    SDGAttachmentList(
      model: .init(
        type: .video(thumbnail: Image(.profileSmall)),
        id: UUID().uuidString,
        name: "비디오파일.jpg",
        size: "4MB"
      ),
      selectedItem: { _ in }
    )
    
    SDGAttachmentList(
      model: .init(
        type: .photo(image: Image(.avatarEmpty)),
        id: UUID().uuidString,
        name: "이미지파일 제목이 길어지면 아아아아아아아아아아아아아아아아아아아아아아어ㅏ어어엉아아ㅏ줄임말로.jpg",
        size: "4MB"
      ),
      selectedItem: { _ in }
    )
    
    
    SDGAttachmentList(
      model: .init(
        type: .document,
        id: UUID().uuidString,
        name: "문서파일 제목이 길어지면 아아아아아아아아아아아아아아아아아아아아아아어ㅏ어어엉아아ㅏ줄임말로.pdf",
        size: "4MB"
      ),
      selectedItem: { _ in }
    )
    
    SDGAttachmentList(
      model: .init(
        type: .video(thumbnail: Image(.profileSmall)),
        id: UUID().uuidString,
        name: "비디오파일 제목이 길어지면 아아아아아아아아아아아아아아아아아아아아아아어ㅏ어어엉아아ㅏ줄임말로.mov",
        size: "4MB"
      ),
      selectedItem: { _ in }
    )
    
  }
  .padding(30)
}
