#include <gtk-4.0/gtk/gtk.h>
#include <gtk4-layer-shell/gtk4-layer-shell.h>
#include "bar.h"

static void realize(GtkWindow* window, GdkMonitor* monitor) {
	const gboolean anchors[] = { FALSE, TRUE, TRUE, TRUE };
	gtk_layer_init_for_window(window);
	gtk_layer_set_namespace(window, "bar");
	gtk_layer_set_layer(window, GTK_LAYER_SHELL_LAYER_TOP);
	gtk_layer_set_monitor(window, monitor);
	for (size_t i = 0; i < GTK_LAYER_SHELL_EDGE_ENTRY_NUMBER; i++) {
		gtk_layer_set_anchor(window, i, anchors[i]);
	}
	gtk_layer_auto_exclusive_zone_enable(window);
}

void bar(GtkApplication* app, GdkMonitor* monitor) {
	GtkBuilder* ui =
	gtk_builder_new_from_resource("/com/github/tomm/ottw/share/xml/bar.ui");

	GObject* window = gtk_builder_get_object(ui, "window");
	g_signal_connect(window, "realize", G_CALLBACK(realize), monitor);
	gtk_window_set_application(GTK_WINDOW(window), app);
	GtkCssProvider* cssProvider = gtk_css_provider_new();
	gtk_css_provider_load_from_resource(cssProvider, "/com/github/tomm/ottw/"
													 "share/css/bar.css");
	gtk_style_context_add_provider_for_display(gtk_widget_get_display(GTK_WIDGET(window)),
											   GTK_STYLE_PROVIDER(cssProvider),
											   GTK_STYLE_PROVIDER_PRIORITY_APPLICATION);

	gtk_widget_set_visible(GTK_WIDGET(window), TRUE);
	g_object_unref(ui);
}
