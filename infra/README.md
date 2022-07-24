This is a project for Python development with CDK.

The `cdk.json` file tells the CDK Toolkit how to execute your app.

The key file with infrastructure code is `foo/foo_stack.py`.

## Useful commands

 * `cdk ls`          list all stacks in the app
 * `cdk synth`       emits the synthesized CloudFormation template
 * `cdk deploy`      deploy this stack to your default AWS account/region
 * `cdk diff`        compare deployed stack with current state
 * `cdk docs`        open CDK documentation

# How to operate

All operations take place from the root of this repo via `make` commands.

## Running CKD commands

Run `make synth` to synthesize the CloudFormation template for this code.

You can also run `make ls` to list all stacks in the app.

You can add other commands, or run adhoc commands by creating your own
development shell:

```
make sh
```

Within the development shell you can run any commands:

```
cd infra
source .venv/bin/activate
cdk ls
```

## Python dependencies
A .venv will be created automatically the first time you run any CDK command.

Once .venv exists, this project will not try to install any new dependencies.

To add additional dependencies, for example other CDK libraries, just add
them to your `setup.py` file and run the `make deps` command.

