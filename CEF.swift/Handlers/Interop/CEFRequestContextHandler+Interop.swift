//
//  CEFRequestContextHandler.g.swift
//  CEF.swift
//
//  Created by Tamas Lustyik on 2015. 08. 02..
//  Copyright © 2015. Tamas Lustyik. All rights reserved.
//

import Foundation

func CEFRequestContextHandler_on_request_context_initialized(ptr: UnsafeMutablePointer<cef_request_context_handler_t>?,
                                                             context: UnsafeMutablePointer<cef_request_context_t>?) {
    guard let obj = CEFRequestContextHandlerMarshaller.get(ptr) else {
        return
    }

    obj.onRequestContextInitialized(context: CEFRequestContext.fromCEF(context)!)
}

func CEFRequestContextHandler_on_before_plugin_load(ptr: UnsafeMutablePointer<cef_request_context_handler_t>?,
                                                    mimeType: UnsafePointer<cef_string_t>?,
                                                    pluginURL: UnsafePointer<cef_string_t>?,
                                                    isMainFrame: Int32,
                                                    topOriginURL: UnsafePointer<cef_string_t>?,
                                                    pluginInfo: UnsafeMutablePointer<cef_web_plugin_info_t>?,
                                                    pluginPolicy: UnsafeMutablePointer<cef_plugin_policy_t>?) -> Int32 {
    guard let obj = CEFRequestContextHandlerMarshaller.get(ptr) else {
        return 0
    }

    let action = obj.onBeforePluginLoad(mimeType: CEFStringToSwiftString(mimeType!.pointee),
                                        pluginURL: pluginURL != nil ? URL(string: CEFStringToSwiftString(pluginURL!.pointee)) : nil,
                                        isMainFrame: isMainFrame != 0,
                                        topOriginURL: topOriginURL != nil ? URL(string: CEFStringToSwiftString(topOriginURL!.pointee)) : nil,
                                        pluginInfo: CEFWebPluginInfo.fromCEF(pluginInfo)!,
                                        defaultPolicy: CEFPluginPolicy.fromCEF(pluginPolicy!.pointee))
    
    if case .overridePolicy(let policy) = action {
        pluginPolicy!.pointee = policy.toCEF()
        return 1
    }
    
    return 0
}

func CEFRequestContextHandler_get_resource_request_handler(ptr: UnsafeMutablePointer<cef_request_context_handler_t>?,
                                                           browser: UnsafeMutablePointer<cef_browser_t>?,
                                                           frame: UnsafeMutablePointer<cef_frame_t>?,
                                                           request: UnsafeMutablePointer<cef_request_t>?,
                                                           isNavigation: Int32,
                                                           isDownload: Int32,
                                                           initiator: UnsafePointer<cef_string_t>?,
                                                           disableDefault: UnsafeMutablePointer<Int32>?) -> UnsafeMutablePointer<cef_resource_request_handler_t>? {
    guard let obj = CEFRequestContextHandlerMarshaller.get(ptr) else {
        return nil
    }

    var disableFlag = false
    
    let handler = obj.onResourceRequest(browser: CEFBrowser.fromCEF(browser),
                                        frame: CEFFrame.fromCEF(frame),
                                        request: CEFRequest.fromCEF(request)!,
                                        isNavigation: isNavigation != 0,
                                        isDownload: isDownload != 0,
                                        initiator: initiator != nil ? CEFStringToSwiftString(initiator!.pointee) : nil,
                                        disableDefault: &disableFlag)
    
    disableDefault?.pointee = disableFlag ? 1 : 0
    return handler?.toCEF()
}
