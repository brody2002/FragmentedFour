from itertools import permutations




levels = [
	["ca","lam","it","ous","pa","no","ra","mic","sp","ell","bo","und","bl","ust","eri","ng","pr","ow","le","rs"],
# 	["shr","ub","be","ry","mal","odo","ro","us","sch","oo","lr","oom","pe","da","nt","ic","de","ra","il","ed"],
# 	["rep","er","to","ry","im","mu","ni","zed","re","in","ve","nt","inj","us","ti","ces","dis","bel","ie","ved"],
# 	["po","stp","on","ed","nu","is","an","ce","co","rt","iso","ne","epi","ste","mol","ogy","in","te","rlu","des"],
# 	["pol","iti","ciz","ing","shr","iv","el","led","sub","cu","ltu","re","amb","ass","ado","rs","sl","aug","hte","red"],
# 	["fo","rma","li","ty","inc","ur","sio","ns","pa","ci","fi","ed","de","va","sta","te","pe","rs","ev","ere"],
# 	["br","ow","si","ng","ag","ric","ult","ure","typ","ogr","aph","ers","alp","hab","eti","ses","ba","ss","is","ts"],
# 	["re","mo","te","st","ari","sto","cr","ats","we","ak","ne","ss","fr","iz","zi","er","bo","mb","in","gs"],
# 	["ref","res","hin","gly","uni","nst","all","er","dis","tra","cti","ons","su","bli","min","al","mo","der","nis","es"],
# 	["su","rg","eo","ns","hai","rst","yli","st","cr","ow","ba","rs","co","nve","rt","or","dec","im","at","es"]
]










def scoreCalc(inputLevel: list[str]) -> bool:

    totalScore = 0

    # Load a dictionary of valid English words
    with open("dictionary.txt") as f:
        dictionary = set(word.strip().lower() for word in f)

    # Generate all possible 4-fragment combinations
    valid_words = set()

    for length in range(1, 5):
        for combo in permutations(inputLevel, length):
            combined_word = "".join(combo)
            if combined_word in dictionary:
                valid_words.add(combined_word)
                totalScore += 2 ** (length - 1)
                print(combined_word)
                
        
    # Check if score of 100 is possible.
    print("Total Score of totalScore: ", totalScore + 40)
    if totalScore + 40 >= 100:
        return True
    else:
        return False


# MAIN
levelCounter = 1
for level in levels:
    if scoreCalc(level):
        print("")
    else:
        print("level is impossible on level: ",levelCounter)
        break

    levelCounter += 1


