import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            ChatView()
                .tabItem {
                    Label("Chat", systemImage: "message.fill")
                }

            TodayView()
                .tabItem {
                    Label("Today", systemImage: "calendar")
                }

            HistoryView()
                .tabItem {
                    Label("History", systemImage: "chart.bar.fill")
                }
        }
    }
}

#Preview {
    MainTabView()
}
