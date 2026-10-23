import SwiftUI
import ShoplDesignGuide

/// Text Navi의 구성, 좁은 폭의 긴 문구, 배경 대비와 버튼 이벤트를 확인하는 샘플입니다.
struct SDGTextNaviDemoView: View {
  @State private var title = "긴 타이틀은 액션보다 먼저 말줄임됩니다"
  @State private var actionText = "저장"
  @State private var showsIcon = true
  @State private var showsAction = true
  @State private var darkBackground = false
  @State private var narrowWidth = false
  @State private var lastEvent = "버튼을 눌러 이벤트를 확인하세요"

  var body: some View {
    VStack(alignment: .leading, spacing: 16) {
      TextField("타이틀", text: $title)
        .textFieldStyle(.roundedBorder)
      TextField("액션 문구", text: $actionText)
        .textFieldStyle(.roundedBorder)
      Toggle("액션 표시", isOn: $showsAction)
      Toggle("액션 아이콘", isOn: $showsIcon)
      Toggle("진한 배경", isOn: $darkBackground)
      Toggle("좁은 폭 (240pt)", isOn: $narrowWidth)
      Button("긴 액션 문구 테스트") {
        actionText = "이 문구가 화면 너비보다 길어도 뒤로가기 버튼과 화면 경계를 유지해야 합니다"
      }

      VStack(alignment: .leading, spacing: 12) {
        Text("Back")
        SDGTextNavi(
          naviType: .back(back: { lastEvent = "뒤로가기" }, title: titleOption, right: rightOption),
          backgroundColor: backgroundColor
        )
        .backButtonColor(foregroundColor)

        Text("Full")
        SDGTextNavi(
          naviType: .full(
            left: .init(image: Image(sdg: .icNaviBack), color: foregroundColor,
                        action: { lastEvent = "좌측 버튼" }),
            title: titleOption, right: rightOption
          ),
          backgroundColor: backgroundColor
        )

        Text("Text")
        SDGTextNavi(
          naviType: .text(title: titleOption, right: rightOption),
          backgroundColor: backgroundColor
        )
      }
      .frame(maxWidth: narrowWidth ? 240 : .infinity)

      Text(lastEvent)
        .typo(.body1_R)
    }
    .padding(16)
  }

  private var foregroundColor: Color { darkBackground ? .neutral0 : .neutral700 }
  private var backgroundColor: Color { darkBackground ? .neutral700 : .neutral100 }
  private var titleOption: SDGTextNavi.NaviType.Title {
    .init(text: title, color: darkBackground ? .neutral0 : .neutral900)
  }
  private var rightOption: SDGTextNavi.NaviType.Right? {
    guard showsAction else { return nil }
    return .init(
      image: showsIcon ? Image(sdg: .icCommonCompany) : nil,
      text: actionText,
      color: foregroundColor,
      action: { lastEvent = "우측 액션" }
    )
  }
}

#Preview {
  ScrollView { SDGTextNaviDemoView() }
}
