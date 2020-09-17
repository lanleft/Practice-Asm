### **CREATE SERVER AND CLIENT FOR CHATROOM BY PYTHON**

**Introduce**

Đầu tiên ta phải hiểu Network Socket là gì? Theo Wikipedia “A Network Socket is an internal endpoint for sending or receiving data within a node in computer network”. Nghĩa là Network Socket là điểm cuối của vòng lặp khi gửi hay nhận dữ liệu như một nút trong một mạng máy tính.

Theo như một trang này [link](https://blog.tinohost.com/socket-la-gi/) “Socket là một điểm cuối của liên kết truyền thông hai chiều (two-way communication) giữa hai chương trình chạy trên mạng.” Các lớp socket được sử dụng để biểu diễn kết nốt giữa client và server, được rằng buộc với một cổng (port) để các tầng TCP có thể định danh địa chỉ dữ liệu gửi tới. 

Thường thì người ta sẽ chia socket ra làm hai loại chính là:

+ Stream Socket: dựa trên giao thức TCP việc truyền dữ liệu chỉ thực hiện giữa 2 quá trình đã thiết lập kết nối. Giao thức này đảm bảo dữ liệu được truyền đến nơi nhận một cách đáng tin cậy, đúng thứ tự nhờ vào cơ chế quản lý luồng lưu thông trên mạnh và cơ chế chống tắc nghẽn
+ Datagram Socket: dựa trên giao thức UDP việc truyền dữ liệu không yêu cầu có sự thiết lập kết nối giữa 2 quá trình. Ngược lại với giao thức TCP thì dữ liệu được truyền theo giao thức UDP không được tin cậy, có thể không đúng trình tự và lặp lại. Tuy nhiên vì nó không yêu cầu thiết lập kết nối và không có những cơ chế phức tạp nên tốc độ nhanh, ứng dụng cho các ứng dụng truyền dữ liệu nhanh như các ứng dụng chat, game,...

Như định nghĩa trên, socket rất có ích trong việc truyền dữ liệu nên được ứng dụng vô cùng rộng trong các hệ điều hành và các ứng dụng trên nền tảng cloud.

Cách tạo một server lắng nghe các kết nối từ các client đến và để cho các client giao tiếp với nhau như một hình thức chatroom là một trong các ứng dụng của socket. 

##### **LOGIC**

![A close up of a sign  Description automatically generated](file:///C:/Users/LanLeft/AppData/Local/Temp/msohtmlclip1/01/clip_image001.jpg)

Sơ đồ minh họa quá trình khởi tạo và chuyền dữ liệu giữ server-client qua giao thức TCP/IP 

Một số phương thức gắn với sơ đồ trên dùng trong thư viện socket.

Socket: khai báo mở socket 

Setsockopt: gán giá trị ip và port cho socket vừa khởi tạo 

```bind()```: phương thức này được dùng để lắng nghe đến địa chỉ address và port

```listen()```: phương thưc snayf thiết lập mở kết nối trên server, với tham số truyền vào là số kết nối được phép (nhỏ nhất là 0 và lớn nhất là do cấu hình của server)

```connect(address)```: phương thức này dùng để thiết lập một kết nối từ client đến server.

```accept()```: phương thức này thiết lập chấp nhận một kết nối, và nó sẽ trả về một tuple gồm 2 thông số (conn, address) để chúng ta có thể gửi ngược về client

```send(byte, flag)```, ```recv(bufsize, flag)```: gửi và nhận dữ liệu (giữa client và server)

```close()``` phương thức này dùng để đóng một kết nối

Logic của chatroom sẽ là: tạo một server lắng nghe tại địa chỉ ip của máy và với một port xác định; các client kết nốt đến, gửi dữ liệu lên server, server gửi lại dữ liệu đó cho tất cả các client đang kết nối đến server đó và gắn thêm địa chỉ ip với message vừa gửi (ip sẽ định danh cho các client, giống như tên hay nickname trên facebook, Instagram,…)

##### SERVER

Ví dụ về server chatroom như sau:

```python
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
			if tranmess:
				messageSend = "<" + addr[0] + ">" + tranmess
				print(messageSend)
				message_to_send = messageSend.encode('utf-8')
				broadcast(message_to_send, conn)
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

```



Đầu tiên, sẽ tạo import các thư viện cần thiết. 

```python
import socket
import select
import sys
import _thread 
```

Tiếp theo chúng ta sẽ khởi tạo đối tượng:

```python
socket.socket(AddressFamily, socketType, Protocol)
```

Trong đó:

+ AddressFamily là cách chúng ta thiết lập địa chỉ kết nối. Trong python thì hỗ trợ chúng ta 3 kiểu: AF_INET kiểu này là thiết lập dưới dạng IPv4, AF_INET6 kiểu này là thiết lập dưới dạng IPv6, AF_UNIX.

+ SocketType là cách thiết lập giao thức cho socket. Thông thường thì sẽ là ```SOCK_STREAM``` (TCP) hoặc ```SOCK_DGRAM``` (UDP).

+ Protocol tham số thiết lập loại giao thức. Tham số này có thể không cần thiết lập. Mặc định là 0.

  

```python
server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
```

Tham số được truyền vào gồm 2 argument. Argument đầu tiền là AF_INET là địa chỉ IPv4 của socket server. Nó được sử dụng khi chúng ta có tên miền Internet với host xác định. Argument thứ 2  là giao thức truyền file TCP. Vậy là đối tượng server được đã được gán giá trị.

```python
server.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
```

'Set the value of the given socket option. The needed symbolic constants are defined in the socket module (SO_* etc.). The value can be an interge or a string representing a buffer. In the latter case it is up to the caller to ensure that the string contains the proper bits.' - theo kite.com

+ tham số đầu tiên là  biểu tượng trong module Socket 
+ tham số thứ hai là sử dụng địa chỉ client
+ và một hàm trả về mặc định là true = 1

```python
if len(sys.argv) != 3:
    print ("Usage: python3 [file_name] [address] [port]")
    exit()
```

Điều kiện này kiểm tra xem đầu vào khi chạy file đã đúng hay chưa, lưu ý cho một hàm là ```sys.argv``` đây là hàm trong module ```import sys``` dùng để nhận giá trị đầu vào, chính là các tham số truyền vào khi bắt đầu khởi chạy hàm. Và hàm ```exit()``` là để thoát ra an toàn. 

```python
IP_address = str(sys.argv[1])
PORT = int(sys.argv[2])
```

Hai câu lệnh trên để ép giá trị cho địa chỉ và cổng, ở đây bắt bộc địa chỉ IP là một string và địa chỉ port phải là một số. Còn argv là các tham số, được coi như một mảng và bắt đầu đếm từ file_name.

```python
server.bind((IP_address, PORT))
server.listen(100)
list_of_clients = []
```

Gắn server vào địa chỉ ip và port vừa được nhập vào, và bắt đầu lắng nghe. Gía trị 100 là số lượng clients tối đa có thể truy cập vào server. Tất cả các clients sẽ được đưa vào danh sách đã khởi tạo ở trên.

Vì có rất nhiều các client kết nối đến server nên chúng ta cần có 1 hàm điều khiển luồng truy xuất dữ liệu từ mỗi client đến server. Đó là hàm clientthread.

```python
def clientthread(conn, adddr):
    conn.sendall(b'Wellcom to socket practice')
    while True:
        try:
            message = conn.recv(2048)
            tranmess = message.decode('utf-8')
            if tranmess:
                messageSend = "<" + add[0] + ">" + tranmess
                print(messageSend)
                message_to_send = messageSend.encode('utf-8')
             else:
                remove(conn)
         except:
            continue
```

Hàm ```clientthread(conn, addr)``` nhận đầu vào là kết nối và địa mảng địa chỉ (nói là mảng nhưng chúng ta chỉ dùng phần tử đầu tiên của mảng cũng chính là ```addr[0]```).  Tiếp theo chúng ta sẽ gửi một thông điệp đến client đã cho client biết rằng đã kết nối đến server thành công. Và hàm gửi dữ liệu ```sendall(data)``` chỉ gửi dữ liệu dưới dạng bytes vậy nên chúng ta phải viết chữ ```b''``` như vậy. 

Cũng chính vì thế mà tất cả các message trước khi gửi đi sẽ được chuyển thành bytes qua câu lệnh ```message.encode('utf-8')``` và khi nhận xong chúng ta sẽ phải chuyển về dạng string trước khi hiện viết hiện lên màn hình qua hàm ```message.decode('utf-8')```.

 Câu lệnh ```while True:``` là để bắt đầu những vòng lặp với điều kiện luôn đúng, nghĩa là client sẽ có thể nhắn được nhiều message.

 Hàm ```broadcast(message, connection)``` có chức năng để gửi mesage đến tất các client trong list đã khai báo trước.

```python
def broadcast(message, connection):
    for clients in list_of_clients:
        if clients != connection:
            try:
                clients.sendall(message)
            except:
                clients.close()
                remove(clients)
```

Dùng một vòng for duyệt tất cả các client có trong list, với kết nối (bao gồm địa chỉ ip) đã biết. Nếu client có kết nối thì gửi message còn không thì sẽ đóng kết nối với client đó.

 Hàm ```remove(connection)``` để xóa các kết nối đó ra khỏi list các client.

```python
def remove(connection):
    if connection in list_of_clients:
        list_of_clients.remove(connection)
```

Sau khi tất cả các hàm được định nghĩa thì chúng ta sẽ bắt đầu vào main.

```python
while True:
    conn, addr = server.accept()
    list_of_clients.append(conn)
    print(addr[0] + " connected")
    _thread.start_new_thread(clientthread, (conn, addr))
conn.close()
server.close()
```

Gía trị trả về của hàm ```accept()``` là một định danh kết nối và địa chỉ ip của client. Chúng ta sẽ thêm client đó vào list client đã khởi tạo trước đó. Hiện lên màn hình thông báo kết nối đến server. Điều quan trọng trong đoạn code này là đối tượng ```_thread.start_new_thread(function, args[])``` với hàm được dùng. Hàm này sẽ khởi tạo một thread và trả về cho nó một giá trị định danh. Thread sẽ được chạy với tên hàm với giá trị truyền vào là args ngay say nó. Khi hàm được thực hiện xong và trả về giá trị thì luồng âm thầm được thoát ra.

Sau đó là đóng các kết nối và server nếu như có các tìn hiệu tắt kết nối từ bên ngoài.

###### Client

Và đây là client:

```python
#!/usr/bin/env python3
import socket
import select 
import sys 

server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
if len(sys.argv) != 3:
	print("Usage: python3 [filename_client] [ip_address] [port]")
	exit()
IP_address = str(sys.argv[1])
PORT = int(sys.argv[2])
server.connect((IP_address, PORT))

while True:
	sockets_list = [sys.stdin, server]
	read_socket, write_socket, error_socket = select.select(sockets_list, [], [])
	for socks in read_socket:
		if socks == server:
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
server.close()

```

Giống như server ở trên về đoạn đầu, mình chỉ nói về những điểm khác biệt của client.Đầu tiên là:

```python
server.connect((IP_address, PORT))
```

Client kết nối đến server với địa chỉ là giá trị được truyền vào.

```python
sockets_list = [sys.stdin, server]
```

List khởi tạo này để duy trì một danh sách các luồng đầu vào. Có hai tình huống đầu vào có thể xảy ra. Một là client muốn cung cấp đầu vào thủ công để gửi cho server, hai là client đang gửi tin nhắn sẽ được in lên màn hình. Lựa chọn trả về từ ```sockets_list``` luồng mà là đầu đọc cho đầu vào. Ví dụ, nếu client muốn gửi tin nhắn thì điều kiện if sẽ luôn là ```True```. 

```python
read_sockets, write_sockets, error_socket = select.select(sockets_list, [], [])
```

Tùy thuộc vào hành động của client mà hàm này sẽ trả về giá trị xác định trong một luồng. Tất cả đều được thực hiện với file descriptor của socket.

```python
for socks in read_sockets:
    if socks == server:
        message = sock.recv(2048)
```

Đọc từ đầu vào và xác định dữ liệu nhận từ server sau đó hiện lên màn hình. Nếu không phải là server thì sẽ nhận giá trị đầu vào là message của client đó là hiện lên màn hình với mở đầu là ```<You>```. ```sys.stdout.write()``` là đầu ra tiêu chuẩn của hệ thống với ```write()``` là viết ra màn hình.  

```python
server.close()
```

Đóng kết nối với server khi có tín hiệu từ bên ngoài. 











































