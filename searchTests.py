# do it again but with a frequency word list of 370103 words it takes 722.1 MB of ram and 2% to 23% of processor
# when in resting state and when typing respectively.

# the wordlist you used had 370104 words, and that generated 2673058 words of output, making the script
# 2703915 lines long, and 70.1 MB big vs 1.12 MB normally.

inputFile = set(line.strip() for line in open(
    'wordlist10000MostPopularWordsFromTvShowsCleanedFoundOnWikipedia.txt'))
outputFile = open("outputBetterSearch.txt", "a")

for line in inputFile:
    if len(line) > 2:  # that's correct, as it counts with \n char
        for i in range(0, len(line)-1):  # that's correct
            if line[i] != line[i+1]:  # that's correct
                outputSearch = line[:i]+line[i+1] + \
                    line[i]+line[i+2:]
                if outputSearch in inputFile:
                    continue
                output = "::"+outputSearch.rstrip()+"::" + line+"\n"
                outputFile.write(output)
