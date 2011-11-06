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
    private string last_profile;

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
        var last_profile_file = File.new_for_path(state_dir+"last_profile");
        try
        {
            var dis = new DataInputStream (last_profile_file.read ());
            last_profile = dis.read_line(null);
        }
        catch(Error e)
        {
        }
        
        menuSystem = new Menu();
        var submenuConnect = new Menu();
        create_submenuConnect(submenuConnect);
        
        var menuConnect = new MenuItem.with_label("Connect");
        menuConnect.set_submenu(submenuConnect);
        menuSystem.append(menuConnect);
        var menuDisconnect = new MenuItem.with_label("Disconnect");
        menuDisconnect.activate.connect(() => {disconnect_clicked(last_profile);});
        menuSystem.append(menuDisconnect);
        var menuSeparator = new SeparatorMenuItem();
        menuSystem.append(menuSeparator);
        
        var menuAbout = new ImageMenuItem.from_stock(Stock.ABOUT, null);
        menuAbout.activate.connect(about_clicked);
        menuSystem.append(menuAbout);
        var menuQuit = new ImageMenuItem.from_stock(Stock.QUIT, null);
        menuQuit.activate.connect(Gtk.main_quit);
        menuSystem.append(menuQuit);
        menuSystem.show_all();
    }

    public void create_submenuConnect(Menu menu)
    {
        var menuLastProfile = new MenuItem.with_label(last_profile);
        menuLastProfile.activate.connect(() => {connect_clicked(last_profile);});
        menu.append(menuLastProfile);
        var menuSeparator = new SeparatorMenuItem();
        menu.append(menuSeparator);
        
        string raw_profiles;
        string[] profiles;
        try
        {
            Process.spawn_command_line_sync("netcfg list", out raw_profiles);
        }
        catch(Error e)
        {
        }
        profiles = raw_profiles.split("\n");
        for(int i = 0; i < profiles.length-1; i++)
        {
            var menuProfile = new MenuItem.with_label(profiles[i]);
            menuProfile.activate.connect(() => {connect_clicked(profiles[i]);});
            menu.append(menuProfile);
        }
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

    private void connect_clicked(string profile)
    {
        try
        {
            Process.spawn_command_line_sync("gksu netcfg up "+profile);
        }
        catch(Error e)
        {
        }
    }

    private void disconnect_clicked(string profile)
    {
        try
        {
            Process.spawn_command_line_sync("gksu netcfg down "+profile);
        }
        catch(Error e)
        {
        }
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
