import SwiftUI

/// 16pt 아이콘과 라벨을 상단 정렬하는 Icon Label Builder Test 컴포넌트입니다.
/// 한쪽 아이콘만 사용하면 라벨이 남은 가용 너비를 채웁니다.
public struct SDGIconLabelBuilderTest: View {
  /// 적용한 컴포넌트 디자인 가이드 버전입니다.
  public static let version = "2.1.29"

  /// SDG 아이콘을 포함해 전달한 이미지를 왼쪽·오른쪽·양쪽에 배치합니다.
  /// 아이콘이 없는 조합은 지원하지 않습니다.
  public enum Icons {
    /// 왼쪽에만 16×16pt 이미지를 표시합니다.
    case left(Image)
    /// 오른쪽에만 16×16pt 이미지를 표시합니다.
    case right(Image)
    /// 왼쪽과 오른쪽에 각각 16×16pt 이미지를 표시합니다.
    case both(left: Image, right: Image)

    fileprivate var leftImage: Image? {
      switch self {
      case let .left(image), let .both(image, _): return image
      case .right: return nil
      }
    }

    fileprivate var rightImage: Image? {
      switch self {
      case let .right(image), let .both(_, image): return image
      case .left: return nil
      }
    }

    fileprivate var fillsWidth: Bool {
      switch self {
      case .left, .right: return true
      case .both: return false
      }
    }
  }

  /// 라벨의 긴 문구를 표시하는 방식입니다.
  public enum TextDisplay {
    /// 가용 너비에서 줄바꿈하여 전체 문구를 표시합니다.
    case full
    /// 한 줄만 표시하고 넘치는 문구는 끝에서 말줄임합니다.
    case singleLine
  }

  private let size: SDGIconLabel.Size
  private let spacing: SDGIconLabel.Spacing
  private let icons: Icons
  private let title: String
  private let imageForegroundColor: Color
  private let titleColor: SDG.Color
  private let textDisplay: TextDisplay

  /// 아이콘과 라벨의 표시 규격을 설정합니다. 별도의 상태나 이벤트는 소유하지 않습니다.
  /// - Parameters:
  ///   - size: Medium/Small/XSmall과 Regular/Semibold 조합입니다.
  ///   - spacing: 아이콘과 라벨 사이 간격으로 2pt 또는 4pt이며 기본값은 2pt입니다.
  ///   - icons: 최소 한쪽 아이콘을 지정합니다. 이미지는 16×16pt로 표시합니다.
  ///   - title: 표시할 전체 라벨 문구입니다.
  ///   - imageForegroundColor: 템플릿 아이콘에 적용할 색상입니다.
  ///   - titleColor: 라벨에 적용할 SDG 색상입니다.
  ///   - textDisplay: 기본값은 전체 노출이며 singleLine은 한 줄 끝 말줄임입니다.
  public init(
    size: SDGIconLabel.Size,
    spacing: SDGIconLabel.Spacing = .two,
    icons: Icons,
    title: String,
    imageForegroundColor: Color,
    titleColor: SDG.Color,
    textDisplay: TextDisplay = .full
  ) {
    self.size = size
    self.spacing = spacing
    self.icons = icons
    self.title = title
    self.imageForegroundColor = imageForegroundColor
    self.titleColor = titleColor
    self.textDisplay = textDisplay
  }

  public var body: some View {
    HStack(alignment: .top, spacing: gap) {
      if let image = icons.leftImage {
        iconImage(image)
      }

      Text(title)
        .typo(size.typoSize, titleColor)
        .lineLimit(textDisplay == .singleLine ? 1 : nil)
        .truncationMode(.tail)
        .multilineTextAlignment(.leading)
        .fixedSize(horizontal: false, vertical: true)
        .frame(maxWidth: icons.fillsWidth ? .infinity : nil, alignment: .leading)

      if let image = icons.rightImage {
        iconImage(image)
      }
    }
  }

  private var gap: CGFloat {
    switch spacing {
    case .two: return SDGSpacing.spacing2.rawValue
    case .four: return SDGSpacing.spacing4.rawValue
    }
  }

  private func iconImage(_ image: Image) -> some View {
    image
      .templateIcon(size: 16, color: imageForegroundColor)
      .fixedSize()
      // 디자인의 첫 줄 아이콘 슬롯(크기별 상하 3/2/1pt)을 유지합니다.
      .padding(.vertical, size.iconVerticalPadding)
  }
}
