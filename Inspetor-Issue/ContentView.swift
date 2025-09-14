//
//  ContentView.swift
//  Inspetor-Issue
//
//  Created by ThreeManager785 on 2025/9/14.
//

import SwiftUI

let oneToFifty = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50]


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
                                Text("Lorem Ipsum Dolor Sit Amet #\(id)")
                                    .font(.largeTitle)
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
        Text("Item Detail #\(id)")
            .font(.largeTitle)
    }
}

struct InspectorView: View {
    var body: some View {
        Form {
            Section(content: {
                ForEach(oneToFifty, id: \.self) { key in
                   Text("\(key)")
                }
            })
        }
    }
}

// MARK: HereTheWorld
// This is a weird method that can sometimes fix some issues happening on SwiftUI.
// Would this be helpful?

/*
#if os(macOS)
/// Hi, what happened?
/// We NEED this to workaround a bug (maybe of SwiftUI?)
struct HereTheWorld<each T, V: View>: NSViewRepresentable {
    private var controller: NSViewController
    private var viewBuilder: (repeat each T) -> V
    init(arguments: (repeat each T) = (), @ViewBuilder view: @escaping (repeat each T) -> V) {
        self.controller = NSHostingController(rootView: view(repeat each arguments))
        self.viewBuilder = view
    }
    func makeNSView(context: Context) -> some NSView {
        self.controller.view
    }
    func updateNSView(_ nsView: NSViewType, context: Context) {}
    func updateArguments(_ arguments: (repeat each T)) {
        let newView = viewBuilder(repeat each arguments)
        controller.view = NSHostingView(rootView: newView)
    }
}
#else
/// Hi, what happened?
/// We NEED this to workaround a bug (maybe of SwiftUI?)
struct HereTheWorld<each T, V: View>: UIViewRepresentable {
    private var controller: UIViewController
    private var viewBuilder: (repeat each T) -> V
    init(arguments: (repeat each T) = (), @ViewBuilder view: @escaping (repeat each T) -> V) {
        self.controller = UIHostingController(rootView: view(repeat each arguments))
        self.viewBuilder = view
    }
    func makeUIView(context: Context) -> some UIView {
        self.controller.view
    }
    func updateUIView(_ nsView: UIViewType, context: Context) {}
    func updateArguments(_ arguments: (repeat each T)) {
        let newView = viewBuilder(repeat each arguments)
        let newUIViewController = UIHostingController(rootView: newView)
        let newUIView = newUIViewController.view
        newUIViewController.view = nil // detach
        controller.view = newUIView
    }
}
#endif
*/
