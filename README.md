# Demo of basic AWS CDK with Python

Run `make` to get started.

For more info on how this repo manages the infrastructure code see [infra/README.md](infra/README.md)

This repo aims to:
- Manage an infra stack via AWS CDK
- Build a simple infra stack for a static site: Route53, CloudFront, S3
- Easy setup and mangement (3 musketeers) - make/compose/docker should be all the software you need
- The user is prompted for any other expectations (config etc) as they're needed, so setup will run automatically

Features:
- shell into base container
- can rebuild compose images when you change the dockerfile
- python deps via venv, and won't rebuilt if folder exists (to save time), can run `make deps` to override this
- make has targets, with groups, and colors
- 3 musketeers compliant, all driven by make which calls compose and docker, and making optimial use of conventions like `_target` and comments only for the targets users need to see
- setup script runs at very start of project, and whenever configs.env is empty 

todo:
- build out the actual infra code (in comments but needs to be reworked and cleaned up for python)
- using python activate/venv (to ensure some caching between commands) but not sure if that's the ideal solution, it's make the make file a bit more complicated

done:
- be more clear about requirements (key env vars, AWS creds etc) ... now a setup script that runs when needed
- using a node image, so had to add python bits and CDK library in Dockerfile - ideally I'd like to use a well made image (tab complete doesn't work, up arrow for history doesn't work) ... was using /bin/sh but now defaulting to /bin/bash which seems to do what I expect it to in the terminal