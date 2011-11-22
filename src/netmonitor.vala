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

class NetMonitor : Object
{
//~     private string state_dir = "/run/network/";
//~     private string profile_dir = "/etc/network.d/";
    private FileMonitor iface_mon;
    private File iface;
    public int net_status;
    
    public NetMonitor(ref string iface_name)
    {
        iface = File.new_for_path(STATE_DIR+"interfaces/"+iface_name);
        if(iface.query_exists())
        {
            net_status = Status.CONNECT;
        }
        else if(!iface.query_exists())
        {
            net_status = Status.DISCONNECT;
        }
    }

    public signal void status_changed();
    
    enum Status
    {
        CONNECT,
        DISCONNECT,

        STRENGHT_100,
        STRENGHT_75, //
        STRENGHT_50, // Wireless strenght currently unsused, just for later
        STRENGHT_25, //

        ERROR
    }

    public void monitor_interface()
    {
        try
        {
            iface_mon = iface.monitor_file(FileMonitorFlags.NONE);
            iface_mon.changed.connect(on_change);
        }
        catch(Error e)
        {
            stdout.printf("Error: %s\n", e.message);
        }
    }

    public void on_change(File file, File? other_file, FileMonitorEvent event)
    {
        if(event == FileMonitorEvent.CREATED)
        {
            net_status = Status.CONNECT;
        }
        else if(event == FileMonitorEvent.DELETED)
        {
            net_status = Status.DISCONNECT;
        }
        else
        {
            //stdout.printf("Error: unused event\n");
        }
        status_changed();
    }
}
