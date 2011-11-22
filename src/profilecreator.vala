/* -*- Mode: C; indent-tabs-mode: t; c-basic-offset: 4; tab-width: 4 -*- */
/*
 * (C) Copyright 2011 Jonas Jochmaring
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as
 * published by the Free Software Foundation; either version 3 of the
 * License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public
 * License along with this program. If not, see
 * <http://www.gnu.org/licenses/>.
 */

using Gtk;

class ProfileCreator : Window
{
    private Window window;
    
    public ProfileCreator()
    {
        window = new Window();
        window.title = "ProfileCreator";
        window.border_width = 10;
        window.window_position = WindowPosition.CENTER;
        window.set_default_size(350, 70);
        window.destroy.connect(Gtk.main_quit);

        var button = new Button.with_label("OK");
        button.clicked.connect(Gtk.main_quit);

        window.add(button);
        window.show_all();

		Gtk.main();
    }
}
