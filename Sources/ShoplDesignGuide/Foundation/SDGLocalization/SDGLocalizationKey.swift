//
//  File.swift
//  ShoplDesignGuide
//
//  Created by Jerry on 8/12/25.
//

import Foundation

@MainActor
public enum SDGLocalizationKey: String, CaseIterable {
  /// 일
  case text_day
  /// 확인
  case confirm
  /// 교육
  case schedule_training
  /// 없음
  case none
  /// 근무
  case schedule_work
  /// 휴무
  case schedule_dayof
  /// 시작
  case start
  /// 사유
  case reason
  /// 끝
  case end
  /// 스케줄
  case schedule
  /// 출퇴근
  case punch_inout
  /// 선택
  case selected2
  /// 휴가
  case schedule_leave
  /// 오늘
  case today
  /// %@시간 %@분
  case quitting_limit_time
  /// %@시간
  case cm_time_h_iOS
  /// 배정
  case assigned
  /// 승인 대기 중
  case waiting_approval
  /// 취소
  case cancel
  /// 지정 근무지 없음
  case no_workplace
  /// 월
  case cm_weekday_mo
  /// 화
  case cm_weekday_tu
  /// 수
  case cm_weekday_we
  /// 목
  case cm_weekday_th
  /// 금
  case cm_weekday_fr
  /// 토
  case cm_weekday_su
  /// 일
  case working_hours_sun
  /// 기타
  case schedule_etc
  /// 일정없음
  case no_schedule
  /// 반차
  case half_day_leave
  /// 입력하세요
  case plzInput
  /// Google 번역
  case google_translate
  /// 출퇴근 기록이 없습니다.
  case trace_record_empty
  /// 초과근무
  case overtime
  /// 반반차
  case quarter_day_leave
  /// 임시 근무지
  case temp_workplace
  /// 메모
  case approved_memo
  /// 주
  case date_type_weekly
  /// 월
  case date_type_monthly
  /// 고정 근무지
  case basic_workplace
  /// %@일
  case repeat_day_format
  /// 담당 근무지
  case assigned_workplace
  /// 등록된 구성원이 없습니다
  case no_registered_members
  ///퇴사
  case resign_title
  ///탈퇴
  case delete_account
  ///데이터 로딩 중
  case loading_message
  
  var string: String {
    return SDGString.shared.getSDGString(key: self)
  }
}
