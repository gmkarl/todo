import math
import FreeCAD, FreeCADGui
import Part
from pivy import coin
import ScrewMaker
u = FreeCAD.Units.parseQuantity
v = FreeCAD.Base.Vector
screwMaker = ScrewMaker.Instance()

# X is left and right
# Y is positive away from viewer
# Z is up and down

# design a drawer
#
# bottom isn't really needed, but we'll need flangy things that stick down to nest into the lower bottom
# sides should be proper height
# front is absent for drawer to leave
# will need lip over top to prevent drawer from falling out
# will need sides to extend a little above top, to provide for stacking

# lip for overlap on bottom only sustains shift left and right, so doesn't need to bear a lot of weight
#  from above.
# wrt shifting, could be good to have two screws to provide for leverage, if there is room, but not required

# overlap lip
#	horizontal portion
#		evenly spaced screwholes
#		line up with outer edge
#		screw heads go on outside
#	corner
#		slotted to mate edges

# outer sides
#	outer dimensions are shrunk to provide for screw heads (if using screws)


class CrateDrawer:
	def __init__(self, obj, doc):
		obj.addProperty('App::PropertyLength', 'crateWidth', 'CrateDrawer', 'Width of a crate')
		obj.crateWidth = u('2 ft')
		obj.addProperty('App::PropertyLength', 'crateHeight', 'CrateDrawer', 'Height of a crate minus overlap')
		obj.crateHeight = u('18 in')
		obj.addProperty('App::PropertyLength', 'thickness', 'CrateDrawer', 'Material thickness')
		obj.thickness = u('0.25 in')
		obj.addProperty('App::PropertyLength', 'overlap', 'CrateDrawer', 'Stacking overlap')
		obj.overlap = u('0.5 in')
		obj.addProperty('App::PropertyLength', 'tabSpacing', 'CrateDrawer', 'Tab spacing')
		obj.tabSpacing = u('0.25 in')
		obj.addProperty('App::PropertyBool', 'screws', 'CrateDrawer', 'Whether to use screws or just glue')
		obj.screws = True
		obj.addProperty('App::PropertyDistance', 'screwSpacing', 'CrateDrawer', 'Screw spacing')
		obj.screwSpacing = u('6 in')
		obj.addProperty('App::PropertyLength', 'screwMaxLength', 'CrateDrawer', 'Maximum screw length')
		obj.screwMaxLength = u('25 mm')
		obj.addProperty('App::PropertyLength', 'screwMinLength', 'CrateDrawer', 'Minimum screw length')
		obj.screwMinLength = u('8 mm')
		obj.addProperty('App::PropertyLength', 'screwDiameter', 'CrateDrawer', 'Screw Diameter')
		obj.screwDiameter = u('6 mm')
		obj.addProperty('App::PropertyLength', 'nutDiameter', 'CrateDrawer', 'Nut Diameter')
		obj.nutDiameter = u('10 mm')
		obj.addProperty('App::PropertyLength', 'screwHeadHeight', 'CrateDrawer', 'Height of screw heads')
		obj.screwHeadHeight = u('4.4 mm')
		obj.Proxy = self

		#obj.Shape = #
		self.

	def onChanged(self, fp, prop):
		# a property has changed
		self.execute(fp)
	
	def execute(self, fp):
		# recompute

		if fp.screws:
			screwOffset = fp.screwHeadHeight
		else:
			screwOffset = 0

		th = fp.thickness
		owid = fp.crateWidth - 2 * screwOffset
		ohit = fp.crateHeight

		ops = [
			v(-owid / 2,-owid / 2, 0),
			v(-owid / 2, owid / 2, 0),
			v(-owid / 2, owid / 2, ohit),
			v(-owid / 2,-owid / 2, ohit),
			v( owid / 2,-owid / 2, 0),
			v( owid / 2, owid / 2, 0),
			v( owid / 2, owid / 2, ohit),
			v( owid / 2,-owid / 2, ohit)
		]

		left_face = Part.Face(Part.makePolygon([ops[0],ops[1],ops[2],ops[3],ops[0]]))
		right_face = Part.Face(Part.makePolygon([ops[4],ops[5],ops[6],ops[7],ops[4]]))
		back_face = Part.Face(Part.makePolygon([ops[1], ops[2], ops[6], ops[5], ops[1]]))

		left_wall = left_face.extrude(v(th,0,0))
		right_wall = right_face.extrude(v(-th,0,0))
		back_wall = back_face.extrude(v(0,th,0))
		
		
		fp.Shape = Part.Compound([left_wall, right_wall, back_wall])

	def makeJoint(self, fp, v1, v2, corner1 = False, corner2 = True, sideOne = False, screws = True):
		# screws and tabs
		# we'll produce a list of female slots along v1->v2
		
		# TODO: I've made the Tabbing etc classes before to ease connecting the sides
		#       time to use them
			
class Tabbing:
	def _init_(self, tabDistance, thickness, screwDistance=0, screwDiameter=0, screwMinLength=0, screwMaxLength=0, nutDiameter=0, nutThickness=0):
		self.tabDistance = tabDistance
		self.thickness = thickness
		self.screwDistance = screwDistance
		self.screwDiameter = screwDiameter
		self.screwMinLength = screwMinLength
		self.screwMaxLength = screwMaxLength
		self.nutDiameter = nutDiameter
		self.nutThickness = nutThickness
		self.update()

	def update(self)
		self.tabWidth = self.tabDistance / 2
		self.slotCutOverlap = self.tabWidth / 2
		self.screwTabWidth = self.tabWidth
		if self.nutDiameter and self.screwDiameter:
			if self.screwTabWidth < self.nutDiameter:
				self.screwTabWidth = self.nutDiameter
			if self.screwDiameter / 2 < self.slotCutOverlap:
				self.slotCutOverlap = self.screwDiameter / 2

class TabbedCorner
	def _init_(self, v):
		self.v = v
		self.filled = False

class TabbedEdge:
	def _init_(self, tabbing, c1, c2, cutDirection, cutFlag):
		self.c1 = c1
		self.c2 = c2
		self.dist = (c2 - c1).Length
		self.unitv = (c2 - c1) / dist
		self.tabbing = tabbing
		self.cutDirection = cutDirection / cutDirection.Length
		self.cutFlag = cutFlag
		self.cutNormal = self.unitv.cross(self.cutDirection)
		self.screwCount = math.ceil(self.dist / self.tabbing.screwDistance) + 1
		if not c1.filled and cutFlag:
			c1.filled = True
			c1.filler = self
		elif not c2.filled and not cutFlag:
			c2.filled = True
			c2.filler = self
		if self.screwCount % 2 != 0:
			++ self.screwCount
		screwOffset = self.tabbing.screwTabWidth / 2 + self.tabbing.thickness
		screwDelta = (self.dist - screwOffset * 2) / (self.screwCount - 1)
		self.screwPositions = [idx * screwDelta + screwOffset for idx in xrange(self.screwCount)]
	
	def calculate(self):
		pos = 0
		self.cuts = []

		self.tabbing.update()

		screwIdx = 0
		tabnext = self.cutFlag

		# fill for corner 1
		if self.c1.filler != self:
			slotpos = -self.tabbing.slotCutOverlap
			slotlen = self.tabbing.thickness + self.tabbing.slotCutOverlap
			if not tabnext:
				slotlen += self.tabbing.slotCutOverlap
			self.addslot(slotpos, slotlen)

		while pos < self.dist - self.tabbing.thickness:
			possibleScrewPos = pos + self.tabbing.screwTabWidth / 2
			nextScrewPos = pos + self.tabbing.tabWidth + self.tabbing.screwTabWidth / 2
			goalScrewPos = self.screwPositions[screwIdx]
			if abs(goalScrewPos - possibleScrewPos) < abs(goalScrewPos - nextScrewPos):
				# place a screw
				if tabnext:
				 	self.addscrewtab(goalScrewPos)
				 	pos = goalScrewPos + self.tabbing.screwTabWidth / 2
				else:
					startpos = pos
					slotlen = goalScrewPos + self.tabbing.screwTabWidth / 2 - startpos
				 	self.addscrewslot(startpos, goalScrewPos, slotlen)
				 	pos = startpos + slotlen
				screwIdx = screwIdx + 1
				if screwIdx == len(self.screwPositions):
					tabnext = not tabnext
					break
			else:
				# place a tab
				if not tabnext:
					self.addslot(pos, self.tabbing.tabWidth)
				pos += self.tabbing.tabWidth
			tabnext = not tabnext

		# fill for corner 2
		if self.c2.filler != self:
			slotpos = self.dist - self.tabbing.thickness
			slotlen = self.tabbing.thickness + self.tabbing.slotCutOverlap
			if tabnext:
				slotlen += self.tabbing.slotCutOverlap
				slotpos -= self.tabbing.slotCutOverlap
			self.addslot(slotpos, slotlen)

		return reduce(lambda x, y: x.fuse(y), self.cuts)
		
	def addcut(self, startPos, length, left, right):
		raw_coords = [v(left, 0, 0), v(right, 0, 0), v(right, length, 0), v(left, length, 0), v(left, 0, 0)]
		coords = [self.c1.v + coord.x * self.cutDirection + coord.y * self.unitv - self.tabbing.thickness * 2 * self.cutNormal for coord in raw_coords]
		front = Part.Face(Part.makePolygon(coords))
		cut_bottom = Part.makePlane(self.tabbing.thickness * 2, self.tabbing.thickness * 2, startPos * self.unitv + self.c1.v, self.cutDirection)
		cut = front.extrude(self.tabbing.thickness * 3 * self.cutNormal)
		self.cuts.append(cut)
		return cut

	def addslot(self, startPos, length):
		self.addcut(startPos, length, -self.tabbing.thickness, self.tabbing.thickness)

	def addscrewtab(self, screwPos):
		if self.tabbing.screwDiameter:
			self.addcut(screwPos - self.tabbing.screwDiameter / 2, self.tabbing.screwDiameter, -self.tabbing.thickness, self.tabbing.thickness)

	def addscrewslot(self, startPos, screwPos, length):
		# other side to tab into
		self.addcut(startPos, length, -self.tabbing.thickness, self.tabbing.thickness)
		if self.tabbing.screwDiameter:
			# screw body
			self.addcut(screwPos - self.tabbing.screwDiameter / 2, self.tabbing.screwDiameter, 0, self.tabbing.screwMaxLength)
			# nut body
			self.addcut(screwPos - self.tabbing.nutDiameter / 2, self.tabbing.nutDiameter, self.tabbing.screwMinLength - self.tabbing.nutThickness, self.tabbing.screwMinLength)

def makeCrate():
		if not FreeCAD.ActiveDocument:
			FreeCAD.newDocument()
		c = FreeCAD.ActiveDocument.addObject('Part::FeaturePython', 'CrateDrawer')
		CrateDrawer(c, FreeCAD.ActiveDocument)
		c.ViewObject.Proxy = 0
		FreeCAD.ActiveDocument.recompute()
