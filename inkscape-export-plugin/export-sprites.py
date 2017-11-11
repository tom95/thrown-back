#!/usr/bin/env python
#-*- coding: utf-8 -*-

import re
import os
import sys
import subprocess
import inkex

from simpletransform import computeBBox

class ExportSprites(inkex.Effect):
  def __init__(self):
    inkex.Effect.__init__(self)

  def effect(self):
    folder = self.get_folder()
    all_boxes = self.get_all_bboxs()
    for id, node in self.selected.iteritems():
      filename = folder + '/' + str(id) + '.png'
      #box = computeBBox([node])
      #inkex.errormsg('%s %s %s %s = %s %s %s %s' % (self.val(box[0]), self.val(box[1]), self.val(box[2]), self.val(box[3]), box[0], box[1], box[2], box[3]))
      #inkex.errormsg(id + ' -> ' + all_boxes[id])
      cmd = 'inkscape --export-id %s -a %s --export-id-only -e \"%s\" \"%s\"' % (id, all_boxes[id], filename, self.args[-1])
      p = subprocess.Popen(cmd, shell=True, stdout=subprocess.PIPE)
      p.wait()

  def get_all_bboxs(self):
      cmd = 'inkscape --query-all %s' % (self.args[-1])
      p = subprocess.Popen(cmd, shell=True, stdout=subprocess.PIPE)
      out, err = p.communicate()
      lines = [line.split(',') for line in out.split('\n') if len(line) > 0]
      return {values[0]: ('%s:%s:%s:%s' % (self.val(values[1]), self.val(values[2]), self.val(values[1]) + self.val(values[3]), self.val(values[2]) + self.val(values[4]))) for values in lines}

  def val(self, v):
    #return int(self.uutounit(float(v), 'px'))
    # return int(self.uutounit(float(v), self.getDocumentUnit()))
    #return int(float(v))
    #return self.unittouu(str(v) + 'px')
    #pageHeight = self.uutounit(self.unittouu(self.getDocumentHeight()), "px")
    #pageWidth = self.uutounit(self.unittouu(self.getDocumentWidth()), "px")

    return int(float(v))
    #return self.uutounit(float(v),"px") * self.getDocumentScale() * 0.5
    #return self.uutounit(self.unittouu(str(v)), "px") * self.getDocumentScale()

  def get_folder(self):
    svg = self.document.getroot()
    att = '{http://www.inkscape.org/namespaces/inkscape}export-filename'
    try:
      export_file = svg.attrib[att]
    except KeyError:
      inkex.errormsg("You need to have previously exported the document. " +
          "Otherwise no export hints exist!")
      sys.exit(-1)
    dirname, filename = os.path.split(export_file)
    return dirname

  def getDocumentScale(self):
    """Returns the ratio between the SVG width and viewBox attributes.
    """
    documentscale = 1  # default to 1
    svgwidth = self.getDocumentWidth()
    viewboxstr = self.document.getroot().get('viewBox')
    if viewboxstr:
      param = re.compile(r'(([-+]?[0-9]+(\.[0-9]*)?|[-+]?\.[0-9]+)([eE][-+]?[0-9]+)?)')
      p = param.match(svgwidth)
      width = 100  # default
      viewboxwidth = 100  # default
      if p:
        width = float(p.string[p.start():p.end()])
      else:
        errormsg(_("SVG Width not set correctly! Assuming width = 100"))

      viewboxnumbers = []
      for t in viewboxstr.split():
        try:
          viewboxnumbers.append(float(t))
        except ValueError:
          pass
      if len(viewboxnumbers) == 4:  # check for correct number of numbers
        viewboxwidth = viewboxnumbers[2]

      documentscale =  self.unittouu(str(width / viewboxwidth))

    return documentscale


if __name__ == '__main__':
  plugin = ExportSprites()
  plugin.affect()
