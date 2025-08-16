#include <gtk-4.0/gtk/gtk.h>
#include "resource.h"
#include "bar.h"

static void activate(GtkApplication* app) {
	bar(app);
}

int main(int argc, char** argv) {
	const char* env = getenv("XDG_SESSION_TYPE");
	if (!env || !strcmp("wayland", env)) {
		fprintf(stderr, "OTTW only supports Wayland.\n");
		exit(1);
	}

	GtkApplication* app =
	gtk_application_new("com.github.tomm.ottw", G_APPLICATION_DEFAULT_FLAGS);
	g_resources_register(gresource_get_resource());

	g_signal_connect(app, "activate", G_CALLBACK(activate), NULL);
	const int status = g_application_run(G_APPLICATION(app), argc, argv);

	g_object_unref(app);
	return status;
}
