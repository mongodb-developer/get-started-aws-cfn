#!/usr/bin/env python3

# export-mongocli-config.py
# usage: source this to export a mongocli project to the current environment
#
# $source <(./export-mongocli-config.py)
#
import os, sys, toml
config=f"/home/{os.getenv('USER')}/.config/mongocli.toml"
t=toml.load(config)
if len(sys.argv)>1:
    profile = sys.argv[1]
else:
    profile="default"
if not profile in t:
    raise Exception(f"No profile '{profile}' found in {config}")
d=t[profile]
if len(sys.argv)>2:
    export_mode = sys.argv[2]
else:
    export_mode = "shell"       # " `spaces` supported

if export_mode == "shell":
    print(f"export ATLAS_PUBLIC_KEY={d['public_api_key']}")
    print(f"export ATLAS_PRIVATE_KEY={d['private_api_key']}")
    print(f"export ATLAS_ORG_ID={d['org_id']}")

if export_mode == "spaces":
    print(f"{d['public_api_key']} {d['private_api_key']} {d['org_id']}")

if export_mode == "parameter-overrides":
    if len(sys.argv)>3:
        project_name = sys.argv[3]
    else:
        project_name = "get-started-mongodb-atlas-aws-sam-python"
    print( f"ParameterKey=PublicKey,ParameterValue={d['public_api_key']} ParameterKey=PrivateKey,ParameterValue={d['private_api_key']} ParameterKey=OrgId,ParameterValue={d['org_id']} ParameterKey=ProjectName,ParameterValue={project_name}" )


