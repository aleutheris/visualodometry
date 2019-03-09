
function mouseTrack = pathGen(mouseTrack)

displacementGen = [2:2:120];
angleGen = [1:10:180 180] * pi() / 180;

transGen = zeros(2,length(displacementGen));

for i=1:length(displacementGen)
    if randi([0 1])==1        
        transGen(1,i) = displacementGen(i) * rand();
    else
        transGen(1,i) = -displacementGen(i) * rand();
    end
        
    if randi([0 1])==1
        transGen(2,i) = sqrt( displacementGen(i)^2 - transGen(1,i)^2 );
    else
        transGen(2,i) = -sqrt( displacementGen(i)^2 - transGen(1,i)^2 );
    end
end


k=1;
mouseTrack(k).origTransformation = eye(3,3);

for i=1:length(displacementGen)    
    for j=1:length(angleGen)
        k=k+1;
        
        mouseTrack(k).translation = transGen(:,i);
        mouseTrack(k).angle = angleGen(j);
        mouseTrack(k).relativeTransformation = kin.transform2D_A(transGen(:,i), angleGen(j));
        mouseTrack(k).origTransformation = mouseTrack(k-1).origTransformation * mouseTrack(k).relativeTransformation;       
    end
end
