from itertools import permutations

levels = [
    ["ca","lam","it","ous","pa","no","ra","mic","sp","ell","bo","und","bl","ust","eri","ng","pr","ow","le","rs"],
    ["shr","ub","be","ry","mal","odo","ro","us","sch","oo","lr","oom","pe","da","nt","ic","de","ra","il","ed"],
    ["rep","er","to","ry","im","mu","ni","zed","re","in","ve","nt","inj","us","ti","ces","dis","bel","ie","ved"],
    ["po","stp","on","ed","nu","is","an","ce","co","rt","iso","ne","epi","ste","mol","ogy","in","te","rlu","des"],
    ["pol","iti","ciz","ing","shr","iv","el","led","sub","cu","ltu","re","amb","ass","ado","rs","sl","aug","hte","red"],
    ["fo","rma","li","ty","inc","ur","sio","ns","pa","ci","fi","ed","de","va","sta","te","pe","rs","ev","ere"],
    ["br","ow","si","ng","ag","ric","ult","ure","typ","ogr","aph","ers","alp","hab","eti","ses","ba","ss","is","ts"],
    ["re","mo","te","st","ari","sto","cr","ats","we","ak","ne","ss","fr","iz","zi","er","bo","mb","in","gs"],
    ["ref","res","hin","gly","uni","nst","all","er","dis","tra","cti","ons","su","bli","min","al","mo","der","nis","es"],
    ["su","rg","eo","ns","hai","rst","yli","st","cr","ow","ba","rs","co","nve","rt","or","dec","im","at","es"],
    ["hyp","not","ize","ing","ob","lit","era","ted","com","pli","cat","ion","wa","ter","fa","lls","tr","em","ble","rs"],
    ["un","der","sto","od","pe","ri","phe","ral","sy","no","nym","ous","ma","ni","fes","to","em","ph","asi","zed"],
    ["dis","ori","ent","ing","im","mu","tab","le","per","fo","rat","ing","har","mo","niz","ers","co","nti","nu","ous"],
    ["thr","es","hol","ds","res","ti","tut","ion","pa","la","din","ate","el","ec","tro","des","ha","b","it","ual"],
    ["ar","ch","ite","cts","stu","pe","fy","ing","scu","pl","tor","ial","el","ab","ora","tes","en","tan","gle","rs"],
    ["in","fra","str","uct","ure","ca","te","go","ries","pa","st","or","ate","re","co","un","ters","fr","ag","men","ts"],
    ["un","co","ver","ing","ir","rev","oca","ble","ho","sp","ita","ble","pr","oc","lam","ed","sy","ne","rg","ies"],
    ["dep","en","den","cies","lu","xu","ria","ted","mu","lti","pli","ers","re","fin","eri","es","sp","or","ts","men"],
    ["op","por","tu","nity","am","bi","ti","ous","tr","ans","mi","tter","ca","lam","iti","es","sta","gn","ant","ly"],
    ["su","per","st","iti","ons","con","tem","pla","ted","tr","ans","it","ion","s","se","pa","rat","ion","s","pa","th"],
    ["pa","ra","dig","ms","as","tro","no","mers","co","or","din","ate","re","ge","ne","rate","he","ar","tf","elt","ly"],
    ["cl","ass","ica","lis","ts","or","gan","iz","ing","in","cr","edi","bly","ma","rve","lou","sly","re","con","fig","ure"],
    ["el","eg","anc","ies","ex","tra","pol","ate","di","mi","nis","hed","ra","di","an","ces","he","al","ing","to","uch"],
    ["em","pow","ers","sol","ace","ful","nes","s","re","tro","gra","ded","ch","arg","ing","st","at","ion","fi","na","lly"],
    ["br","igh","ten","ing","in","flu","enc","ers","th","ou","san","ds","di","st","rib","ute","pe","ace","ful","ly","or"]
]



def scoreCalc(inputLevel: list[str]) -> bool:
    totalScore = 0

    # Load a dictionary of valid English words
    with open("dictionary.txt") as f:
        dictionary = set(word.strip().lower() for word in f)

    valid_words = set()  # To store all valid words
    quartileCounter = 0  # To count quartiles
    quartileList = []    # To store quartiles for debugging

    # Check combinations for lengths 1 to 4
    for length in range(1, 5):
        for combo in permutations(inputLevel, length):
            combined_word = "".join(combo)
            if combined_word in dictionary:
                valid_words.add(combined_word)
                totalScore += 2 ** (length - 1)  # Score based on word length
                # If it's a quartile (length == 4), track it
                if length == 4:
                    quartileCounter += 1
                    quartileList.append(combined_word)

    # Intended quartiles (group every 4 fragments)
    intended_quartiles = [
        "".join(inputLevel[i:i+4]) for i in range(0, len(inputLevel), 4)
    ]
    missing_quartiles = [
        word for word in intended_quartiles if word not in quartileList
    ]

    # Debug output for missing quartiles
    if len(missing_quartiles) > 0:
        print("The following intended quartiles didn't make it:", missing_quartiles)

    # Debug output for quartiles
    if quartileCounter < 5:
        print("Not enough quartiles of length 4 in this level:", quartileList)

    # Add the bonus score
    finalScore = totalScore + 40

    # Print debugging information
    print(f"Total Score: {finalScore}")
    print(f"Quartiles Count: {quartileCounter}")
    print(f"Quartiles: {quartileList}")

    # Level validation logic
    return finalScore >= 100 and quartileCounter >= 5





# MAIN
levelCounter = 1
for level in levels:
    if len(level) != 20:
        print("level length invalid: ", len(level))
        break
    print("Level: ", levelCounter)
    if scoreCalc(level):
        print("")
    else:
        print("Level is impossible on level: ", levelCounter)
        break

    levelCounter += 1

