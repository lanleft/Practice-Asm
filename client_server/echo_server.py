#!/usr/bin/env python3

import socket

HORT = '192.168.1.108' 
PORT = 54321

with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as echoSv:
	echoSv.bind((HORT, PORT))
	echoSv.listen()
	connect, address = echoSv.accept()
	with connect:
		print('Connect by', address)
		# while True:
		# 	data = connect.recv(1024)
		# 	# if not data:
		# 	# 	break
		# 	connect.sendall(data)
		# 	print(data)
		data = connect.recv(1024)
		
