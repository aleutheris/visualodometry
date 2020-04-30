function s = sucess(cornerCmp,correctCorners)
    if cornerCmp(1)<correctCorners
        s = false;
    else
        s = true;
    end
end

