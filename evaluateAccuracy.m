function totalAccuracy = evaluateAccuracy(results, labels)

numSamples = length(results);

numMatches = 0;

for i=1:numSamples
	
	if results(i) == labels(i)
		numMatches = numMatches+1;
	end
	
end


totalAccuracy = (numMatches/numSamples) * 100;


end