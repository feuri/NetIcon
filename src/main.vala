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

const string state_dir = "/run/network/";
const string profile_dir = "/etc/network.d/";

public static int main(string[] args)
{
    Gtk.init(ref args);
    
    var icon = new TrayIcon();
    icon.hide();

    var config = new ConfigHandler();
    
    var monitor = new NetMonitor(ref config.conf_iface);
    monitor.monitor_interface();
    monitor.status_changed.connect(() => {icon.update_icon(ref monitor, ref config);});
    icon.update_icon(ref monitor, ref config);
    
    Gtk.main();
    
    return 0;
}
