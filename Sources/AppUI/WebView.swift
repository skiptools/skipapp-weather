// An example of wrapping a custom iOS UIView and Android View
// using SwiftUI.UIViewRepresentable
// and androidx.compose.ui.viewinterop.AndroidView
import Foundation
#if SKIP
import AndroidWebkit
import AndroidxComposeRuntime
import AndroidxComposeUiViewinterop.AndroidView

@Composable func WebView(url: URL, enableJavaScript: Bool = true) {
    AndroidView(factory: { ctx in
        let webView = WebView(ctx)
        webView.webViewClient = WebViewClient()
        webView.settings.javaScriptEnabled = enableJavaScript
        webView.loadUrl(url.absoluteString)
        return webView
    })
}
#elseif canImport(UIKit)
import WebKit
import SwiftUI

struct WebView: UIViewRepresentable {
    let url: URL
    let cfg = WKWebViewConfiguration()

    init(url: URL, enableJavaScript: Bool = true) {
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
