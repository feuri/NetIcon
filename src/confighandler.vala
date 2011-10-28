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

class ConfigHandler : Object
{
    private string config_file;
    public string conf_iface;
    public InterfaceType iface_type;
    
    public ConfigHandler()
    {
        config_file = Environment.get_user_config_dir()+"/neticon.conf";
        var keyfile = new KeyFile();
        try
        {
            keyfile.load_from_file(config_file, KeyFileFlags.NONE);
        }
        catch(Error e)
        {
            stdout.printf("Could not load config file: %s\n", e.message);
        }
        try
        {
            conf_iface = keyfile.get_string("main", "interface");
        }
        catch(Error e)
        {
            stdout.printf("Could not load value: %s\n", e.message);
        }
    }

    public enum InterfaceType
    {
        WIRED,
        WIRELESS
    }
}
