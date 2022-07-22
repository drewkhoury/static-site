#!/usr/bin/env python3

from aws_cdk import core

from foo.foo_stack import FooStack


app = core.App()
FooStack(app, "foo")

app.synth()
