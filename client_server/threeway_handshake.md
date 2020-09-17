### THREEWAY HANDSHAKE

###### TCP/IP Open Connection Primer

1. The client initiates the TCP connection by sending a synchoronization packet with a sequence number, or SYN(1), to the server and port the server is listening on.
2. The server reads the packet from the rx ring on the NIC and puts it in the receive backlog queue. When ready, the server reads the packet from the receive queue, determines it's a SYN packet, create a new connection in the "SYN+RECV" state, and puts this connection in the SYN backlog queue. The server then sends a synchronization + acknowledgement packet with its own sequence number, or SYN+ACK(2), back to the client.
3. The client completes the connection by confirming receipt of the SYN+ACK packet by sending an acknowledgement, or ACK(3), back to the server. Upon receipt of the ACK packet, the server creates a connection socket, the connection is removed from SYN backlog queue and moved to the accept queue, and the state is changed from "SYN_RECV" to "ESTABLISHED".

###### TCP/IP Close Connection Primer

When the client and server are done sending and receiving data, the connection needs to be closed in a similar manner to how it was opened. The client usually controls when the close connection is triggered. However, the protocol gives the server application time to do some cleanup before closig the connection, which adds an additional state on both client and server.

1. The client application initiates closing the TCP connection by sending a finalization packet, or FIN(1), to the server socket and puts the client connection in the "FIN_WAIT1" state.
2. The server receives the FIN packet, moves the connection to the "CLOSE_WAIT" state, and sends an ACK(2) packet back to the client. The server waits for the server application to call `close()`. The client receives the ACK packet and moves the conneciton to the "FIN_WAIT2" state and waits fo rthe application on the server to finish and the server to sen a FIN packet indicating everything is complete.
3. The server application calls `close()` and the server senda a FIN(3) packet and moves the connection to the "LAST_ACK" sate.
4. The client receives the FIN packet, sends a final ACK(4) packet to the server, and moves the connection to the "TIME_WAIT"state. The client connection closes after double the Maximum Segment Lifetime (MSL).

















