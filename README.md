# Demo of basic AWS CDK with Pyton

This repo aims to:
- Manage an infra stack via AWS CDK
- Route53, CloudFront, S3 - Static site
- Easy setup and mangement (3 musketeers) - make/compose/docker should be all the software you need

Run `make` to see current functionality.

features:
- shell into base container
- can rebuild compose images when you change the dockerfile
- python deps via venv, and won't rebuilt if folder exists (to save time)
- make has targets, with groups, and colors
- 3 musketeers compliant, all driven by make which calls compose and docker, and making optimial use of conventions like `_target` and comments only for the targets users need to see 

todo:
- build out the actual infra code
- be more clear about requirements (key env vars, AWS creds etc)
- using a node image, so had to add python bits and CDK library in Dockerfile - ideally I'd like to use a well made image (tab complete doesn't work, up arrow for history doesn't work)
- using python activate/venv (to ensure some caching between commands) but not sure if that's the ideal solution, it's make the make file a bit more complicated
