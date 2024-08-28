# TODO 
# fix extracdNSHostName (parses weird)

import json
import sys

# extract sAMAccountName and output to file
def extractSAMAccountName(dumpFile, outputFile):
    jsonFile = open(dumpFile)
    data = json.load(jsonFile)
    file = open(outputFile, "a")

    for i in data:
        for j in i["attributes"]["sAMAccountName"]:
            print(j)
            file.write(j + "\n")

    file.close()

def extractMail(dumpFile, outputFile):
    jsonFile = open(dumpFile)
    data = json.load(jsonFile)
    file = open(outputFile, "a")

    for i in data:
        for j in i["attributes"]["mail"]:
            print(j)
            file.write(j + "\n")

    file.close()

# extract dns hostname and output to file
def extractdNSHostName(dumpFile, outputFile):
    jsonFile = open(dumpFile)
    data = json.load(jsonFile)
    file = open(outputFile, "a")

    for i in data:
        for j in i["attributes"]["name"]:
            print(j)
            file.write(j + "\n")

    file.close()

if __name__ == "__main__":
    if len(sys.argv) == 4:
         if sys.argv[1] == '--usernames' and sys.argv[2].endswith(".json") and sys.argv[3].endswith(".txt"):
             extractSAMAccountName(sys.argv[2], sys.argv[3])
         if sys.argv[1] == '--mail' and sys.argv[2].endswith(".json") and sys.argv[3].endswith(".txt"):
            extractMail(sys.argv[2], sys.argv[3])
         if sys.argv[1] == '--computernames' and sys.argv[2].endswith(".json") and sys.argv[3].endswith(".txt"):
             extractdNSHostName(sys.argv[2], sys.argv[3])
            
    else:
        print("[!] Check args...")
        print("[+] Cmdline Args")
        print("\t--usernames")
        print("\t--mail")
        print("[+] Example:  python domaindump_parser.py --usernames domain_users.json output.txt")
        
