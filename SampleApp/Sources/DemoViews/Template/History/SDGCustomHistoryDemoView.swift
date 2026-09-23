//
//  SDGCustomHistoryDemoView.swift
//  shopl-design-guide-ios
//
//  Created by kai on 9/23/26.
//

import SwiftUI
import ShoplDesignGuide

struct SDGCustomHistoryDemoView: View {
  @State private var isExpanded = false
  @State private var itemCount = 3

  private struct Item: Identifiable {
    let id: Int
    let title: String
    let detail: String
  }

  private let items = [
    Item(id: 0, title: "보고서 제출", detail: "매장 점검 보고서를 제출했습니다."),
    Item(id: 1, title: "보완 요청 · 여러 줄로 표시되는 긴 이력 제목", detail: "누락된 점검 항목을 보완해 주세요."),
    Item(id: 2, title: "보고서 수정", detail: "요청된 항목을 보완했습니다."),
    Item(id: 3, title: "검토 완료", detail: "변경 내역을 확인했습니다."),
    Item(id: 4, title: "최종 승인", detail: "보고서가 승인되었습니다.")
  ]

  var body: some View {
    VStack(alignment: .leading, spacing: 24) {
      Text("Custom History")
        .typo(.point2_SB, .neutral700)

      Text("연결된 이력 · Top / Middle / Last")
        .typo(.body1_SB, .neutral700)

      Stepper("이력 \(itemCount)개", value: $itemCount, in: 0...5)

      VStack(spacing: 0) {
        ForEach(Array(items.prefix(itemCount).enumerated()), id: \.element.id) { index, item in
          SDGCustomHistory(
            index: index,
            totalCount: itemCount,
            dotColor: item.id == 1 ? .red300 : .primary300
          ) {
            header(item.title, date: "2026.09.23")
          } bodyArea: {
            VStack(alignment: .leading, spacing: 12) {
              Text(item.detail)
                .typo(.body2_R, .neutral700)
              if item.id == 1 {
                Button(isExpanded ? "상세 접기" : "상세 펼치기") {
                  isExpanded.toggle()
                }
                if isExpanded {
                  Text(String(repeating: "추가 점검 내역입니다. 콘텐츠가 늘어나면 타임라인도 함께 늘어납니다.\n", count: 4))
                    .typo(.body2_R, .neutral700)
                }
              }
            }
          }
        }
      }

      Text("Header만 있는 목록")
        .typo(.body1_SB, .neutral700)
      VStack(spacing: 0) {
        ForEach(Array(items.prefix(itemCount).enumerated()), id: \.element.id) { index, item in
          SDGCustomHistory(index: index, totalCount: itemCount) {
            header(item.title, date: "2026.09.23")
          }
        }
      }

      Text("단독 이력 · First → solo")
        .typo(.body1_SB, .neutral700)

      SDGCustomHistory(positionType: .solo, headerArea: {
        Text("Header만 있는 이력")
          .typo(.body1_SB, .neutral700)
      })

      SDGCustomHistory(positionType: .solo) {
        header("보고서 작성", date: "2026.09.23 13:00")
      } bodyArea: {
        Text("Header와 Body를 모두 표시하는 단독 이력입니다.")
          .typo(.body2_R, .neutral700)
      }
    }
    .padding(.horizontal, 16)
    .padding(.vertical, 20)
  }

  private func header(_ title: String, date: String) -> some View {
    VStack(alignment: .leading, spacing: 4) {
      Text(title)
        .typo(.body1_SB, .neutral700)
      Text(date)
        .typo(.body2_R, .neutral400)
    }
  }
}

#Preview {
  ScrollView { SDGCustomHistoryDemoView() }
}
