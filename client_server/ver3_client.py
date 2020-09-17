#!/usr/bin/env python3
import socket
import select 
import sys 

client = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
if len(sys.argv) != 3:
	print("Usage: python3 [filename_client] [ip_address] [port]")
	exit()
IP_address = str(sys.argv[1])
PORT = int(sys.argv[2])
client.connect((IP_address, PORT))

while True:
	sockets_list = [sys.stdin, client]
	read_socket, write_socket, error_socket = select.select(sockets_list, [], [])
	for socks in read_socket:
		if socks == client:
			message = socks.recv(2048)
			tranmess = message.decode('utf-8')
			print(tranmess)
		else:
			message = sys.stdin.readline()
			data = message.encode('utf-8')
			client.sendall(data)
			sys.stdout.write("<You>")
			sys.stdout.write(message)
			sys.stdout.flush()
client.close()
