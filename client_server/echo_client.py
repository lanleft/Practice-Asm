#!/usr/bin/env python3

import socket
# from pyCrypto.Util.number import bytes_to_long , long_to_bytes

# def long_to_bytes(n):
# 	l = []
# 	x = 0
# 	off = 0
# 	while x != n:
# 		b = (n >> off) & 0xff
# 		l.append(b)
# 		x = x | (b << off)
# 		off += 8
# 	l.reverse()
# 	return bytes(l)
# def bytes_to_long(s):
# 	n = s[0]
# 	for b in (x for x in s[1:]):
# 		n = (n << 8) | b 
# 	return n

HOST = '192.168.1.108'
PORT = 54321
# s = 1234567890
# t = long_to_bytes(s)
# print(t)
# print(bytes_to_long(t))
# b = mystring.encode('utf-8')

with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as client:
	client.connect((HOST, PORT))
	client.sendall(b'hay thu nhap cai gi do')
	# data = client.recv(1024)
	# print(repr(data))
	# client.sendall(input())
	# data = client.recv()
	# print(repr(data))
	# name = raw_input("Enter your name:")
	# client.send(strIp)
	# data = client.recv(1024)
	# print(repr(data))
	# client.sendall()