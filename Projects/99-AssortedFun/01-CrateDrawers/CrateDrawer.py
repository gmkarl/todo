import FreeCAD, FreeCADGui
import Part
from pivy import coin

u = FreeCAD.Units.parseQuantity
DEFAULT_CRATE_WIDTH = u('2 ft')
DEFAULT_CRATE_HEIGHT = u('18 in')
DEFAULT_THICKNESS = u('0.25 in')

class CrateDrawer:
	def __init__(self, obj):
		obj.addProperty('App::PropertyLength', 'CrateWidth', 'CrateDrawer', 'Width of a crate')
		obj.CrateWidth = DEFAULT_CRATE_WIDTH
		obj.addProperty('App::PropertyLength', 'CrateHeight', 'CrateDrawer', 'Height of a crate')
		obj.CrateHeight = DEFAULT_CRATE_HEIGHT
		obj.addProperty('App::PropertyLength', 'Thickness', 'CrateDrawer', 'Material thickness')
		obj.Thickness = DEFAULT_THICKNESS
		obj.Proxy = self

	def onChanged(self, fp, prop):
		# a property has changed
		self.execute(fp)
	
	def execute(self, fp):
		# recompute
		print 'recompute'
		fp.Shape = Part.makeBox(fp.CrateWidth, fp.CrateWidth, fp.CrateHeight)

def makeCrate():
		if not FreeCAD.ActiveDocument:
			FreeCAD.newDocument()
		c = FreeCAD.ActiveDocument.addObject('Part::FeaturePython', 'CrateDrawer')
		CrateDrawer(c)
		c.ViewObject.Proxy = 0
		FreeCAD.ActiveDocument.recompute()
	
