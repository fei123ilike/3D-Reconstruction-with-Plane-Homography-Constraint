% automatic compute the vanishing points, uncommnet the filename

nclusters = 3; % if too many planes, try to increase the initial cluster number
refine = 1;
% filename = 'P1030001';
filename = '1_001';
% filename = '2_002';
% filename = 'P1020848';
% filename = 'web1';
% filename = 'web2';
[VP1,VP2,VP3] = automaticVP(filename,nclusters,refine);

