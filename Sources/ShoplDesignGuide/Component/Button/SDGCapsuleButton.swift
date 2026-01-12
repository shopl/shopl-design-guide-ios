//
//  File.swift
//  ShoplDesignGuide
//
//  Created by Jerry on 9/1/25.
//

import SwiftUI

public struct SDGCapsuleButton: View {
  
  public struct Option {
    
    let size: SDGCapsuleButtonSize
    let icon: SDGButtonOptionIcon?
    let title: String
    let color: SDGButtonColor
    let selectedColor: SDGButtonColor
    let fullSize: Bool
    
    public init(
      size: SDGCapsuleButtonSize,
      icon: SDGButtonOptionIcon? = nil,
      title: String,
      color: SDGButtonColor,
      selectedColor: SDGButtonColor,
      fullSize: Bool = false
    ) {
      self.size = size
      self.icon = icon
      self.title = title
      self.color = color
      self.selectedColor = selectedColor
      self.fullSize = fullSize
    }
  }
  
  @Binding private var _isSelected: Bool
  
  private let _option: Option
  private let _isDisable: Bool
  private let _action: () -> Void
  private let _baseWidth: BaseWidth
  
  public enum BaseWidth {
    case infinity
    case textBase
  }
  
  @Binding private var _isLoading: Bool
  @State private var _progressFrame: CGRect = CGRect.zero
  
  public init(
    option: Option,
    isSelected: Binding<Bool>,
    isDisable: Bool = false,
    isLoading: Binding<Bool>,
    baseWidth: BaseWidth = .textBase,
    action: @escaping () -> Void
  ) {
    _option = option
    __isSelected = isSelected
    _isDisable = isDisable
    _action = action
    _baseWidth = baseWidth
    __isLoading = isLoading
  }
  
  public var body: some View {
    
    Button {
      _action()
    } label: {
      
      HStack(spacing: 4) {
        
        if _baseWidth == .infinity { Spacer() }
        
        switch _option.icon {
          case .left(let image, let color):
            
            image
              .resizable()
              .frame(width: 14, height: 14)
              .foregroundColor(color)
            
          default:
            EmptyView()
        }
        
        Text(_option.title)
          .font(.system(size: _option.size.fontSize, weight: .regular))
          .foregroundColor(_option.color.textColor)
        
        switch _option.icon {
          case .right(let image, let color):
            
            image
              .resizable()
              .frame(width: 14, height: 14)
              .foregroundColor(color)
            
          default:
            EmptyView()
        }
        
        if _baseWidth == .infinity { Spacer() }
        
      }
      .applyIf(_option.fullSize) {
        $0.frame(maxWidth: .infinity)
      }
      .padding(.vertical, _option.size.verticalPadding)
      .padding(.horizontal, _option.size.horizontalPadding)
      .background(_option.color.backgroundColor)
      .overlay {
        RoundedRectangle(cornerRadius: _option.size.cornerRadius)
          .strokeBorder(_option.color.lineColor, lineWidth: 1)
      }
      .frameGetter($_progressFrame)
      .applyIf(_isLoading) {
        $0.overlay(
          SDGProgressView(showMessage: false)
            .frame(width: _progressFrame.width - 2)
            .background(_option.color.backgroundColor)
        )
      }
    }
    .cornerRadius(_option.size.cornerRadius)
    .disabled(_isDisable)
    .buttonStyle(
      SDGBoxButtonStyle(
        isSelected: self.$_isSelected,
        cornerRadius: self._option.size.cornerRadius,
        defaultTextColor: self._option.color.textColor,
        selectedColor: self._option.selectedColor,
        isDisable: self._isDisable
      )
    )
    
  }
  
}


#Preview {
  TabView {
    VStack {
      HStack {
        
        VStack {
          
          Text("Solid")
          
          SDGCapsuleButton(
            option: .init(
              size: .medium,
              title: "테스트",
              color: .init(
                backgroundColor: .neutral200,
                textColor: .neutral600.opacity(0.3)
              ),
              selectedColor: .init(
                backgroundColor: .neutral600,
                textColor: .neutral0
              )
            ),
            isSelected: .constant(false),
            isLoading: .constant(false),
            action: {
              
            }
          )
          
          SDGCapsuleButton(
            option: .init(
              size: .medium,
              title: "테스트",
              color: .init(
                backgroundColor: .neutral200,
                textColor: .neutral600.opacity(0.3)
              ),
              selectedColor: .init(
                backgroundColor: .neutral600,
                textColor: .neutral0
              )
            ),
            isSelected: .constant(true),
            isDisable: true,
            isLoading: .constant(false),
            action: {
              
            }
          )
          
          SDGCapsuleButton(
            option: .init(
              size: .medium,
              icon: .left(image: Image(.icClip), color: .neutral600),
              title: "테스트",
              color: .init(
                backgroundColor: .neutral200,
                textColor: .neutral600.opacity(0.3)
              ),
              selectedColor: .init(
                backgroundColor: .neutral600,
                textColor: .neutral0
              )
            ),
            isSelected: .constant(true),
            isLoading: .constant(false),
            action: {
              
            }
          )
          
          SDGCapsuleButton(
            option: .init(
              size: .medium,
              icon: .left(image: Image(.icClip), color: .neutral600),
              title: "테스트",
              color: .init(
                backgroundColor: .neutral200,
                textColor: .neutral600.opacity(0.3)
              ),
              selectedColor: .init(
                backgroundColor: .neutral600,
                textColor: .neutral0
              )
            ),
            isSelected: .constant(true),
            isDisable: true,
            isLoading: .constant(false),
            action: {
              
            }
          )

          
          SDGCapsuleButton(
            option: .init(
              size: .medium,
              icon: .right(image: Image(.icClip), color: .neutral600),
              title: "테스트",
              color: .init(
                backgroundColor: .neutral200,
                textColor: .neutral600.opacity(0.3)
              ),
              selectedColor: .init(
                backgroundColor: .neutral600,
                textColor: .neutral0
              )
            ),
            isSelected: .constant(false),
            isLoading: .constant(false),
            action: {
              
            }
          )
          
          SDGCapsuleButton(
            option: .init(
              size: .medium,
              icon: .right(image: Image(.icClip), color: .neutral600),
              title: "테스트",
              color: .init(
                backgroundColor: .neutral200,
                textColor: .neutral600.opacity(0.3)
              ),
              selectedColor: .init(
                backgroundColor: .neutral600,
                textColor: .neutral0
              )
            ),
            isSelected: .constant(true),
            isDisable: true,
            isLoading: .constant(false),
            action: {
              
            }
          )
          
        }
        
        VStack {
          
          Text("Line")
          SDGCapsuleButton(
            option: .init(
              size: .medium,
              title: "테스트",
              color: .init(
                lineColor: .neutral250,
                backgroundColor: .neutral0,
                textColor: .neutral600
              ),
              selectedColor: .init(
                lineColor: .neutral600,
                backgroundColor: .neutral0,
                textColor: .neutral600
              )
            ),
            isSelected: .constant(false),
            isLoading: .constant(false),
            action: {
              
            }
          )
          
          SDGCapsuleButton(
            option: .init(
              size: .medium,
              title: "테스트",
              color: .init(
                lineColor: .neutral250,
                backgroundColor: .neutral0,
                textColor: .neutral600
              ),
              selectedColor: .init(
                lineColor: .neutral600,
                backgroundColor: .neutral0,
                textColor: .neutral600
              )
            ),
            isSelected: .constant(true),
            isDisable: true,
            isLoading: .constant(false),
            action: {
              
            }
          )
          
          SDGCapsuleButton(
            option: .init(
              size: .medium,
              icon: .left(image: Image(.icClip), color: .neutral600),
              title: "테스트",
              color: .init(
                lineColor: .neutral250,
                backgroundColor: .neutral0,
                textColor: .neutral600
              ),
              selectedColor: .init(
                lineColor: .neutral600,
                backgroundColor: .neutral0,
                textColor: .neutral600
              )
            ),
            isSelected: .constant(false),
            isLoading: .constant(false),
            action: {
              
            }
          )
          
          SDGCapsuleButton(
            option: .init(
              size: .medium,
              icon: .left(image: Image(.icClip), color: .neutral600),
              title: "테스트",
              color: .init(
                lineColor: .neutral250,
                backgroundColor: .neutral0,
                textColor: .neutral600
              ),
              selectedColor: .init(
                lineColor: .neutral600,
                backgroundColor: .neutral0,
                textColor: .neutral600
              )
            ),
            isSelected: .constant(true),
            isDisable: true,
            isLoading: .constant(false),
            action: {
              
            }
          )
          
          SDGCapsuleButton(
            option: .init(
              size: .medium,
              icon: .right(image: Image(.icClip), color: .neutral600),
              title: "테스트",
              color: .init(
                lineColor: .neutral250,
                backgroundColor: .neutral0,
                textColor: .neutral600
              ),
              selectedColor: .init(
                lineColor: .neutral600,
                backgroundColor: .neutral0,
                textColor: .neutral600
              )
            ),
            isSelected: .constant(false),
            isLoading: .constant(false),
            action: {
              
            }
          )
          
          SDGCapsuleButton(
            option: .init(
              size: .medium,
              icon: .right(image: Image(.icClip), color: .neutral600),
              title: "테스트",
              color: .init(
                lineColor: .neutral250,
                backgroundColor: .neutral0,
                textColor: .neutral600
              ),
              selectedColor: .init(
                lineColor: .neutral600,
                backgroundColor: .neutral0,
                textColor: .neutral600
              )
            ),
            isSelected: .constant(true),
            isDisable: true,
            isLoading: .constant(false),
            action: {
              
            }
          )
        }
      }
      
      Text("Solid")
      
      SDGCapsuleButton(
        option: .init(
          size: .medium,
          icon: .left(image: Image(.icClip), color: .neutral600),
          title: "테스트",
          color: .init(
            lineColor: .neutral250,
            backgroundColor: .neutral0,
            textColor: .neutral600
          ),
          selectedColor: .init(
            lineColor: .neutral600,
            backgroundColor: .neutral0,
            textColor: .neutral600
          ),
          fullSize: true
        ),
        isSelected: .constant(false),
        isLoading: .constant(false),
        action: {
          
        }
      )
      
      Text("Line")
      
      SDGCapsuleButton(
        option: .init(
          size: .medium,
          icon: .right(image: Image(.icClip), color: .neutral600),
          title: "테스트",
          color: .init(
            lineColor: .neutral250,
            backgroundColor: .neutral0,
            textColor: .neutral600
          ),
          selectedColor: .init(
            lineColor: .neutral600,
            backgroundColor: .neutral0,
            textColor: .neutral600
          ),
          fullSize: true
        ),
        isSelected: .constant(true),
        isLoading: .constant(false),
        action: {
          
        }
      )
      
    }
    .padding(.horizontal, 10)
    .tabItem {
      Text("Medium")
    }
    
    VStack {
      HStack {
        
        VStack {
          
          Text("Solid")
          
          SDGCapsuleButton(
            option: .init(
              size: .small,
              title: "테스트",
              color: .init(
                backgroundColor: .neutral200,
                textColor: .neutral600.opacity(0.3)
              ),
              selectedColor: .init(
                backgroundColor: .neutral600,
                textColor: .neutral0
              )
            ),
            isSelected: .constant(false),
            isLoading: .constant(false),
            action: {
              
            }
          )
          
          SDGCapsuleButton(
            option: .init(
              size: .small,
              title: "테스트",
              color: .init(
                backgroundColor: .neutral200,
                textColor: .neutral600.opacity(0.3)
              ),
              selectedColor: .init(
                backgroundColor: .neutral600,
                textColor: .neutral0
              )
            ),
            isSelected: .constant(true),
            isDisable: true,
            isLoading: .constant(false),
            action: {
              
            }
          )
          
          SDGCapsuleButton(
            option: .init(
              size: .small,
              icon: .left(image: Image(.icClip), color: .neutral600),
              title: "테스트",
              color: .init(
                backgroundColor: .neutral200,
                textColor: .neutral600.opacity(0.3)
              ),
              selectedColor: .init(
                backgroundColor: .neutral600,
                textColor: .neutral0
              )
            ),
            isSelected: .constant(false),
            isLoading: .constant(false),
            action: {
              
            }
          )
          
          SDGCapsuleButton(
            option: .init(
              size: .small,
              icon: .left(image: Image(.icClip), color: .neutral600),
              title: "테스트",
              color: .init(
                backgroundColor: .neutral200,
                textColor: .neutral600.opacity(0.3)
              ),
              selectedColor: .init(
                backgroundColor: .neutral600,
                textColor: .neutral0
              )
            ),
            isSelected: .constant(true),
            isDisable: true,
            isLoading: .constant(false),
            action: {
              
            }
          )
          
          SDGCapsuleButton(
            option: .init(
              size: .small,
              icon: .right(image: Image(.icClip), color: .neutral600),
              title: "테스트",
              color: .init(
                backgroundColor: .neutral200,
                textColor: .neutral600.opacity(0.3)
              ),
              selectedColor: .init(
                backgroundColor: .neutral600,
                textColor: .neutral0
              )
            ),
            isSelected: .constant(false),
            isLoading: .constant(false),
            action: {
              
            }
          )
          
          SDGCapsuleButton(
            option: .init(
              size: .small,
              icon: .right(image: Image(.icClip), color: .neutral600),
              title: "테스트",
              color: .init(
                backgroundColor: .neutral200,
                textColor: .neutral600.opacity(0.3)
              ),
              selectedColor: .init(
                backgroundColor: .neutral600,
                textColor: .neutral0
              )
            ),
            isSelected: .constant(true),
            isDisable: true,
            isLoading: .constant(false),
            action: {
              
            }
          )
          
        }
        
        VStack {
          
          Text("Line")
          SDGCapsuleButton(
            option: .init(
              size: .small,
              title: "테스트",
              color: .init(
                lineColor: .neutral250,
                backgroundColor: .neutral0,
                textColor: .neutral600
              ),
              selectedColor: .init(
                lineColor: .neutral600,
                backgroundColor: .neutral0,
                textColor: .neutral600
              )
            ),
            isSelected: .constant(false),
            isLoading: .constant(false),
            action: {
              
            }
          )
          
          SDGCapsuleButton(
            option: .init(
              size: .small,
              title: "테스트",
              color: .init(
                lineColor: .neutral250,
                backgroundColor: .neutral0,
                textColor: .neutral600
              ),
              selectedColor: .init(
                lineColor: .neutral600,
                backgroundColor: .neutral0,
                textColor: .neutral600
              )
            ),
            isSelected: .constant(true),
            isDisable: true,
            isLoading: .constant(false),
            action: {
              
            }
          )
          
          SDGCapsuleButton(
            option: .init(
              size: .small,
              icon: .left(image: Image(.icClip), color: .neutral600),
              title: "테스트",
              color: .init(
                lineColor: .neutral250,
                backgroundColor: .neutral0,
                textColor: .neutral600
              ),
              selectedColor: .init(
                lineColor: .neutral600,
                backgroundColor: .neutral0,
                textColor: .neutral600
              )
            ),
            isSelected: .constant(false),
            isLoading: .constant(true),
            action: {
              
            }
          )
          
          SDGCapsuleButton(
            option: .init(
              size: .small,
              icon: .left(image: Image(.icClip), color: .neutral600),
              title: "테스트",
              color: .init(
                lineColor: .neutral250,
                backgroundColor: .neutral0,
                textColor: .neutral600
              ),
              selectedColor: .init(
                lineColor: .neutral600,
                backgroundColor: .neutral0,
                textColor: .neutral600
              )
            ),
            isSelected: .constant(true),
            isDisable: true,
            isLoading: .constant(true),
            action: {
              
            }
          )
          
          SDGCapsuleButton(
            option: .init(
              size: .small,
              icon: .right(image: Image(.icClip), color: .neutral600),
              title: "테스트",
              color: .init(
                lineColor: .neutral250,
                backgroundColor: .neutral0,
                textColor: .neutral600
              ),
              selectedColor: .init(
                lineColor: .neutral600,
                backgroundColor: .neutral0,
                textColor: .neutral600
              )
            ),
            isSelected: .constant(false),
            isLoading: .constant(true),
            action: {
              
            }
          )
          
          SDGCapsuleButton(
            option: .init(
              size: .medium,
              icon: .right(image: Image(.icClip), color: .neutral600),
              title: "테스트",
              color: .init(
                lineColor: .neutral250,
                backgroundColor: .neutral0,
                textColor: .neutral600
              ),
              selectedColor: .init(
                lineColor: .neutral600,
                backgroundColor: .neutral0,
                textColor: .neutral600
              )
            ),
            isSelected: .constant(true),
            isDisable: true,
            isLoading: .constant(true),
            action: {
              
            }
          )
        }
      }
      
      Text("Solid")
      
      SDGCapsuleButton(
        option: .init(
          size: .small,
          icon: .left(image: Image(.icClip), color: .neutral600),
          title: "테스트",
          color: .init(
            backgroundColor: .neutral200,
            textColor: .neutral600.opacity(0.3)
          ),
          selectedColor: .init(
            backgroundColor: .neutral600,
            textColor: .neutral0
          ),
          fullSize: true
        ),
        isSelected: .constant(false),
        isLoading: .constant(true),
        action: {
          
        }
      )
      
      Text("Line")
      
      SDGCapsuleButton(
        option: .init(
          size: .small,
          icon: .right(image: Image(.icClip), color: .neutral600),
          title: "테스트",
          color: .init(
            backgroundColor: .neutral200,
            textColor: .neutral600.opacity(0.3)
          ),
          selectedColor: .init(
            backgroundColor: .neutral600,
            textColor: .neutral0
          ),
          fullSize: true
        ),
        isSelected: .constant(true),
        isLoading: .constant(true),
        action: {
          
        }
      )
      
    }
    .padding(.horizontal, 10)
    .tabItem {
      Text("Small")
    }
    
    VStack {
      HStack {
        
        VStack {
          
          Text("Solid")
          
          SDGCapsuleButton(
            option: .init(
              size: .xsmall,
              title: "테스트",
              color: .init(
                backgroundColor: .neutral200,
                textColor: .neutral600.opacity(0.3)
              ),
              selectedColor: .init(
                backgroundColor: .neutral600,
                textColor: .neutral0
              )
            ),
            isSelected: .constant(false),
            isLoading: .constant(true),
            action: {
              
            }
          )
          
          SDGCapsuleButton(
            option: .init(
              size: .xsmall,
              title: "테스트",
              color: .init(
                backgroundColor: .neutral200,
                textColor: .neutral600.opacity(0.3)
              ),
              selectedColor: .init(
                backgroundColor: .neutral600,
                textColor: .neutral0
              )
            ),
            isSelected: .constant(true),
            isDisable: true,
            isLoading: .constant(true),
            action: {
              
            }
          )
          
          SDGCapsuleButton(
            option: .init(
              size: .xsmall,
              icon: .left(image: Image(.icClip), color: .neutral600),
              title: "테스트",
              color: .init(
                backgroundColor: .neutral200,
                textColor: .neutral600.opacity(0.3)
              ),
              selectedColor: .init(
                backgroundColor: .neutral600,
                textColor: .neutral0
              )
            ),
            isSelected: .constant(false),
            isLoading: .constant(true),
            action: {
              
            }
          )
          
          SDGCapsuleButton(
            option: .init(
              size: .xsmall,
              icon: .left(image: Image(.icClip), color: .neutral600),
              title: "테스트",
              color: .init(
                backgroundColor: .neutral200,
                textColor: .neutral600.opacity(0.3)
              ),
              selectedColor: .init(
                backgroundColor: .neutral600,
                textColor: .neutral0
              )
            ),
            isSelected: .constant(true),
            isDisable: true,
            isLoading: .constant(true),
            action: {
              
            }
          )
          
          SDGCapsuleButton(
            option: .init(
              size: .xsmall,
              icon: .right(image: Image(.icClip), color: .neutral600),
              title: "테스트",
              color: .init(
                backgroundColor: .neutral200,
                textColor: .neutral600.opacity(0.3)
              ),
              selectedColor: .init(
                backgroundColor: .neutral600,
                textColor: .neutral0
              )
            ),
            isSelected: .constant(false),
            isLoading: .constant(true),
            action: {
              
            }
          )
          
          SDGCapsuleButton(
            option: .init(
              size: .xsmall,
              icon: .right(image: Image(.icClip), color: .neutral600),
              title: "테스트",
              color: .init(
                backgroundColor: .neutral200,
                textColor: .neutral600.opacity(0.3)
              ),
              selectedColor: .init(
                backgroundColor: .neutral600,
                textColor: .neutral0
              )
            ),
            isSelected: .constant(true),
            isDisable: true,
            isLoading: .constant(true),
            action: {
              
            }
          )
          
        }
        
        VStack {
          
          Text("Line")
          SDGCapsuleButton(
            option: .init(
              size: .xsmall,
              title: "테스트",
              color: .init(
                lineColor: .neutral250,
                backgroundColor: .neutral0,
                textColor: .neutral600
              ),
              selectedColor: .init(
                lineColor: .neutral600,
                backgroundColor: .neutral0,
                textColor: .neutral600
              )
            ),
            isSelected: .constant(false),
            isLoading: .constant(true),
            action: {
              
            }
          )
          
          SDGCapsuleButton(
            option: .init(
              size: .xsmall,
              title: "테스트",
              color: .init(
                lineColor: .neutral250,
                backgroundColor: .neutral0,
                textColor: .neutral600
              ),
              selectedColor: .init(
                lineColor: .neutral600,
                backgroundColor: .neutral0,
                textColor: .neutral600
              )
            ),
            isSelected: .constant(true),
            isDisable: true,
            isLoading: .constant(true),
            action: {
              
            }
          )
          
          SDGCapsuleButton(
            option: .init(
              size: .xsmall,
              icon: .left(image: Image(.icClip), color: .neutral600),
              title: "테스트",
              color: .init(
                lineColor: .neutral250,
                backgroundColor: .neutral0,
                textColor: .neutral600
              ),
              selectedColor: .init(
                lineColor: .neutral600,
                backgroundColor: .neutral0,
                textColor: .neutral600
              )
            ),
            isSelected: .constant(false),
            isLoading: .constant(true),
            action: {
              
            }
          )
          
          SDGCapsuleButton(
            option: .init(
              size: .xsmall,
              icon: .left(image: Image(.icClip), color: .neutral600),
              title: "테스트",
              color: .init(
                lineColor: .neutral250,
                backgroundColor: .neutral0,
                textColor: .neutral600
              ),
              selectedColor: .init(
                lineColor: .neutral600,
                backgroundColor: .neutral0,
                textColor: .neutral600
              )
            ),
            isSelected: .constant(true),
            isDisable: true,
            isLoading: .constant(true),
            action: {
              
            }
          )
          
          SDGCapsuleButton(
            option: .init(
              size: .xsmall,
              icon: .right(image: Image(.icClip), color: .neutral600),
              title: "테스트",
              color: .init(
                lineColor: .neutral250,
                backgroundColor: .neutral0,
                textColor: .neutral600
              ),
              selectedColor: .init(
                lineColor: .neutral600,
                backgroundColor: .neutral0,
                textColor: .neutral600
              )
            ),
            isSelected: .constant(false),
            isLoading: .constant(true),
            action: {
              
            }
          )
          
          SDGCapsuleButton(
            option: .init(
              size: .xsmall,
              icon: .right(image: Image(.icClip), color: .neutral600),
              title: "테스트",
              color: .init(
                lineColor: .neutral250,
                backgroundColor: .neutral0,
                textColor: .neutral600
              ),
              selectedColor: .init(
                lineColor: .neutral600,
                backgroundColor: .neutral0,
                textColor: .neutral600
              )
            ),
            isSelected: .constant(true),
            isDisable: true,
            isLoading: .constant(true),
            action: {
              
            }
          )
        }
      }
      
      Text("Solid")
      
      SDGCapsuleButton(
        option: .init(
          size: .xsmall,
          icon: .left(image: Image(.icClip), color: .neutral600),
          title: "테스트",
          color: .init(
            backgroundColor: .neutral200,
            textColor: .neutral600.opacity(0.3)
          ),
          selectedColor: .init(
            backgroundColor: .neutral600,
            textColor: .neutral0
          ),
          fullSize: true
        ),
        isSelected: .constant(false),
        isLoading: .constant(true),
        action: {
          
        }
      )
      
      Text("Line")
      
      SDGCapsuleButton(
        option: .init(
          size: .xsmall,
          icon: .right(image: Image(.icClip), color: .neutral600),
          title: "테스트",
          color: .init(
            backgroundColor: .neutral200,
            textColor: .neutral600.opacity(0.3)
          ),
          selectedColor: .init(
            backgroundColor: .neutral600,
            textColor: .neutral0
          ),
          fullSize: true
        ),
        isSelected: .constant(true),
        isLoading: .constant(true),
        action: {
          
        }
      )
      
    }
    .padding(.horizontal, 10)
    .tabItem {
      Text("XSmall")
    }
  }
}

