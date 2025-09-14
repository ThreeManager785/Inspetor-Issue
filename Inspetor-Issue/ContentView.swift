//
//  ContentView.swift
//  Inspetor-Issue
//
//  Created by ThreeManager785 on 2025/9/14.
//

import SwiftUI

let oneToFifty = 1...50


struct ContentView: View {
    var body: some View {
        NavigationStack {
            EventSearchView()
        }
    }
}


//MARK: EventSearchView
struct EventSearchView: View {
    @State var searchedText = ""
    @State var showInspector = false
    @State var presentingItemID: Int?
    @Namespace var customNamespace
    var body: some View {
        Group {
            ScrollView {
                HStack {
//                    Spacer(minLength: 0)
                    LazyVStack(spacing: 10) {
                        ForEach(oneToFifty, id: \.self) { id in
                            Button(action: {
                                showInspector = false
                                presentingItemID = id
                            }, label: {
                                ZStack {
                                    Rectangle()
                                        .foregroundStyle(colorForNumber(id))
                                        .opacity(0.4)
                                    Text("Lorem Ipsum Dolor Sit Amet #\(id)")
                                        .font(.largeTitle)
                                }
                            })
                            .buttonStyle(.bordered)
                            .matchedTransitionSource(id: id, in: customNamespace)
                            .matchedGeometryEffect(id: id, in: customNamespace)
                        }
                    }
//                    .frame(maxWidth: 300)
                }
                .padding(.horizontal)
//                Spacer(minLength: 0)
            }
            .navigationDestination(item: $presentingItemID) { id in
#if os(iOS)
                EventDetailView(id: id)
                    .navigationTransition(.zoom(sourceID: id, in: customNamespace))
#else
                EventDetailView(id: id)
#endif
            }
        }
        .searchable(text: $searchedText, prompt: "Placeholder")
        .navigationTitle("Event")
        .navigationSubtitle("Subtitle")
        .toolbar {
            ToolbarItem {
                Button(action: {
                    showInspector = true
                }, label: {
                    Image(systemName: "exclamationmark")
                })
            }
        }
        .onDisappear {
            showInspector = false
        }
        .withSystemBackground()
        .inspector(isPresented: $showInspector) {
            InspectorView()
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
                .presentationBackgroundInteraction(.enabled)
        }
        .withSystemBackground() // This modifier MUST be placed BOTH before
                                // and after `inspector` to make it work as expected
    }
}


public extension View {
    @ViewBuilder
    func withSystemBackground() -> some View {
#if os(iOS)
        self
            .background(Color(.systemGroupedBackground))
#else
        self
#endif
    }
}


struct EventDetailView: View {
    var id: Int
    var body: some View {
        ZStack {
            // Demonstation Purpose Only. The image can be removed.
            Image("Demo-picture")
                .resizable()
                .scaledToFill()
                .opacity(0.4)
            Text("Item Detail #\(id)")
                .font(.largeTitle)
        }
        
    }
}

struct InspectorView: View {
    var body: some View {
        Form {
            Section(content: {
                // Inspector items don't have matching relationship with the items in the `LazyVStack`. `oneToFifty` is for demonstation purpose only.
                ForEach(oneToFifty, id: \.self) { id in
                    ZStack {
                        Rectangle()
                            .foregroundStyle(colorForNumber(50-id+1))
                            .opacity(0.4)
                        Text("Item #\(id)")
                            .font(.largeTitle)
                    }
                }
            })
        }
    }
}


// Demonstration purpose only: to emphasize the difference between list items.
// This is not important at all.
func colorForNumber(_ n: Int) -> Color {
    precondition((1...50).contains(n))
    
    let count = 50
    // 交错分布：把索引映射成一个“二分交错”的序列
    func interleave(_ i: Int) -> Int {
        var x = i - 1
        var result = 0
        var bit = 1
        var mask = count / 2
        while mask > 0 {
            if (x & 1) != 0 {
                result += mask
            }
            x >>= 1
            mask >>= 1
            bit <<= 1
        }
        return result
    }
    
    let permutedIndex = interleave(n)
    let hue = Double(permutedIndex) / Double(count)
    return Color(hue: hue, saturation: 0.8, brightness: 0.9)
}
