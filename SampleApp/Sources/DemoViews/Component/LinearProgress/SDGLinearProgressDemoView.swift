//
//  SDGLinearProgressDemoView.swift
//  ShoplDesignGuide
//

import SwiftUI
import ShoplDesignGuide

struct SDGLinearProgressDemoView: View {
  private enum Mode: String, CaseIterable {
    case determinate = "진행률"
    case indeterminate = "반복 로딩"
  }

  @State private var mode: Mode = .determinate
  @State private var progress = 0.5
  @State private var showsLabel = true
  @State private var usesLongLabel = false
  @State private var usesPrimaryLabel = false

  var body: some View {
    VStack(alignment: .leading, spacing: 16) {
      Text("Type")
        .typo(.body2_SB, .neutral700)

      Picker("동작 타입", selection: $mode) {
        ForEach(Mode.allCases, id: \.self) { mode in
          Text(mode.rawValue).tag(mode)
        }
      }
      .pickerStyle(.segmented)

      SDGLinearProgress(
        type: mode == .determinate ? .determinate(progress) : .indeterminate,
        label: showsLabel ? label : nil,
        labelColor: usesPrimaryLabel ? .primary300 : .neutral700
      )
      .padding(.vertical, 40)
      .frame(maxWidth: .infinity, minHeight: 140)
      .background(Color.neutral150)
      .clipShape(RoundedRectangle(cornerRadius: SDGCornerRadius.radius8.rawValue))

      Toggle("Label 표시", isOn: $showsLabel)
      Toggle("긴 Label (자동 줄바꿈)", isOn: $usesLongLabel)
        .disabled(!showsLabel)
      Toggle("Label 색상: Primary/300", isOn: $usesPrimaryLabel)
        .disabled(!showsLabel)

      if mode == .determinate {
        HStack {
          Text("진행률")
          Spacer()
          Text(progress, format: .percent.precision(.fractionLength(0)))
            .monospacedDigit()
        }
        Slider(value: $progress, in: 0...1)
          .accessibilityLabel("진행률")
        HStack {
          Button("초기화 (0%)") { progress = 0 }
          Spacer()
          Button("완료 (100%)") { progress = 1 }
        }
      }
    }
    .padding(.horizontal, 16)
    .padding(.top, 16)
    .padding(.bottom, 40)
    .frame(maxWidth: .infinity, alignment: .leading)
  }

  private var label: String {
    if usesLongLabel {
      return "데이터를 불러오고 있습니다. 잠시만 기다려 주세요. 작업이 완료되면 결과를 안내해 드립니다."
    }
    return mode == .determinate ? "업로드 중입니다" : "데이터 불러오는 중..."
  }
}
