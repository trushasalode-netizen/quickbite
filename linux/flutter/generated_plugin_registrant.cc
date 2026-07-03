//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <gtk/gtk_plugin.h>
<<<<<<< HEAD
#include <url_launcher_linux/url_launcher_plugin.h>
=======
>>>>>>> 0144f9cd9dd5d40fb5e548811681048cff3f63f1

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) gtk_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "GtkPlugin");
  gtk_plugin_register_with_registrar(gtk_registrar);
<<<<<<< HEAD
  g_autoptr(FlPluginRegistrar) url_launcher_linux_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "UrlLauncherPlugin");
  url_launcher_plugin_register_with_registrar(url_launcher_linux_registrar);
=======
>>>>>>> 0144f9cd9dd5d40fb5e548811681048cff3f63f1
}
