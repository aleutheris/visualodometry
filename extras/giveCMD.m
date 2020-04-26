function [array] = giveCMD( in )
    array2 = in:0.1:in+0.1*1;
    array2 = array2(array2<=1);
    
    len = length(array2);
    
    array1 = in-0.1:-0.1:in-0.1*(5-len);
    array1 = array1(array1>0);
    array1 = array1(length(array1):-1:1);
    
    array = [array1 array2];
end

