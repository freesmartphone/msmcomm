/**
 * This file is part of libmsmcomm.
 *
 * (C) 2011 Simon Busch <morphis@gravedo.de>
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

namespace Msmcomm.LowLevel
{
    public abstract class UniformMessageGroup<T> : BaseMessageGroup
    {
        protected UniformMessageGroup(uint8 id)
        {
            base(id);
        }

        public override BaseMessage? unpack_message(uint16 id, uint8[] data)
        {
            BaseMessage? message = null;

            message = Object.new(typeof(T)) as BaseMessage;
            assert(message != null);

            message.unpack(data);

            set_message_type(id, message);

            return message;
        }

        protected abstract void set_message_type(uint16 id, BaseMessage messsage);
    }

    public abstract class BaseMessageGroup
    {
        public uint8 id { get; private set; }

        protected Gee.HashMap<uint16,GLib.Type> message_types;

        protected BaseMessageGroup(uint8 id)
        {
            message_types = new Gee.HashMap<uint16,GLib.Type>();
            this.id = id;
        }

        public virtual BaseMessage? unpack_message(uint16 id, uint8[] data)
        {
            BaseMessage? message = null;

            /* If message class exists create it and unpack it from supplied data */
            if (message_types.has_key(id))
            {
                var typ = message_types[id];

                if (typ == Type.INVALID)
                {
                    return null;
                }

                message = Object.new(typ) as BaseMessage;
                assert(message != null);

                message.unpack(data);
            }

            return message;
        }
    }
}
