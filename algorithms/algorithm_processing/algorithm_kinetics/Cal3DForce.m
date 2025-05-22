%% 计算地面对人体力（坐标系：右前上）
function F = Cal3DForce(m,a)
    F.x = m.*a.x;
    F.y = m.*a.y;
    F.z = m.*(a.z+9.8);
end