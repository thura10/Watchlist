//
//  StackNavigationView.swift
//  Watchlist (macOS)
//
//  Created by Thura Soe Win on 25/5/21.
//

import SwiftUI

struct StackNavigationView<RootContent, SubviewContent>: View where RootContent: View, SubviewContent: View {
    
    @Binding var currentSubviewIndex: Int
    @Binding var showingSubview: Bool
    let subviewByIndex: (Int) -> SubviewContent
    let rootView: () -> RootContent
    
    var body: some View {
        VStack {
            VStack{
                if !showingSubview { // Root view
                    rootView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .transition(AnyTransition.move(edge: .leading)).animation(.default)
                }
                if showingSubview { // Correct subview for current index
                    StackNavigationSubview(isVisible: self.$showingSubview) {
                        self.subviewByIndex(self.currentSubviewIndex)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .transition(AnyTransition.move(edge: .trailing)).animation(.default)
                }
            }
        }
    }
    
    init(currentSubviewIndex: Binding<Int>, showingSubview: Binding<Bool>, @ViewBuilder subviewByIndex: @escaping (Int) -> SubviewContent, @ViewBuilder rootView: @escaping () -> RootContent) {
        self._currentSubviewIndex = currentSubviewIndex
        self._showingSubview = showingSubview
        self.subviewByIndex = subviewByIndex
        self.rootView = rootView
    }
    
    private struct StackNavigationSubview<Content>: View where Content: View {
        
        @Binding var isVisible: Bool
        let contentView: () -> Content
        
        var body: some View {
            VStack {
                HStack { // Back button
                    Button(action: {
                        self.isVisible = false
                    }) {
                        Image(systemName: "chevron-backward")
                    }.buttonStyle(BorderlessButtonStyle())
                    Spacer()
                }
                .padding(.horizontal).padding(.vertical, 4)
                contentView() // Main view content
            }
        }
    }
}
