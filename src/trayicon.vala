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

/*
 * Icons:
 *
 * LAN
 * up   : network-transmit-receive
 * down : network-offline
 *
 * WLAN 
 *   0% : nm-signal-00
 *  25% : nm-signal-25
 *  50% : nm-signal-50
 *  75% : nm-signal-75
 * 100% : nm-signal-100
 *
 * error: network-error
 */
 
using Gtk;

class TrayIcon : Window
{
    private StatusIcon trayicon;
    private Menu menuSystem;

    public TrayIcon()
    {
        // Create tray icon
        trayicon = new StatusIcon.from_icon_name("network-transmit-receive");
        trayicon.set_tooltip_text("Tray");
        trayicon.set_visible(true);
        
        trayicon.activate.connect(about_clicked);
        
        create_menuSystem();
        trayicon.popup_menu.connect(menuSystem_popup);
    }

    // Create menu for right button
    public void create_menuSystem()
    {
        menuSystem = new Menu();
        var menuAbout = new ImageMenuItem.from_stock(Stock.ABOUT, null);
        menuAbout.activate.connect(about_clicked);
        menuSystem.append(menuAbout);
        var menuQuit = new ImageMenuItem.from_stock(Stock.QUIT, null);
        menuQuit.activate.connect(Gtk.main_quit);
        menuSystem.append(menuQuit);
        menuSystem.show_all();
    }

    // Show popup menu on right button
    private void menuSystem_popup(uint button, uint time)
    {
        menuSystem.popup(null, null, null, button, time);
    }

    private void about_clicked()
    {
        var about = new AboutDialog();
        about.set_program_name(program_name);
        about.set_version(version);
        about.set_comments(comments);
        about.set_copyright(copyright);
        string license;
        try
        {
            FileUtils.get_contents(license_file, out license);
        }
        catch(Error e)
        {
            license = "Error opening the license file: "+e.message;
        }
        about.set_license(license);
        about.run();
        about.hide();
    }

    public void update_icon(NetMonitor status)
    {
        switch(status.net_status)
        {
            case NetMonitor.Status.WIRED_CONNECT:
                trayicon.set_from_icon_name("network-transmit-receive");
                break;
            case NetMonitor.Status.WIRED_DISCONNECT:
                trayicon.set_from_icon_name("network-offline");
                break;
            default:
                break;
        }
    }
  }
