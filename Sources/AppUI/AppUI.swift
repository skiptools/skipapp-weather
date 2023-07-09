import Foundation
import AppModel

#if !SKIP
import SwiftUI

public struct ContentView: View {
    public init() {
    }

    public var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
}

#else
// SKIP INSERT: import android.app.Application
// SKIP INSERT: import androidx.appcompat.app.AppCompatActivity
// SKIP INSERT: import androidx.compose.runtime.*
// SKIP INSERT: import androidx.activity.compose.*
// SKIP INSERT: import androidx.compose.ui.*
// SKIP INSERT: import androidx.compose.ui.unit.*
// SKIP INSERT: import androidx.compose.ui.geometry.*
// SKIP INSERT: import androidx.compose.ui.graphics.*
// SKIP INSERT: import androidx.compose.ui.layout.*
// SKIP INSERT: import androidx.compose.ui.text.*
// SKIP INSERT: import androidx.compose.ui.text.style.*
// SKIP INSERT: import androidx.compose.foundation.*
// SKIP INSERT: import androidx.compose.foundation.shape.*
// SKIP INSERT: import androidx.compose.foundation.layout.*
// SKIP INSERT: import androidx.compose.foundation.lazy.*
// SKIP INSERT: import androidx.compose.material.*

import AppModel

public class AndroidAppMain : android.app.Application {
    public init() {
    }

    public override func onCreate() {
        super.onCreate()
        ProcessInfo.launch(applicationContext)
    }
}

public class MainActivity : androidx.appcompat.app.AppCompatActivity {
    public init() {
    }

    public override func onCreate(savedInstanceState: android.os.Bundle?) {
        super.onCreate(savedInstanceState)
        setContent {
            MaterialTheme {
                //RootView()
            }
        }
    }
}

#endif

