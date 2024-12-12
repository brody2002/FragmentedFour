from itertools import permutations
import json

def load_levels_from_json(file_path: str) -> list[list[str]]:
    try:
        with open(file_path, "r") as f:
            levels = json.load(f)
        if not isinstance(levels, list) or not all(isinstance(l, list) and all(isinstance(s, str) for s in l) for l in levels):
            raise ValueError("Invalid format in JSON file. Expected list of lists of strings.")
        return levels
    except Exception as e:
        print(f"Error loading levels from {file_path}: {e}")
        return []

def scoreCalc(inputLevel: list[str]) -> bool:
# Check for duplicate fragments
    seen = set()
    for i, fragment in enumerate(inputLevel):
        if fragment in seen:
            print(f"Duplicate fragment '{fragment}' found at index {i}.")
            return False
        seen.add(fragment)

    totalScore = 0

    # Load a dictionary of valid English words
    with open("dictionary.txt") as f:
        dictionary = set(word.strip().lower() for word in f)

    valid_words = set()  # To store all valid words
    quartileList = set()  # Use a set to avoid duplicates

    # Check combinations for lengths 1 to 4
    for length in range(1, 5):
        for combo in permutations(inputLevel, length):
            combined_word = "".join(combo)
            if combined_word in dictionary:
                valid_words.add(combined_word)
                totalScore += 2 ** (length - 1)  # Score based on word length
                # If it's a quartile (length == 4), track it
                if length == 4:
                    quartileList.add(combined_word)

    # Intended quartiles (group every 4 fragments)
    intended_quartiles = [
        "".join(inputLevel[i:i+4]) for i in range(0, len(inputLevel), 4)
    ]
    missing_quartiles = [
        word for word in intended_quartiles if word not in quartileList
    ]

    # Debug output for missing quartiles
    if missing_quartiles:
        print("The following intended quartiles didn't make it:", missing_quartiles)

    # Debug output for quartiles
    if len(quartileList) < 5:
        print("Not enough quartiles of length 4 in this level:", quartileList)

    # Add the bonus score
    finalScore = totalScore + 40

    # Print debugging information
    print(f"Total Score: {finalScore}")
    print(f"Quartiles Count: {len(quartileList)}")
    print(f"Quartiles: {quartileList}")

    # Level validation logic
    return finalScore >= 100 and len(quartileList) >= 5

def runMainTest():
    levels = load_levels_from_json("levels.json")
    if not levels:
        print("Failed to load levels. Exiting.")
        return

    levelCounter = 1
    for level in levels:
        if len(level) != 20:
            print("level ", levelCounter, "length invalid: ", len(level))
            return
        print("Level: ", levelCounter)
        if scoreCalc(level):
            print("")
        else:
            print("Level is impossible on level: ", levelCounter)
            return

        levelCounter += 1
    print("ALL the levels have been made CORRECTLY!\n\n")
    return


# MAIN
runMainTest()
