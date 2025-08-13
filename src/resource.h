#ifndef RESOURCE_H
#define RESOURCE_H

#include <gio/gio.h>

/*
 * The resource.c file (where this function resides) is not included in my code,
 * it is compiled through:
 * ```sh
 * $ glib-compile-resources share/gresource.xml --target=src/resource.c
 * --generate-source;
 * ```
 * (Using make should be good enough)
 */

/*
 * @brief Get's the gresource for data files.
 *
 * @return The GResource
 */
GResource* gresource_get_resource(); // NOLINT
// I didn 't create this function, so I' ll have to follow their naming conventions

#endif
