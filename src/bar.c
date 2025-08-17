#include <gtk-4.0/gtk/gtk.h>
#include <gtk4-layer-shell/gtk4-layer-shell.h>
#include "bar.h"

static bool getTime(GObject* timeLabel) {
	const time_t now = time(0);
	const struct tm* timeInfo = localtime(&now);
	const int hour = timeInfo->tm_hour;
	const int minutes = timeInfo->tm_min;
	char timeString[8];
	sprintf(timeString, "%d:%d", hour, minutes);
	gtk_label_set_label(GTK_LABEL(timeLabel), timeString);

	return true;
}

static bool getDate(GObject* dateLabel) {
	const time_t now = time(0);
	const struct tm* timeInfo = localtime(&now);
	const int day = timeInfo->tm_mday;
	const int month = timeInfo->tm_mon;
	char dateString[8];
	sprintf(dateString, "%d/%d", day, month);
	gtk_label_set_label(GTK_LABEL(dateLabel), dateString);

	return true;
}

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

	GObject* timeLabel = gtk_builder_get_object(ui, "time");
	GObject* dateLabel = gtk_builder_get_object(ui, "date");
	// Get time first, then start loop
	getTime(timeLabel);
	getDate(dateLabel);
	g_timeout_add_seconds(1, G_SOURCE_FUNC(getTime), timeLabel);
	g_timeout_add_seconds(1, G_SOURCE_FUNC(getDate), dateLabel);

	gtk_widget_set_visible(GTK_WIDGET(window), TRUE);
	g_object_unref(ui);
}
