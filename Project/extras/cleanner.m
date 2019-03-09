

for j = 34861:90000
   filename = ['\\10.164.29.219\Data\data ' int2str(j)];
   load(filename);
   
   matches = rmfield(matches,'more');
   
   save(filename,'i','a','angle','cornerCmp','correctMatches','extractions','imgDiagonal','imgDim','mADP','mCMP','matches','mate2','maxAvgDifProp','message','minCornerMatchesProp','misMatches','missingMatches','numCorners1','numIntersectedCorners','rDP','rMP','rP','sim','time','trans','v');
    
   fprintf(['j=' int2str(j) '\n'])
end