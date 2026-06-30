//
//  SDGAttachmentElementDemoState.swift
//  ShoplDesignGuide
//
//  Created by Jerry on 6/24/26.
//

import SwiftUI
import ShoplDesignGuide

final class SDGAttachmentElementDemoState: ObservableObject {
  static let shared = SDGAttachmentElementDemoState()
  
  let types = SDGAttachmentElementDemoType.allCases
  
  @Published var selectedTypeIndex = 0
  @Published var isLongTextEnabled = true
  
  private init() { }
  
  var selectedType: SDGAttachmentElementDemoType {
    types.indices.contains(selectedTypeIndex) ? types[selectedTypeIndex] : .photo
  }
  
  var attachmentModel: SDGAttachmentElement.Model {
    SDGAttachmentElement.Model(
      type: selectedType.attachmentType,
      id: attachmentPreviewID,
      name: fileName,
      size: "4MB"
    )
  }
  
  var attachmentPreviewID: String {
    [
      selectedType.id,
      isLongTextEnabled ? "long" : "short"
    ].joined(separator: "_")
  }
  
  private var fileName: String {
    let name = isLongTextEnabled ? Self.longFileName : Self.shortFileName
    return "\(name).\(selectedType.fileExtension)"
  }
  
  private static let shortFileName = "파일명"
  private static let longFileName = "가슴속에 못 시인의 나의 별이 봅니다. 어머님, 멀리 별 이런 나는 추억과 남은 걱정도 쓸쓸함과 있습니다."
}

enum SDGAttachmentElementDemoType: String, CaseIterable, Identifiable {
  case photo = "Photo"
  case document = "Document"
  case video = "Video"
  
  var id: String {
    rawValue
  }
  
  var title: String {
    rawValue
  }
  
  var fileExtension: String {
    switch self {
    case .photo:
      return "jpg"
    case .document:
      return "pdf"
    case .video:
      return "mov"
    }
  }
  
  var attachmentType: SDGAttachmentElement.Model.`Type` {
    switch self {
    case .photo:
      return .photo(image: Image("Attachment_Sample"))
    case .document:
      return .document
    case .video:
      return .video(thumbnail: Image("Attachment_Sample"))
    }
  }
}
