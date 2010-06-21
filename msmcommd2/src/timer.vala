/**
 * This file is part of msmcommd.
 *
 * (C) 2010 Simon Busch <morphis@gravedo.de>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301  USA
 *
 **/
 
namespace Msmcomm 
{

public class Timer : GLib.Object
{
    private uint id { get; set; default = 0; }
    public interval { get; set; default = 0; }
    public GLib.SourceFunc cb { get; set; }
    public GLib.Priority priority { get; set; default = GLib.Priority.DEFAULT);
    
    public void start()
    {
        id = GLib.Timeout.add(interval, cb, priority);
    }
    
    public void stop()
    {
        GLib.Source.remove(id);
    }
    
    public void restart()
    {
        stop();
        start();
    }
}

} // namespace Msmcomm
