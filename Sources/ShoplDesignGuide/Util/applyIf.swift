//
//  File.swift
//  ShoplDesignGuide
//
//  Created by Jerry on 5/30/25.
//

import SwiftUI

public extension View {
  @ViewBuilder
  func applyIf<T: View>(_ condition: Bool, apply: (Self) -> T) -> some View {
    if condition {
      apply(self)
    } else {
      self
    }
  }
  
  @ViewBuilder
  func applyiOS15<T: View>(apply: (Self) -> T) -> some View {
    if #available(iOS 15, *) {
      apply(self)
    } else {
      self
    }
  }
  
  @ViewBuilder
  func applyiOS16<T: View>(apply: (Self) -> T) -> some View {
    if #available(iOS 16, *) {
      apply(self)
    } else {
      self
    }
  }
  
  @ViewBuilder
  func applyUnderiOS17<T: View>(apply: (Self) -> T) -> some View {
    if #unavailable(iOS 17) {
      apply(self)
    } else {
      self
    }
  }
  
  @ViewBuilder
  func applyWithoutiOS17<T: View>(apply: (Self) -> T) -> some View {
    if #available(iOS 18.0, *) {
      apply(self)
    }
    
    if #unavailable(iOS 17) {
      if #available(iOS 16.0, *) {
        apply(self)
      } else {
        self
      }
    } else {
      self
    }
  }
  
  @ViewBuilder
  func applyExactlyiOS16<T: View>(apply: (Self) -> T) -> some View {
    if #unavailable(iOS 17) {
      if #available(iOS 16.0, *) {
        apply(self)
      } else {
        self
      }
    } else {
      self
    }
  }
  
  @ViewBuilder
  func apply<T: View>(_ apply: (Self) -> T) -> some View {
    apply(self)
  }
}

