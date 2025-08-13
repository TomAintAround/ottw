#include <gtk-4.0/gtk/gtk.h>
#include "bar.h"

void bar(GtkApplication* app) {
	GtkBuilder* ui =
	gtk_builder_new_from_resource("/com/github/tomm/ottw/share/xml/bar.ui");

	GObject* window = gtk_builder_get_object(ui, "window");
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
