import Foundation
#if SKIP
import AndroidWebkit
import AndroidxComposeRuntime
import AndroidxComposeUiViewinterop.AndroidView

@Composable
func WebView(url: URL, enableJavaScript: Bool = javaScriptEnabled) {
    AndroidView(factory: { context in
        WebView(context).apply {
            webViewClient = WebViewClient()
            settings.javaScriptEnabled = enableJavaScript
            loadUrl(url.absoluteString)
        }
    })
}
#elseif canImport(UIKit)
import WebKit
import SwiftUI
struct WebView: UIViewRepresentable {
    let url: URL
    let cfg = WKWebViewConfiguration()

    init(url: URL, enableJavaScript: Bool = javaScriptEnabled) {
        self.url = url
        cfg.defaultWebpagePreferences.allowsContentJavaScript = enableJavaScript
    }

    func makeUIView(context: Context) -> WKWebView {
        WKWebView(frame: .zero, configuration: cfg)
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.load(URLRequest(url: url))
    }
}
#endif

/// Whether JavaScript should be enabled by default in embedded web views.
let javaScriptEnabled = true

