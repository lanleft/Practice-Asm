#!/usr/bin/env python3
import socket 
import select 
import sys
import _thread

server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
server.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)

if len(sys.argv) != 3:
	print("Usage: python3 [filename server] [ip address] [port]")
	exit()

IP_address = str(sys.argv[1])
PORT = int(sys.argv[2])
server.bind((IP_address, PORT))
server.listen(100) # listens for 100 active connections

list_of_clients = []

def clientthread(conn, addr):
	conn.sendall(b'Welcom to socket practice')
	while True:
		try:
			message = conn.recv(2048)
			tranmess = message.decode('utf-8')
			if message:
				print("<" + addr[0] + ">" + tranmess)
				message_to_send = "<" + addr[0] + ">" + tranmess
				messageSend = message_to_send.encode('utf-8')
				broadcast(messageSend, conn)
			else:
				remove(conn)
		except:
			continue
def broadcast(message, connection):
	for clients in list_of_clients:
		if clients != connection:
			try:
				clients.sendall(message)
			except:
				clients.close()
				remove(clients)
def remove(connection):
	if connection in list_of_clients:
		list_of_clients.remove(connection)
while True:
	conn, addr = server.accept()
	list_of_clients.append(conn)
	print(addr[0] + " connected")
	_thread.start_new_thread(clientthread, (conn, addr))
conn.close()
server.close()
