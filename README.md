# Bài tập lớn Động lực học & Điều khiển (ME3011) - Học kỳ 243 - Lớp DT01

Đây là là kho lưu trữ các đoạn mã, sơ đồ, báo cáo được hình thành trong quá trình làm bài tập lớn môn Động lực học & Điều khiển (ME3011) - Học kỳ 243 - Lớp DT01.

## Sinh viên thực hiện

| STT | Họ và tên         | Mã số sinh viên | Nhiệm vụ |
| --- | ----------------- | --------------- | -------- |
| 1   | Nguyễn Đức Đạt    | 2111009         | Viết báo cáo, thiết kế các bộ điều khiển         |
| 2   | Trần Quang Đạo    | 2210647                | Thiết kế các bộ điều khiển, lập trình MATLAB/Simulink         |
| 3   | Thành viên bí mật | XXXXXX2         | Cung cấp chữ số cuối MSSV |


## Nội dung các tệp tin

Các tệp tin được chia làm 2 phần
- Phần báo cáo được soạn bằng LaTeX nằm trong thư mục `bao_cao`.
- Phần các tệp tin được xuất ra từ MATLAB/Simulink gồm các tệp đuôi `.m`, `.mlx`, `.mat`, `.slx` và các tệp tin khác.
    - Tệp `task.mlx` chứa các lệnh thực thi chính của bài tập lớn.
    - Tệp `bo_dieu_khien_con_lac_xe_day.m` là hàm để thiết kế bộ điều khiển không gian trạng thái và hiển thị các thông số đáp ứng của bộ điều khiển.
    - Tệp `bien.mat` chứa các hằng số, hàm truyền và không gian trạng thái của đề bài.
    - Tệp `PID_con_lac.mat` chứa các hệ số PID của bộ điều khiển con lắc.
    - Tệp `PID_xe_day.mat` chứa các hệ số PID của bộ điều khiển xe đẩy.
    - Tệp `thiet_ke_PID_con_lac.mat` là quá trình thiết kế bộ điều khiển PID con lắc bằng phương pháp quỹ đạo nghiệm số.
    - Tệp `thiet_ke_PID_xe_day.mat` là quá trình thiết kế bộ điều khiển PID xe đẩy bằng phương pháp quỹ đạo nghiệm số.
    - Tệp `phan_tich_he_thong_ode.slx` được dùng để phân tích hệ thống xe đẩ-con lắc, chỉ được dùng bên trong tệp `task.mlx`.
    - Tệp `kiem_chung_con_lac.slx` được dùng để kiểm chứng bộ điều khiển PID hệ thống con lắc và xem đáp ứng của xe đẩy, chỉ được dùng bên trong tệp `task.mlx`.
    - Tệp `kiem_chung_xe_day.slx` được dùng để kiểm chứng bộ điều khiển PID hệ thống xe đẩy và xem đáp ứng của con lắc, chỉ được dùng bên trong tệp `task.mlx`.


***Lưu ý*** Các tệp tin được xuất ra từ MATLAB/Simulink R2025a. Phiên bản của các tệp tin này cho MATLAB/Simulink R2021b nằm trong thư mục `matlab_r2021b`.

## Hướng dẫn sử dụng

### Tải toàn bộ kho lưu trữ về máy
Để có thể tải toàn bộ kho lưu trữ này về máy, bấm `Code` (màu xanh lá) rồi chọn 
`Download ZIP`.
![Hướng dẫn tải toàn bộ kho lưu trữ về máy](img/image_1.png)




### MATLAB/Simulink

Các bước để có thể chạy các tệp tin MATLAB/Simulink:

1. Mở thư mục chứa toàn bộ các tệp tin MATLAB/Simulink của bài tập lớn này.
2. Mở tệp tin `task.mlx`.
3. Chọn một section bất kỳ (được ngăn cách với nhau qua các đường gạch ngang) và nhấn `Run Section`.

![Hướng dẫn chạy mã MATLAB/Simulink](img/image_2.png)

### Về các tệp tin quá trình thiết kế bộ điều khiển PID

Có 2 tệp tin là `thiet_ke_PID_con_lac.mat` và `thiet_ke_PID_xe_day.mat` chứa quá trình thiết kế bộ điều khiển PID của con lắc và xe đẩy. Các bước để xem 2 tệp này như sau
1. Chạy lệnh sau trong MATLAB Terminal
```MATLAB
controlSystemDesigner
```
2. Cửa sổ Control System Designer hiện ra và chọn tệp tin muốn mở để xem rồi nhấn `Open`.

![Hướng dẫn xem tệp tin thiết kế](img/image_3.png)

## Hàm `bo_dieu_khien_con_lac_xe_day()`

Hàm này được thiết kế để tạo bộ điều khiển không gian trạng thái mở rộng (augmented state space controller) cho hệ thống xe đẩy-con lắc với khả năng theo dõi tín hiệu tham chiếu và loại bỏ sai số xác lập.

### Cú pháp

```matlab
[K, Ke, sysC, thong_tin] = bo_dieu_khien_con_lac_xe_day(sys, p, max_time)
```

### Tham số đầu vào

- `sys`: Hệ thống state space ban đầu của xe đẩy-con lắc (dạng `ss`)
- `p`: Vector chứa 6 cực mong muốn của hệ thống điều khiển mở rộng
- `max_time`: Thời gian tối đa để hiển thị đồ thị đáp ứng

### Tham số đầu ra

- `K`: Vector hệ số phản hồi trạng thái $\mathbf{K} = [k_1, k_2, k_3, k_4]$
- `Ke`: Vector hệ số phản hồi tích phân $\mathbf K_e = [k_{ex}, k_{e\theta}]$
- `sysC`: Hệ thống vòng kín mở rộng (6×2, có tích phân để loại bỏ sai số xác lập)
- `thong_tin`: Thông số đáp ứng của hệ thống (rise time, settling time, overshoot, etc.)

### Nguyên lý hoạt động

#### 1. Thiết kế bộ điều khiển mở rộng với tích phân

Hàm này sử dụng phương pháp **augmented state space** để thiết kế bộ điều khiển có khả năng loại bỏ sai số xác lập. Hệ thống được mở rộng bằng cách thêm các trạng thái tích phân của lỗi:

**Hệ thống gốc (4 trạng thái):**
```math
\dot{\mathbf{x}}(t) = \mathbf{A}\mathbf{x}(t) + \mathbf{B}\mathbf{u}(t)
```
```math
\mathbf{y}(t) = \mathbf{C}\mathbf{x}(t)
```

**Hệ thống mở rộng (6 trạng thái):**
```math
\begin{bmatrix} \dot{\mathbf{x}}(t) \\ \dot{\mathbf{x}}_N(t) \end{bmatrix} = \begin{bmatrix} \mathbf{A} - \mathbf{B}\mathbf{K} & \mathbf{B}\mathbf{K}_e \\ -\mathbf{C} & \mathbf{0}_{2 \times 2} \end{bmatrix} \begin{bmatrix} \mathbf{x}(t) \\ \mathbf{x}_N(t) \end{bmatrix} + \begin{bmatrix} \mathbf{0}_{4 \times 2} \\ \mathbf{I}_{2 \times 2} \end{bmatrix} \mathbf{r}(t)
```

Trong đó:
- $\mathbf{x}_N(t)$: Vector trạng thái tích phân của lỗi
- $\mathbf{K}$: Ma trận phản hồi trạng thái chính
- $\mathbf{K}_e$: Ma trận phản hồi trạng thái tích phân

#### 2. Gán cực bằng phương pháp symbolic

Hàm sử dụng **Symbolic Math Toolbox** của MATLAB để:

1. **Khai báo các biến symbolic:**
   ```matlab
   syms k1 k2 k3 k4 kex ketheta s;
   k = [k1 k2 k3 k4];
   ke = [kex ketheta];
   ```

2. **Xây dựng ma trận hệ thống mở rộng:**
   ```matlab
   Ac = [(sys.A-sys.B*k) (sys.B*ke); -sys.C zeros(2,2)];
   ```

3. **Giải phương trình đặc trưng:**
   - Tính đa thức đặc trưng mong muốn: `denPoly = poly(p)`
   - Tính đa thức đặc trưng của hệ thống: `det(s*eye(6) - Ac)`
   - Giải hệ phương trình để tìm các hệ số $k_1, k_2, k_3, k_4, k_{ex}, k_{e\theta}$

#### 3. Phân tích đáp ứng

Hàm tự động phân tích và hiển thị:

**Thông số đáp ứng vị trí xe đẩy ($x$):**
- Thời gian tăng (Rise Time): Từ 10% đến 90% giá trị cuối
- Thời gian xác lập (Settling Time): ±2% giá trị cuối
- Độ vọt lố (Overshoot): Tính theo %
- Giá trị đỉnh và thời gian đỉnh

**Thông số đáp ứng góc con lắc ($\theta$):**
- Giá trị đỉnh và thời gian đỉnh
- Kiểm tra ràng buộc: $|\theta| \leq 0.35$ rad (≈ 20°)

#### 4. Trực quan hóa kết quả

Hàm tự động vẽ 2 đồ thị con:

1. **Đồ thị vị trí xe đẩy:**
   - Đường đáp ứng chính
   - Đường thời gian tăng (Tr)
   - Đường thời gian xác lập (Ts) với dải ±2%
   - Các điểm đặc biệt được đánh dấu

2. **Đồ thị góc con lắc:**
   - Đường đáp ứng góc lắc
   - Đường ràng buộc ±0.35 rad
   - Đường ±0.02 rad (vùng xác lập)
   - Điểm cực trị được đánh dấu

### Ưu điểm của phương pháp

1. **Loại bỏ sai số xác lập:** Nhờ có tích phân trong vòng điều khiển
2. **Điều khiển đồng thời:** Cả vị trí xe và góc con lắc
3. **Gán cực chính xác:** Sử dụng symbolic math để giải chính xác
4. **Phân tích tự động:** Tính toán và hiển thị các thông số quan trọng
5. **Trực quan hóa đầy đủ:** Đồ thị với các thông số đánh dấu rõ ràng

### Ví dụ sử dụng

```matlab
% Load hệ thống từ file
load('bien.mat', 'sys_xe_day_con_lac');

% Định nghĩa các cực mong muốn (6 cực)
desired_poles = [-2, -3, -4, -5, -1+1j, -1-1j];

% Thiết kế bộ điều khiển
[K, Ke, sysC, info] = bo_dieu_khien_con_lac_xe_day(sys_xe_day_con_lac, desired_poles, 10);

% Hiển thị kết quả
fprintf('Ma trận K: [%.3f %.3f %.3f %.3f]\n', K);
fprintf('Ma trận Ke: [%.3f %.3f]\n', Ke);
```


## Liên hệ

Nếu có thắc mắc về bài tập lớn này, vui lòng liên hệ qua email hoặc tạo issue trên GitHub repository.

---

*Bài tập lớn này được thực hiện nhằm mục đích học tập trong môn Động lực học & Điều khiển (ME3011) tại Đại học Bách Khoa Hà Nội.*
