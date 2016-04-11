function [ UU,RR ] = CIS_CircleFitTaubin3D(Pts)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

[U, ~, ~] = svd(Pts);
XY_proj = U'*Pts;

Pare = CircleFitByTaubin(XY_proj(1:2,:)');

%estimated center 
UU = U * [Pare(1:2)';0]; 
%estimated radius 
RR = Pare(end);

end

