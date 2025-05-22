function out_interp_freq = Filter_And_Interp(freq,Order_N,t,value)
% freq > 30,��ʾ�����Ҫ��ֵ
% value ��������
% t����������
t = t';
value = value';
Fs = 30;        % Sampling Frequency,��ֵƵ��
%% �˲�ǰ��ֵ
out_interp_Fs = interp1(t,value,t(1):1/Fs:t(end),'linear');

%% hamming���˲�
Order_N  = 21;         % Order
Fc = 5;          % First Cutoff Frequency
%Fc = 3;          % First Cutoff Frequency
flag = 'scale';  % Sampling Flag
win = hamming(Order_N);

b = fir1(Order_N-1, Fc/(Fs/2), 'LOW', win, flag);
out_filter = filter(b,1,out_interp_Fs);
out_filter = out_filter(Order_N:end);

out_filter = [out_interp_Fs(1:(Order_N-1)/2),out_filter(1:end),out_interp_Fs(end-(Order_N-1)/2+1:end)];

t_o = t(1):1/Fs:t(end);
t_o(end) = t(end);
t_i = t(1):1/freq:t(end);
t_i(end) = t(end);
% %% Savitzky-Golay Filter
% 
% 
% % framelen = 25;
% % order = 2;
% 
% framelen = 11;
% order = 5;
% out_filter = sgolayfilt(out_interp_Fs,order,framelen);
%% �˲����ֵ
if freq>30
out_interp_freq = interp1(t_o,out_filter,t_i,'spline')';
else
    out_interp_freq = out_filter';
end


