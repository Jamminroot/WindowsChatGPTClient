//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <bitsdojo_window_windows/bitsdojo_window_plugin.h>
#include <system_tray/system_tray_plugin.h>
#include <webview_windows/webview_windows_plugin.h>

void RegisterPlugins(flutter::PluginRegistry* registry) {
  BitsdojoWindowPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("BitsdojoWindowPlugin"));
  SystemTrayPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("SystemTrayPlugin"));
  WebviewWindowsPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("WebviewWindowsPlugin"));
}
