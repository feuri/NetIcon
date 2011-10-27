/**
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

// For the about dialog
const string program_name = "NetIcon";
const string version = "0.0.1";
const string comments = "A utility to display your current network status in the tray";
const string copyright = "Copyright (c) 2011 Jonas Jochmaring";
const string license_file = "/usr/share/licenses/neticon/LICENSE";

public static int main(string[] args)
{
    Gtk.init(ref args);
    
    var icon = new TrayIcon();
    icon.hide();

    var eth0_mon = new NetMonitor("eth0");
    eth0_mon.monitor_interface();
    eth0_mon.status_changed.connect(() => {icon.update_icon(eth0_mon);});

    Gtk.main();
    
    return 0;
}
