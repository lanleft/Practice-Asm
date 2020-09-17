#### SET UP SSH TUNNELING (PORT FORWARDING)

![](C:\Users\LanLeft\Pictures\Camera Roll\ssh-local.png)

SSH tunneling or SSH port forwarding is a method of creating an encrypted SSH connection between a client and a server machine throught which services ports can be replayed.

SSH forwarding is useful for transporting network data of servicees thath uses an unencrypted protocol, such as VNC or FTP, accessing georestricted content or bypassing intermediaet firewalls. Basically, you can forward any TCP port and tunnel the traffic over a secure SSH connection.

There are three types of SSH port forwarding:

+ Local Port Forwarding: forward a connection from the client host to the SSH server host and then to the destination host port.
+ Remote Port Forwarding: forwards a port from the server host to the client host and then to the destination host port.
+ Dynamic Port Forwarding: creates SOCKS proxy server which allows communication across a range of ports.

In this article, we will talk about how to set up local, remote, and dynamic encrypted SSH tunnels.

###### Local Port Forwarding

Local port forwarding allows you to forward a port on the local (ssh client) machine to a port on the remote (ssh server) machine, which is then forwarded to a port on the destination machine.

In this type of for warding the SSH client listens on a given port and tunnels any connection to that port to the specified port on the remote SSH server, which then connects to a port on the destination machine. The destination machine can be the remote SSH server or any other machine.

Local port forwarding is mostly used to connect to a remote service on an internal network such as a database or VNC server.

In linux, macOS and other Unix systems to create a local port forwarding pass the ```-L``` option to the ```ssh``` client:

```
$ ssh -L [LOCAL_IP:]LOCAL_PORT:DESTINATION:DESTINATION_PORT [USERS@]SSH_SERVER
```

The options used are as follows:

+ ```[LOCAL_IP:]LOCAL_PORT``` the local machine ip and port number. When ```LOCAL_IP``` is omitted the ssh client binds on localhost.
+ ```DESTINATION:DESTINATION_PORT``` the IP or hostname and the port of the destination machine.
+ ```[USER@]SERVER_IP``` the remote SSH user and server IP address.

You can use any port number greater than ```1024``` as a ```LOCAL_PORT``` . Ports numbers less than 1024 are privileged ports and can be used only by root. If your SSH server is listening on a port other than 22 use the ```-p [PORT_NUMBER]``` optin.

The destination hostname must be resolvable form SSH server.

Let's say you have a MySQL database server running on machine ```db001.host``` on an internal (private) network, on port 3306 which is accessible from the machine ```pub001.host``` and you want to connect using your local machine ```mysql``` client to the database server. To do so you can forward the connection like so:

```
$ ssh -L 3336:db001.host:3306 user@pub001.host
```

Once you run the command, you'll prompted to enter the remote SSH user password. After entering it, you will be logged in to the remote server and the SSH tunnel will be established. It is a good idea to set up an SSH key-based authentication and connect to the server without entering a password.

Now if you point your local machine database client to ```127.0.0.1:3336``` the connection will be forwarded to the ```db001.host.2206``` MySQL server throught the ```pub001.host``` machine which will act as an intermediate server.

You can forward multiple ports to multiple destinations in a single ssh command. For example, you hove another MySQL database server running on machine ```db002.host``` and you want to connect to both server from you local client you would run:

```
ssh -L 3336:db001.host:3306 3307:db002.host:3306 user@pub001.host
```

To connect to the second server you would use ```127.0.0.1:3337``` 

When the destination host is the same as the SSH server instead of specifying the destination host IP of hostname you can use ```localhost```.

Say you need to connect to a remote machine through VNC which runs on the same server and it is not accessible from the outside. The command you would use is:

```
ssh -L 5901:127.0.0.1:5901 -N -f user@remote.host
```

The `-f` option tells theh `ssh` command to run in the background and `-N` not to execute a remote command. We are using `localhost` because the VNC and the SSH server running on the same host.

If you are having trouble setting up tunneling check you remote SSH server configuration and make sure `AllowTcpForwarding` is not set to `no`. Bt default, forwarding is allowed. 

###### Remote Port Forwarding

Remote port forwarding is the opposite if local port forwarding. It allows you to forward a port on the remote (ssh server) machine to a port on the local (ssh client) machine, which is then forwarded to a port on the destination machine.

In this type of forwarding the SSH server listens on a given port and tunnels any connection to that port to the specified port on the local SSH client, which then connectes to a port on the destination machine. The destination machien can be the local or any other machine.

In Linux, macOS ang other Unix systems to create a remote port forwarding pass the `-R` option the `ssh` client:

```
ssh -R [remote:]remote_port:destination:Destionation_port [user@]ssh_server
```

The options used are as follows:

+ `[remote:]remote_port` the IP and the port number on the remote SSH server. An empty `remote` means that the remote SSH server will bind on all interfaces.
+ `destination:destination_port` the IP or hostname and the por tof the destination machien 
+ `[user@]server_ip` the remote ssh user and server ip address 

Local port forwarding is mostly used to give access

























