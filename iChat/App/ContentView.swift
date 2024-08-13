import SwiftUI

struct ContentView: View {
    @State private var endSplash = true
    @ObservedObject private var appState = AppState()
    @ObservedObject private var userInfo = UserInfo()
    @StateObject private var navigationStore = NavigationStore()

    var body: some View {
        NavigationView {
            if endSplash {
                SplashView()
            } else if appState.isAuthenticated {
                NavigationStack(path: $navigationStore.path) {
                    HomeView()
                        .environmentObject(navigationStore)
                        .environmentObject(appState)
                        .environmentObject(userInfo)
                        .navigationDestination(for: NavigationDestination.self) { path in
                            path
                                .view
                                .environmentObject(navigationStore)
                                .environmentObject(appState)
                                .environmentObject(userInfo)
                        }
                }
            } else {
                NavigationStack(path: $navigationStore.path) {
                    LoginView()
                        .environmentObject(navigationStore)
                        .environmentObject(appState)
                        .environmentObject(userInfo)
                        .navigationDestination(for: NavigationDestination.self) { path in
                            path
                                .view
                                .environmentObject(navigationStore)
                                .environmentObject(appState)
                                .environmentObject(userInfo)
                        }
                }
            }
        }
        .onAppear(perform: {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                endSplash = false
            }
        })
    }
}

#Preview {
    ContentView()
}
