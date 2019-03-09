function [ b, alf ] = calibrateCaptor( X , Z )

    b = ( Z(1)*X(2) - Z(2)*X(1) ) / ( Z(2) - Z(1) );

    alf = 2*atan( 0.5 * (Z(2)-Z(1)) / (X(2)-X(1)) );

end

