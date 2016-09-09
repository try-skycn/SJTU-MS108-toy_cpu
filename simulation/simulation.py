import re

rpattern = re.compile(r'[\t ]*(\w+)[\t ]+\$(\d+)[\t ]*,[\t ]*\$(\d+)[\t ]*,[\t ]*\$(\d+)')
ipattern = re.compile(r'[\t ]*(\w+)[\t ]+\$(\d+)[\t ]*,[\t ]*\$(\d+)[\t ]*,[\t ]*([\dx]+)')
hexpattern = re.compile('0x\d+')


def _toint(s):
	if hexpattern.match(s) is not None:
		return int(s, base=16)
	else:
		return int(s)


def _type(s):
	match = rpattern.match(s)
	if match is not None:
		command, dest, srcleft, srcright = match.groups()
		return command, int(dest), int(srcleft), int(srcright)
	match = ipattern.match(s)
	if match is not None:
		command, dest, srcleft, srcright = match.groups()
		return command, int(dest), int(srcleft), _toint(srcright)


class Simulation(object):
	def __init__(self):
		self.output = []
		self.registers = [0] * 32
		self.ram = [0] * 1024


	def _reg(self, dest, val):
		self.registers[dest] = val
		output += [('reg', dest, val)]

	def _mem(self, dest, val):
		self.ram[dest] = val
		output += [('ram', dest, val)]

	def exe(self, s):
		command, *lst = _type(s)
		if command == 'ori':
			dest, srcleft, srcright = lst;
			self._reg(dest, srcleft, srcright)
