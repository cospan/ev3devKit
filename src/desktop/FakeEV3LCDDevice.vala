/*
 * ev3devKit - ev3dev toolkit for LEGO MINDSTORMS EV3
 *
 * Copyright (C) 2014 David Lechner <david@lechnology.com>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

/*
 * FakeEV3LCDDevice.vala:
 *
 * U8g.Device that simulates the EV3 LCD.
 */

using Gee;
using Gtk;
using GRX;

namespace EV3devKit {
    public class FakeEV3LCDDevice : Gtk.EventBox {
        public struct Info {
            public int width;
            public int height;
            public bool use_custom_colors;
            public Color fg_color;
            public Color bg_color;
            public Color mid_color;
        }

        public enum DeviceType {
            STOCK,
            ADAFRUIT_18
        }

        const Info[] devices = {
            { 178, 128, true, 0, 0x78b5ad, 0 },
            { 160, 128, false }
        };

        Gdk.Pixbuf pixbuf;
        Gtk.Image image;
        internal char* pixbuf_data { get { return pixbuf.pixels; } }

        public Info info { get; private set; }

        public FakeEV3LCDDevice (DeviceType type = DeviceType.STOCK) {
            can_focus = true;
            button_press_event.connect ((event) => {
                grab_focus ();
                return true;
            });
            info = devices[(int)type];
            image = new Gtk.Image.from_pixbuf(new Gdk.Pixbuf (
                Gdk.Colorspace.RGB, false, 8, info.width * 2, info.height * 2));
            add (image);
            pixbuf = new Gdk.Pixbuf (Gdk.Colorspace.RGB, false, 8, info.width, info.height);
        }

        public void refresh () {
            image.set_from_pixbuf (pixbuf.scale_simple (info.width * 2,
                info.height * 2, Gdk.InterpType.TILES));
        }

        public void copy_to_clipboard () {
            var display = get_display ();
            var clipboard = Gtk.Clipboard.get_for_display (display, Gdk.SELECTION_CLIPBOARD);
            clipboard.set_image (pixbuf.scale_simple (info.width * 2,
                info.height * 2, Gdk.InterpType.TILES));
        }
    }
}
