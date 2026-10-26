import SwiftUI

/// 아이콘과 텍스트를 상단 정렬하는 검토용 Icon Label 컴포넌트입니다.
/// 디자인 버전 2.1.29. 원본 SDGIconLabel과 독립적으로 사용합니다.
public struct SDGIconLabelBuilderTest: View {
  /// 이 컴포넌트에 적용한 디자인 가이드 버전입니다.
  public static let version = "2.1.29"

  /// 라벨 크기와 굵기입니다. isBold가 true이면 SemiBold, false이면 Regular입니다.
  public enum Size {
    /// Body1(16pt)을 사용합니다.
    case medium(isBold: Bool)
    /// Body2(14pt)를 사용합니다.
    case small(isBold: Bool)
    /// Body3(12pt)를 사용합니다.
    case xsmall(isBold: Bool)

    fileprivate var typography: SDG.Typography {
      switch self {
      case let .medium(isBold): return isBold ? .body1_SB : .body1_R
      case let .small(isBold): return isBold ? .body2_SB : .body2_R
      case let .xsmall(isBold): return isBold ? .body3_SB : .body3_R
      }
    }

    // 추출된 아이콘 프레임의 상하 여백을 유지하며 프레임끼리 상단 정렬합니다.
    fileprivate var iconVerticalPadding: CGFloat {
      switch self {
      case .medium: return SDGSpacing.spacing3.rawValue
      case .small: return SDGSpacing.spacing2.rawValue
      case .xsmall: return SDGSpacing.spacing1.rawValue
      }
    }
  }

  /// 아이콘과 라벨 사이에 사용하는 SDG 간격입니다.
  public enum Spacing {
    /// Spacing2(2pt)입니다.
    case two
    /// Spacing4(4pt)입니다.
    case four

    fileprivate var value: CGFloat {
      switch self {
      case .two: return SDGSpacing.spacing2.rawValue
      case .four: return SDGSpacing.spacing4.rawValue
      }
    }
  }

  /// 최소 한 개의 아이콘을 제공하는 구성입니다. SDG Iconography 이미지를 전달할 수 있습니다.
  public enum Icons {
    /// 왼쪽 아이콘과 남은 가용 폭을 채우는 라벨입니다.
    case left(Image)
    /// 남은 가용 폭을 채우는 라벨과 오른쪽 아이콘입니다.
    case right(Image)
    /// 라벨 양쪽에 아이콘을 표시하며 짧은 라벨은 내용 폭을 사용합니다.
    case both(left: Image, right: Image)
  }

  /// 가용 폭을 넘는 라벨의 표시 방식입니다.
  public enum TextBehavior: Equatable {
    /// 줄 수 제한 없이 전체 내용을 표시합니다.
    case multiline
    /// 한 줄로 표시하고 넘치는 끝부분을 말줄임합니다.
    case singleLine
  }

  private let size: Size
  private let spacing: Spacing
  private let icons: Icons
  private let title: String
  private let imageForegroundColor: SDG.Color
  private let titleColor: SDG.Color
  private let textBehavior: TextBehavior

  /// 디자인 버전 2.1.29의 아이콘 라벨을 생성합니다. 별도 상태나 이벤트는 소유하지 않습니다.
  /// - Parameters:
  ///   - size: M/S/XS 크기 및 Regular/SemiBold 굵기입니다.
  ///   - spacing: 아이콘과 라벨 간격입니다. 기본값은 Spacing2(2pt)입니다.
  ///   - icons: 왼쪽, 오른쪽 또는 양쪽 아이콘입니다. 각 이미지는 16×16pt로 표시합니다.
  ///   - title: 표시할 라벨입니다.
  ///   - imageForegroundColor: 아이콘에 적용할 SDG 색상입니다.
  ///   - titleColor: 라벨에 적용할 SDG 색상입니다.
  ///   - textBehavior: 기본값은 여러 줄 전체 표시이며 singleLine은 한 줄 끝 말줄임입니다.
  public init(
    size: Size,
    spacing: Spacing = .two,
    icons: Icons,
    title: String,
    imageForegroundColor: SDG.Color,
    titleColor: SDG.Color,
    textBehavior: TextBehavior = .multiline
  ) {
    self.size = size
    self.spacing = spacing
    self.icons = icons
    self.title = title
    self.imageForegroundColor = imageForegroundColor
    self.titleColor = titleColor
    self.textBehavior = textBehavior
  }

  public var body: some View {
    HStack(alignment: .top, spacing: spacing.value) {
      switch icons {
      case let .left(image):
        iconImage(image)
        titleText.frame(maxWidth: .infinity, alignment: .leading)
      case let .right(image):
        titleText.frame(maxWidth: .infinity, alignment: .leading)
        iconImage(image)
      case let .both(left, right):
        iconImage(left)
        titleText
        iconImage(right)
      }
    }
  }

  private var titleText: some View {
    Text(title)
      .typo(size.typography, titleColor)
      .multilineTextAlignment(.leading)
      .lineLimit(textBehavior == .singleLine ? 1 : nil)
      .truncationMode(.tail)
      .fixedSize(horizontal: false, vertical: true)
  }

  private func iconImage(_ image: Image) -> some View {
    image
      .templateIcon(size: 16, color: imageForegroundColor)
      .padding(.vertical, size.iconVerticalPadding)
      .fixedSize()
  }
}
