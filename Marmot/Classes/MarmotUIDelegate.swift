//
//  MeteorUIDelegate.swift
//  AnyFormatProtocol
//
//  Created by linhey on 2018/1/30.
//

import WebKit

class MarmotUIDelegate: NSObject,WKUIDelegate {

  func webViewDidClose(_ webView: WKWebView) {

  }

  func webView(_ webView: WKWebView, commitPreviewingViewController previewingViewController: UIViewController) {

  }

  @available(iOS 10.0, *)
  func webView(_ webView: WKWebView, shouldPreviewElement elementInfo: WKPreviewElementInfo) -> Bool {
    return true
  }


  //  @available(iOS 10.0, *)
  //  func webView(_ webView: WKWebView, previewingViewControllerForElement elementInfo: WKPreviewElementInfo, defaultActions previewActions: [WKPreviewActionItem]) -> UIViewController? {
  //
  //  }
  //
  //  func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
  //
  //  }

}

// MARK: - Alert
extension MarmotUIDelegate {

  func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
    completionHandler()

  }

  func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
    completionHandler(true)

  }

  func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
    completionHandler(nil)
  }

}


