function [ f ] = application_COPDecomposition
%APPLICATION_COPDECOMPOSITION: COP�ֽⷽ������
%% global function handler
global Handler_Filter_med2sg Handler_generateTimetag Handler_computeAcc_withSGfilter
Handler_Filter_med2sg = @(s)sgolayfilt(medfilt1(s,3),3,7);
Handler_computeAcc_withSGfilter = ...
    @(s, T)smooth(gradient(gradient(s, T), T), 5, 'sgolay', 1);
Handler_generateTimetag = @(T,n) (0: T : (n-1)*T)';
%% functions
f.getMigrResiDecomposition = ...
    @(ml, ap, fs)getMigrResiDecomposition(ml, ap, fs);
f.getResiAboveo01 = ...
    @(resi_ml, resi_ap) find(sqrt(resi_ml.^2 + resi_ap.^2) > 0.1);
f.getResiBelowo01 = ...
    @(resi_ml, resi_ap) find(sqrt(resi_ml.^2 + resi_ap.^2) <= 0.1);
end

function out = getMigrResiDecomposition(ml, ap, fs)
%% ʵ��COP�źŵķֽ�
%       �����źŵ�λ��ml�����ף���ap�����ף���fs��Hz������Ϊ������
%       ����������ֽ����Լ��������õ�ԭʼCOP�źţ����ź�ʱ���Ӧ��
%

if ~iscolumn(ml)||~iscolumn(ap)
    error('Input of ML and AP should be column vector.');
end
global Handler_Filter_med2sg Handler_generateTimetag
ml = ml - mean(ml);     % ȥƽ��
ap = ap - mean(ap);
ml = Handler_Filter_med2sg(ml);     % ƽ��
ap = Handler_Filter_med2sg(ap);
T = 1/fs;
t = Handler_generateTimetag(T, numel(ml));
% interpolation point
p_t = getFeaturePoints(ml, ap, t, T);
% interpolate signal
migr_rough_ml = interp1(t, ml, p_t, 'pchip');       % ��ֵ�������ʱ���COPλ��
migr_rough_ap = interp1(t, ap, p_t, 'pchip');
migr_ml = interp1(p_t, migr_rough_ml, t, 'pchip');  % Migr�ź�
migr_ap = interp1(p_t, migr_rough_ap, t, 'pchip');
resi_ml = ml - migr_ml;                             % Resi�ź�
resi_ap = ap - migr_ap;
% trim signal
index = t > p_t(1) & t < p_t(end);     % ���ÿ�ʼ��ĩβƫ��ϴ�Ĳ�ֵ���
out.ml = ml(index); out.ap = ap(index);
out.migr_ml = migr_ml(index); out.migr_ap = migr_ap(index);
out.resi_ml = resi_ml(index); out.resi_ap = resi_ap(index);
out.t = t(index); out.t = out.t - out.t(1);     % �ź�ʱ��ӵ�һ������ʱ�䵽���һ������ʱ��
end

function p_t = getFeaturePoints(ml, ap, t, T)
%% ����COP�ź������ڷֽ��źŵ������㣬������
%       �ͼ��ٶȵ㣺���ٶ���ֵ25mm/s
%       ����ת�۵㣺���ٶ���ֵ25mm/s
%   �����Ϊ��������ml��ap�ֱ������ҡ�ǰ���źţ�t��ʱ���ǩ��T�ǲ������
%
global Acc_threshold
Acc_threshold = 25;     % Ԥ����ֵ
global Handler_computeAcc_withSGfilter
a_ml = Handler_computeAcc_withSGfilter(ml, T);
a_ap = Handler_computeAcc_withSGfilter(ap, T);
a = sqrt(a_ml.^2 + a_ap.^2);
% low acceleration point
low_acc_index = a < Acc_threshold;
% quick transient
q_t = getQuickTransietPoint(a_ml, a_ap, t); %       ����ת�۵�

p_t = sort([t(low_acc_index); q_t]);
end

function q_t = getQuickTransietPoint(a_ml, a_ap, t)
%% ����COP�ź��еĿ���ת��������
%       �����Ϊ����������λ�����ٶ�a_ml, a_ap --> mm*s-2, t --> s
%
global Acc_threshold
CellOpen = @(in) [in{:}]';

Acc_previous_ml = a_ml(1:end-1);
Acc_previous_ap = a_ap(1:end-1);
Acc_latter_ml = a_ml(2:end);
Acc_latter_ap = a_ap(2:end);
dt = CellOpen( ...���������������ٶ�����ת�������о�������С���ٶ��Լ���صľ�����
    arrayfun(@(x1, y1, x2, y2)getTriangleAreaHeightByHeronformula ...
    (x1, y1, x2, y2), Acc_previous_ml, Acc_previous_ap, ...
    Acc_latter_ml, Acc_latter_ap, 'UniformOutput', false) ...
    );

transientAcc = dt(1:5:end);     % ��ȡ����ת�������е���С���ٶ�
lambda_previous = dt(2:5:end);
lambda_latter = dt(3:5:end);
t_previous = t(1:end-1);
t_latter = t(2:end);

q_t = t_previous + ...����ÿ������ת����������С���ٶ����ڵ��ʱ��
    (t_latter - t_previous) .* lambda_previous ./ (lambda_previous + lambda_latter);
% ɸѡ��Ч�ĵ㣬����С���ٶ���ǰ����ٶ�֮��ͬʱС����ֵ
index_valid = lambda_previous > 0 & lambda_latter > 0 & transientAcc < Acc_threshold;
q_t = q_t(index_valid);
end

%% Basic Mathematic
function result = getTriangleAreaHeightByHeronformula(x1,y1,x2,y2)
% ��Ҫ: ������������ά������ת���������
% �ο�:
%   ���׹�ʽ https://baike.baidu.com/item/%E6%B5%B7%E4%BC%A6%E5%85%AC%E5%BC%8F/106956?fr=aladdin
%   ���Ҷ��� https://baike.baidu.com/item/%E4%BD%99%E5%BC%A6%E5%AE%9A%E7%90%86#1
% ���룺
%   ����������ά����������
% �����
%   ��������Ϊ�������������θߣ�D�������㵽��ʼ����ĩ�˾��루D_pre����
%   ���㵽��ֹ����ĩ�˾��루D_lat���������������S����
%   �нǴ�С��angle_theta������0-180��
%

a = sqrt(x1^2+y1^2);
b = sqrt(x2^2+y2^2);
c = sqrt((x1-x2)^2+(y1-y2)^2);
p = (a+b+c)/2;

D_pre = (c^2+a^2-b^2)/(2*c);
D_lat = (c^2+b^2-a^2)/(2*c);
S = sqrt(p*(p-a)*(p-b)*(p-c));
H = 2*S/c;
angle_theta = acosd((a^2+b^2-c^2)/(2*a*b));

result = [H, D_pre, D_lat, S, angle_theta];
end