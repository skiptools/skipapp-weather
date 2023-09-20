// An example of wrapping a custom iOS UIView and Android View
// using SwiftUI.UIViewRepresentable
// and androidx.compose.ui.viewinterop.AndroidView
import SwiftUI
#if canImport(UIKit)
import WebKit

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
#elseif canImport(AppKit)
import WebKit

struct WebView: NSViewRepresentable {
    let url: URL
    let cfg = WKWebViewConfiguration()

    init(url: URL, enableJavaScript: Bool = true) {
        self.url = url
        cfg.defaultWebpagePreferences.allowsContentJavaScript = enableJavaScript
    }

    func makeNSView(context: Context) -> WKWebView {
        WKWebView(frame: .zero, configuration: cfg)
    }

    func updateNSView(_ nsView: WKWebView, context: Context) {
        nsView.load(URLRequest(url: url))
    }
}
#elseif SKIP
@Composable func WebView(url: URL, enableJavaScript: Bool = true) {
    androidx.compose.ui.viewinterop.AndroidView(factory: { ctx in
        let webView = android.webkit.WebView(ctx)
        webView.webViewClient = android.webkit.WebViewClient()
        webView.settings.javaScriptEnabled = enableJavaScript
        return webView
    }, update: { webView in
        webView.loadUrl(url.absoluteString)
    })
}
#endif
