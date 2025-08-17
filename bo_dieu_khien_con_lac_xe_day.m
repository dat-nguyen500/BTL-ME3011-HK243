function [K, Ke, sysC, thong_tin] = bo_dieu_khien_con_lac_xe_day(sys, p, max_time)
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
    [y, t] = step(sysC(:, 1));
    
    % Giới hạn thời gian hiển thị để loại bỏ khoảng trống
    time_idx = t <= max_time;
    t = t(time_idx);
    y = y(time_idx, :);
    
    % Tạo figure mới
    figure;
    
    % Đồ thị đầu tiên - vị trí xe đẩy x
    subplot(2,1,1);
    plot(t, y(:,1), 'b-', 'LineWidth', 1.5);
    hold on;
    
    % Thêm các đường và điểm cho Tr và Ts
    %rise_time = thong_tin(1).RiseTime;
    settling_time = thong_tin(1).SettlingTime;
    
    % Đường thời gian tăng (từ 10% đến 90% giá trị cuối)
    final_value = y(end,1);
    ten_percent = 0.1 * final_value;
    ninety_percent = 0.9 * final_value;
    
    % Tìm chỉ số tương ứng với 10% và 90%
    idx_10 = find(y(:,1) >= ten_percent, 1);
    idx_90 = find(y(:,1) >= ninety_percent, 1);
    
    % Vẽ đường ngang cho 90% (chỉ đến vị trí 90%)
    plot([0, t(idx_90)], [ninety_percent, ninety_percent], 'k--', 'LineWidth', 1);
    
    % Vẽ đường dọc cho thời gian tăng - từ (t_10%, 0) đến (t_10%, 90%)
    plot([t(idx_10), t(idx_10)], [0, ninety_percent], 'k--', 'LineWidth', 1);
    plot([t(idx_90), t(idx_90)], [0, ninety_percent], 'k--', 'LineWidth', 1);
    
    % Vẽ điểm tại 10% và 90%
    plot(t(idx_10), ten_percent, 'bo', 'MarkerSize', 8, 'MarkerFaceColor', 'b');
    plot(t(idx_90), ninety_percent, 'bo', 'MarkerSize', 8, 'MarkerFaceColor', 'b');
    
    % Thêm tick marks và labels cho Tr trên trục hoành
    current_xticks = xticks;
    current_xticklabels = cellstr(string(xticklabels)); % Chuyển đổi về cell array
    new_xticks = [current_xticks, t(idx_90)];
    new_xticklabels = [current_xticklabels; {'Tr'}]; % Sử dụng ; thay vì ,
    
    % Sắp xếp ticks và labels cùng nhau
    [sorted_xticks, sort_idx] = sort(new_xticks);
    sorted_xticklabels = new_xticklabels(sort_idx);
    xticks(sorted_xticks);
    xticklabels(sorted_xticklabels);
    
    % Đường thời gian xác lập (±2% giá trị cuối)
    upper_bound = 1.02 * final_value;
    lower_bound = 0.98 * final_value;
    plot([0, max(t)], [upper_bound, upper_bound], 'k--', 'LineWidth', 1);
    plot([0, max(t)], [lower_bound, lower_bound], 'k--', 'LineWidth', 1);
    
    % Vẽ đường dọc cho thời gian xác lập và điểm tại giao với đường giới hạn
    if settling_time <= max(t)
        % Vẽ đường dọc từ trục hoành đến điểm settling
        plot([settling_time, settling_time], [0, upper_bound], 'k--', 'LineWidth', 1);
        % Tìm giá trị tại thời điểm settling time
        settling_idx = find(t >= settling_time, 1);
        if ~isempty(settling_idx)
            settling_value = y(settling_idx, 1);
            plot(settling_time, settling_value, 'bo', 'MarkerSize', 8, 'MarkerFaceColor', 'b');
            % Thêm tick mark và label cho Ts trên trục hoành
            current_xticks = xticks;
            current_xticklabels = cellstr(string(xticklabels)); % Chuyển đổi về cell array
            new_xticks = [current_xticks, settling_time];
            new_xticklabels = [current_xticklabels; {'Ts'}]; % Sử dụng ; thay vì ,
            
            % Sắp xếp ticks và labels cùng nhau
            [sorted_xticks, sort_idx] = sort(new_xticks);
            sorted_xticklabels = new_xticklabels(sort_idx);
            xticks(sorted_xticks);
            xticklabels(sorted_xticklabels);
        end
    end
    
    ylabel('x (m)');
    grid on;
    hold off;
    
    % Đồ thị thứ hai - góc lắc θ
    subplot(2,1,2);
    plot(t, y(:,2), 'b-', 'LineWidth', 1.5);
    hold on;
    
    % Thêm các đường ±0.35 và ±0.02
    plot([0, max(t)], [0.35, 0.35], 'k--', 'LineWidth', 1);
    plot([0, max(t)], [-0.35, -0.35], 'k--', 'LineWidth', 1);
    plot([0, max(t)], [0.02, 0.02], 'k--', 'LineWidth', 1);
    plot([0, max(t)], [-0.02, -0.02], 'k--', 'LineWidth', 1);
    
    % Thêm tick marks và labels cho ±0.35 trên trục tung
    current_yticks = yticks;
    current_yticklabels = cellstr(string(yticklabels)); % Chuyển đổi về cell array
    new_yticks = [current_yticks, 0.35, -0.35];
    new_yticklabels = [current_yticklabels; {'0.35'}; {'-0.35'}]; % Sử dụng ; để stack vertically
    [sorted_yticks, sort_idx] = sort(new_yticks);
    sorted_yticklabels = new_yticklabels(sort_idx);
    yticks(sorted_yticks);
    yticklabels(sorted_yticklabels);
    
    % Tìm giá trị max và min của θ
    [max_theta, idx_max] = max(y(:,2));
    [min_theta, idx_min] = min(y(:,2));
    
    % So sánh |max| và |min| để quyết định vẽ điểm nào
    if abs(max_theta) >= abs(min_theta)
        % Vẽ điểm tại giá trị max
        plot(t(idx_max), max_theta, 'bo', 'MarkerSize', 8, 'MarkerFaceColor', 'b');
        plot([t(idx_max), t(idx_max)], [0, max_theta], 'k--', 'LineWidth', 1);
        % Thêm chú thích cho điểm max
        text(t(idx_max)+0.1, max_theta+0.01, sprintf('Max=%.3f at t=%.2fs', max_theta, t(idx_max)), 'FontSize', 10);
    else
        % Vẽ điểm tại giá trị min
        plot(t(idx_min), min_theta, 'bo', 'MarkerSize', 8, 'MarkerFaceColor', 'b');
        plot([t(idx_min), t(idx_min)], [0, min_theta], 'k--', 'LineWidth', 1);
        % Thêm chú thích cho điểm min
        text(t(idx_min)+0.1, min_theta-0.01, sprintf('Min=%.3f at t=%.2fs', min_theta, t(idx_min)), 'FontSize', 10);
    end
    
    ylabel('θ (rad)');
    xlabel('Time (secs)');
    grid on;
    hold off;
end