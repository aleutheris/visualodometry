function [ usedCornersCalc, firstPhaseMatchesCalc ] = dinamicCalc( extractedCorners, usedCorners, firstPhaseMatches )

    ratio = min(extractedCorners(1), extractedCorners(2)) / max(extractedCorners(1), extractedCorners(2));

    m = (usedCorners(2) - usedCorners(1)) / (0.5 - 1);
    b = usedCorners(1) - 1 * m;            
    usedCornersCalc = round( m * ratio + b );

    if usedCornersCalc > usedCorners(2)
        usedCornersCalc = usedCorners(2);
    end
    
    
    m = (firstPhaseMatches(2) - firstPhaseMatches(1)) / (0.5 - 1);
    b = firstPhaseMatches(1) - 1 * m;            
    firstPhaseMatchesCalc = round( m * ratio + b );

    if firstPhaseMatchesCalc > firstPhaseMatches(2)
        firstPhaseMatchesCalc = firstPhaseMatches(2);
    end 

end

