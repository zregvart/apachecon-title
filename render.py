# -*- Coding: UTF-8 -*-
# coding: utf-8

import types

def dump_obj(obj, level=0):
  for key, value in obj.__dict__.items():
    if not isinstance(value, types.InstanceType):
      print " " * level + "%s -> %s" % (key, value)
    else:
      dump_obj(value, level + 2)

def createInstance(app, group):
  app.loadProject("title.ntp")

  app.title.text.set('<big>This is a test very long very long title is set here to test the very long title</big>\n<span color="#cc2235ff">First Last, Second Again</span>')

  # workaround for the ramp mask bug after updating the text
  #app.title_ramp.disableNode.set(True)
  #app.title_ramp.disableNode.set(False)
