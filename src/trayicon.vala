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
 
using Gtk;

class TrayIcon : Window
{
    private StatusIcon trayicon;
    private Menu menuSystem;

    public TrayIcon()
    {
        // Create tray icon
        trayicon = new StatusIcon.from_icon_name("network-offline");
        trayicon.set_tooltip_text("starting");
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

    public void update_icon(ref NetMonitor status, ref ConfigHandler conf)
    {
        /*
         * Icons:
         *
         * CONNECT   /WIRED   : nm-device-wired
         * CONNECT   /WIRELESS: nm-signal-100
         * DISCONNECT/WIRED   : nm-no-connection
         * DISCONNECT/WIRELESS: nm-signal-00
         *
         * WLAN 
         * STRENGHT_100: nm-signal-100
         * STRENGHT_75 : nm-signal-75
         * STRENGHT_50 : nm-signal-50
         * STRENGHT_25 : nm-signal-25
         *
         * ERROR: network-error
         */
         
        switch(status.net_status)
        {
            case NetMonitor.Status.CONNECT:
                switch(conf.iface_type)
                {
                    case ConfigHandler.InterfaceType.WIRED:
                        trayicon.set_from_icon_name("nm-device-wired");
                        break;
                    case ConfigHandler.InterfaceType.WIRELESS:
                        trayicon.set_from_icon_name("nm-signal-100");
                        break;
                    default:
                        break;
                }
                trayicon.set_tooltip_text(conf.conf_iface+": connected");
                break;
            case NetMonitor.Status.DISCONNECT:
                switch(conf.iface_type)
                {
                    case ConfigHandler.InterfaceType.WIRED:
                        trayicon.set_from_icon_name("nm-no-connection");
                        break;
                    case ConfigHandler.InterfaceType.WIRELESS:
                        trayicon.set_from_icon_name("nm-signal-00");
                        break;
                    default:
                        break;
                }
                trayicon.set_tooltip_text(conf.conf_iface+": disconnected");
                break;
            default:
                break;
        }
    }
  }
