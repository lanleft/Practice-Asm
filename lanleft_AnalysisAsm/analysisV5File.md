## Phân tích File v5 

Đầu tiên file gọi hàm `GetComputerNameA` để lấy tên của máy tính

```
GetComputerNameA:Retrieves the NetBIOS name of the local computer. This name is established at system startup, when the system reads it from the registry
```

Hàm này lấy tên NetBIOS của máy tính đang chạy. Tên này được sử dụng khi khởi chạy hệ thống.

![](C:\Users\Lan Left\Pictures\crop\computerName.png)

Sau đó dùng hàm `CreateFileA` để tạo một file mới có tên là `beacon.txt` và ghi giá trị nhận được từ hàm `GetComputerNameA` vào file đó. 

