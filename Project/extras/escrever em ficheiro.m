mkdir(['Pres/' int2str(numCorners1)])
dlmwrite(['Pres/' int2str(numCorners1) '/content.txt'],['trans=[' int2str(trans(1,1)) ' ' int2str(trans(2,1)) '] angle=' int2str(ag(1)*180/pi()) ' variation=' num2str(variation) ' repeatabilityPic=' num2str(repeatabilityPic) ':' ' rejectDistProp=' num2str(rejectDistProp) ' rejectMatchesProp=' num2str(rejectMatchesProp) ' minCornerMatchesProp=' num2str(minCornerMatchesProp) ' maxAvgDifProp=' num2str(maxAvgDifProp)])
print(h1,'-dbmp', ['Pres/' int2str(numCorners1) '/im1'])
print(h2,'-dbmp', ['Pres/' int2str(numCorners1) '/im2'])
print(h2+3,'-dbmp', ['Pres/' int2str(numCorners1) '/matchingDiferences'])

for i=1:sigsFigs
    print(i+h2+3,'-dbmp', ['Pres/' int2str(numCorners1) '/sigs' int2str(i)])
end