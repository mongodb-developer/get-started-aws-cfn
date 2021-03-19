#!/usr/bin/env python3
import sys
import json

#f = "/home/jason/work/temp/foo33/quickstart-mongodb-atlas-resources/cfn-resources/project/.rpdk-config"
f = sys.argv[1]

with open(f) as ff:
    d = json.load(ff)
    d["settings"]["import_path"]=d["settings"]["importpath"]
    del d["settings"]["importpath"]
    print (json.dumps(d, indent=2, ensure_ascii=False))
