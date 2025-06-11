//
//  FocusableTextField.swift
//  ShoplDesignGuide
//
//  Created by Jerry on 5/30/25.
//

import SwiftUI

public struct FocusableTextField: UIViewRepresentable {
  
  private let placeholder: Binding<String>?
  @Binding private var text: String
  private let isFocused: Binding<Bool>?
  private var returnAction: (() -> Void)?

  public init(
    placeholder: Binding<String>? = nil,
    text: Binding<String>,
    isFocused: Binding<Bool>?,
    returnAction: (() -> Void)? = nil
  ) {
    self.placeholder = placeholder
    self._text = text
    self.isFocused = isFocused
    self.returnAction = returnAction
  }
  
  public func makeUIView(context: Context) -> UITextField {
    let textField = UITextField()
    textField.placeholder = placeholder?.wrappedValue
    textField.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    textField.delegate = context.coordinator
    textField.autocorrectionType = .no
    textField.textColor = .neutral700
    textField.font = .systemFont(ofSize: 14, weight: .regular)
    textField.keyboardType = .default
    return textField
  }
  
  public func updateUIView(_ uiView: UITextField, context: Context) {
    if let isFocused = self.isFocused?.wrappedValue,
       uiView.isFirstResponder != isFocused {
      DispatchQueue.main.async {
        if isFocused && !uiView.isFirstResponder {
          uiView.becomeFirstResponder()
        } else if !isFocused && uiView.isFirstResponder {
          uiView.resignFirstResponder()
        }
      }
    }
    
    if text != uiView.text {
      uiView.text = text
    }
    
    if placeholder?.wrappedValue != uiView.placeholder {
      uiView.placeholder = placeholder?.wrappedValue
    }
  }
  
  public func makeCoordinator() -> Coordinator {
    Coordinator(self)
  }
  
  public class Coordinator: NSObject, UITextFieldDelegate {
    
    private let parent: FocusableTextField
    
    init(_ parent: FocusableTextField) {
      self.parent = parent
    }
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
      self.parent.isFocused?.wrappedValue = true
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
      self.parent.isFocused?.wrappedValue = false
    }
    
    public func textFieldDidChangeSelection(_ textField: UITextField) {
      if parent.text != textField.text {
        DispatchQueue.main.async {
          self.parent.text = textField.text ?? ""
        }
      }
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
      parent.returnAction?()
      textField.resignFirstResponder()
      return true
    }
  }
}
