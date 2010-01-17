/*
 * (c) 2009 by Simon Busch <morphis@gravedo.de>
 * All Rights Reserved
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
 * You should have received a copy of the GNU General Public License along
 * with this program; if not, write to the Free Software Foundation, Inc.,
 * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
 *
 */

#include <msmcomm/internal.h>

static void forward_data(int source_fd, int dest_fd)
{
    fd_set rfds;
    int retval;

    unsigned char buf[4096];

    int max_fd = source_fd > dest_fd ? source_fd + 1 : dest_fd + 1;

    for (;;) {
        FD_ZERO(&rfds);
        FD_SET(source_fd, &rfds);
        FD_SET(dest_fd, &rfds);

        retval = select(max_fd, &rfds, NULL, NULL, NULL);
        if (retval == -1) {
            perror("select()");
            break;
        } else if (retval){
            if (FD_ISSET(source_fd, &rfds)) {
                ssize_t size = read(source_fd, &buf, sizeof(buf));
                if (size <= 0)
                    break;

                printf("Sending from source %d\n", size);
                write(dest_fd, &buf, size);
            } else if (FD_ISSET(dest_fd, &rfds)) {
                ssize_t size = read(dest_fd, &buf, sizeof(buf));
                if (size <= 0)
                    break;

                printf("Sending from destination %d\n", size);
                write(source_fd, &buf, size);
            }
        }
    }
}

int main(int argc, char *argv[])
{
	int flush;
	struct hsuart_mode mode;

	if (argc < 3) {
		printf("Usage: %s <devicenode> <port>\n", argv[0]);
		return EXIT_FAILURE;
	}
	
	int modem_fd = open(argv[1], O_RDWR | O_NOCTTY);
	if (modem_fd < 0) {
		perror("Failed to open device");
		return EXIT_FAILURE;
	}

	/* configure the hsuart like TelephonyInterfaceLayerGsm does */

	/* flush everything */
	flush = HSUART_RX_QUEUE | HSUART_TX_QUEUE | HSUART_RX_FIFO | HSUART_TX_FIFO;
	ioctl(modem_fd, HSUART_IOCTL_FLUSH, flush);

	/* get current mode */
	ioctl(modem_fd, HSUART_IOCTL_GET_UARTMODE, &mode);

	/* speed and flow control */
	mode.speed = HSUART_SPEED_115K;
	mode.flags |= HSUART_MODE_PARITY_NONE;
	mode.flags |= HSUART_MODE_FLOW_CTRL_HW;

	ioctl(modem_fd, HSUART_IOCTL_SET_UARTMODE, &mode);

	/* we want flow control for the rx line */
	ioctl(modem_fd, HSUART_IOCTL_RX_FLOW, HSUART_RX_FLOW_ON);

	int socket_fd = socket(PF_INET, SOCK_STREAM, 0);
	if (socket_fd < 0) {
		perror("Failed to create network socket");
		return EXIT_FAILURE;
	}


	struct sockaddr_in addr = { 0, };
	addr.sin_family = PF_INET;
	addr.sin_port = htons( atoi(argv[2]) );
	addr.sin_addr.s_addr = htonl(INADDR_ANY);

	if (bind(socket_fd, (struct sockaddr*)&addr, sizeof(addr)) == -1) {
		perror("Error binding");
		return EXIT_FAILURE;
	}

	if (listen(socket_fd, 1) == -1) {
		perror("Error listening");
		return EXIT_FAILURE;
	}

	int connection_fd = -1;
	socklen_t length = sizeof(addr);
	while ((connection_fd = accept(socket_fd, (struct sockaddr*)&addr, &length)) >= 0) {
		printf("New connection from: '%s'\n", inet_ntoa(addr.sin_addr));
		forward_data(modem_fd, connection_fd);
		close(connection_fd);
	}

	return 0;
}

