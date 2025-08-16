function [K, Ke, sysC, thong_tin] = bo_dieu_khien_con_lac_xe_day(sys, p)
    syms k1 k2 k3 k4 kex ketheta s;
    
    % Khai báo ma trận các hệ số điều khiển
    k = [k1 k2 k3 k4];
    ke = [kex ketheta];

    % Khai báo các ma trận không gian trạng thái mới
    Ac = [(sys.A-sys.B*k) (sys.B*ke); -sys.C zeros(2,2)];
    Bc = [zeros(4,2); eye(2)];
    Cc = [sys.C zeros(2,2)];
    
    % So sánh hệ số phương trình đặc trưng để tìm ra các hệ số
    denPoly = poly(p);
    denc = coeffs(collect(det(s*eye(6) - Ac), s), s, 'All');
    sol = solve([denPoly(1) == denc(1), ...
        denPoly(2) == denc(2), ...
        denPoly(3) == denc(3), ...
        denPoly(4) == denc(4), ...
        denPoly(5) == denc(5), ...
        denPoly(6) == denc(6)], ...
        [k1, k2, k3, k4, kex, ketheta]);
    
    % Chuyển đổi kiểu dữ liệu của các hệ số về kiểu double
    K1 = double(sol.k1);
    K2 = double(sol.k2);
    K3 = double(sol.k3);
    K4 = double(sol.k4);
    Kex = double(sol.kex);
    Ketheta = double(sol.ketheta);

    % Đổi ma trận Ac về ma trận double
    Ac = double(subs(Ac, [k1 k2 k3 k4 kex ketheta], [K1 K2 K3 K4 Kex Ketheta]));

    % Trả về các ma trận hệ 
    sysC = ss(Ac, Bc, Cc, zeros(2,2));
    K = [K1 K2 K3 K4];
    Ke = [Kex Ketheta];

    % Thông tin đáp ứng của hệ với đầu vào là [xd θd] = [1 0]
    % Do hệ cần 2 đầu vào mà đầu vào θd (góc lắc mong muốn) luôn bằng 0
    % Nên chỉ cần cung cấp một hàm nấc đơn vị cho hệ sysc(:,1)
    thong_tin = stepinfo(sysC(:,1)); 
    fprintf("Đáp ứng của vị trí xe đẩy x với đầu vào [xd θd] = [1 0]:\n");
    fprintf("Thời gian tăng: %f giây.\n", thong_tin(1).RiseTime);
    fprintf("Thời gian xác lập: %f giây.\n", thong_tin(1).SettlingTime);
    fprintf("Độ vọt lố : %f%%.\n", thong_tin(1).Overshoot);
    fprintf("Giá trị đỉnh: %f.\n", thong_tin(1).Peak);
    fprintf("Thời gian đỉnh: %f giây.\n\n", thong_tin(1).PeakTime);

    fprintf("Đáp ứng của góc lắc con lắc θ với đầu vào [xd θd] = [1 0]:\n");
    fprintf("Giá trị đỉnh: %f.\n", thong_tin(2).Peak);
    fprintf("Thời gian đỉnh: %f giây.\n", thong_tin(2).PeakTime);
    
    % Vẽ đồ thị đáp ứng đầu ra với đầu vào [xd θd] = [1 0]
    step(sysC(:, 1), 6);
    grid on;
end