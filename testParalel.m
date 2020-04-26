
if matlabpool('size') == 0 % checking to see if my pool is already open
    matlabpool open 4
end

fprintf('blabla\n')
parfor i = 1:4
    tic
    c(:,i) = eig(rand(1000));
    toc
end