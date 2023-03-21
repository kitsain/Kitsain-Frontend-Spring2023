//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"
#include <webview_windows/webview_windows_plugin.h>
#include <realm/realm_plugin.h>

void RegisterPlugins(flutter::PluginRegistry* registry) {
  RealmPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("RealmPlugin"));
      registry->GetRegistrarForPlugin("WebviewWindowsPlugin");  
}
