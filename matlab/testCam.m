clc
clear all
%close all

vid = videoinput('linuxvideo', 1, 'YUYV_640x480');
vid.ReturnedColorspace = 'rgb';
vid.FramesPerTrigger = 1;
triggerconfig(vid, 'manual');

op = [];
counter = 1;
while isempty(op)    
    start(vid);
    op = input('Press enter to continue...','s');

    trigger(vid);
    frame = getdata(vid);    
    
    imwrite(frame,['video/2/' num2str(counter) '.jpg'],'jpg');

    imshow(frame);
    
    stoppreview(vid);
    
    counter = counter+1;
end
