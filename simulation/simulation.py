import os, sys, argparse
import re

MAX = 0xffffffff

labelpattern = re.compile(r'([\_\d\w]+):')
rpattern = re.compile(r'[\t ]*(\w+)[\t ]+\$(\d+)[\t ]*,[\t ]*\$(\d+)[\t ]*,[\t ]*\$(\d+)')
ipattern = re.compile(r'[\t ]*(\w+)[\t ]+\$(\d+)[\t ]*,[\t ]*\$(\d+)[\t ]*,[\t ]*([x\da-f\-]+)')
jpattern = re.compile(r'[\t ]*(\w+)[\t ]+([\_\d\w]+)')
b2pattern = re.compile(r'[\t ]*(\w+)[\t ]+\$(\d+)[\t ]*,[\t ]*\$(\d+)[\t ]*,[\t ]*([\_\d\w]+)')
b1pattern = re.compile(r'[\t ]*(\w+)[\t ]+\$(\d+)[\t ]*,[\t ]*([\_\d\w]+)')
multpattern = re.compile(r'[\t ]*(\w+)[\t ]+\$(\d+)[\t ]*,[\t ]*\$(\d+)')
hilopattern = re.compile(r'[\t ]*(\w+)[\t ]+\$(\d+)')
rampattern = re.compile(r'[\t ]*(\w+)[\t ]+\$(\d+)[\t ]*,[\t ]*([x\da-f]+)\(\$(\d+)\)')
hexpattern = re.compile('0x[\da-f]+')


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
	match = jpattern.match(s)
	if match is not None:
		command, label = match.groups()
		return command, label
	match = rampattern.match(s)
	if match is not None:
		command, dest, imm, center = match.groups()
		return command, int(dest), _toint(imm), int(center)
	match = b2pattern.match(s)
	if match is not None:
		command, srcleft, srcright, label = match.groups()
		return command, int(srcleft), int(srcright), label
	match = b1pattern.match(s)
	if match is not None:
		command, src, label = match.groups()
		return command, int(src), label
	match = multpattern.match(s)
	if match is not None:
		command, srcleft, srcright = match.groups()
		return command, int(srcleft), int(srcright)
	match = hilopattern.match(s)
	if match is not None:
		command, dest = match.groups()
		return command, int(dest)


class Simulation(object):
	def __init__(self):
		self.output = []
		self.registers = [0] * 32
		self.ram = [0] * 1024
		self.hi = 0
		self.lo = 0

	def _reg(self, dest, val):
		self.registers[dest] = val
		self.output += ['reg	%d	0x%x' % (dest, val)]

	def _mem(self, dest, val):
		self.ram[dest] = val
		self.output += ['mem	0x%x	0x%x' % (dest, val)]

	def _hi(self, val):
		self.hi = val
		self.output += ['hilo	0x%x	0' % val]

	def _lo(self, val):
		self.lo = val
		self.output += ['hilo	0	0x%x' % val]

	def _hilo(self, valhi, vallo):
		self.hi = valhi
		self.lo = vallo
		self.output += ['hilo	0x%x	0x%x' % (valhi, vallo)]

	def _pause(self):
		self.output += ['pause']

	def exe(self, inst):
		command, *lst = inst
		if command == 'ori':
			dest, srcleft, srcright = lst
			self._reg(dest, self.registers[srcleft] | srcright)
		elif command == 'andi':
			dest, srcleft, srcright = lst
			self._reg(dest, self.registers[srcleft] & srcright)
		elif command == 'addi':
			dest, srcleft, srcright = lst
			self._reg(dest, self.registers[srcleft] + srcright)
		elif command == 'add':
			dest, srcleft, srcright = lst
			self._reg(dest, self.registers[srcleft] + self.registers[srcright])
		elif command == 'sub':
			dest, srcleft, srcright = lst
			self._reg(dest, self.registers[srcleft] - self.registers[srcright])
		elif command == 'or':
			dest, srcleft, srcright = lst
			self._reg(dest, self.registers[srcleft] | self.registers[srcright])
		elif command == 'and':
			dest, srcleft, srcright = lst
			self._reg(dest, self.registers[srcleft] & self.registers[srcright])
		elif command == 'mult':
			srcleft, srcright = lst
			result = self.registers[srcleft] * self.registers[srcright]
			self._hilo((result & MAX) >> 32, result & MAX)
		elif command == 'mfhi':
			dest, = lst
			self._reg(dest, self.hi)
		elif command == 'mflo':
			dest, = lst
			self._reg(dest, self.lo)
		elif command == 'mthi':
			src, = lst
			self._hi(self.registers[src])
		elif command == 'mtlo':
			src, = lst
			self._lo(self.registers[src])
		elif command == 'j':
			label, = lst
			self._pause()
			self._pause()
			return label
		elif command == 'bne':
			srcleft, srcright, label = lst
			self._pause()
			if self.registers[srcleft] != self.registers[srcright]:
				self._pause()
				return label
		elif command == 'beq':
			srcleft, srcright, label = lst
			self._pause()
			if self.registers[srcleft] == self.registers[srcright]:
				self._pause()
				return label
		elif command == 'sb':
			src, imm, center = lst
			self._mem(self.registers[center] + imm, self.registers[src] & 0xff)
		elif command == 'sh':
			src, imm, center = lst
			self._mem(self.registers[center] + imm, self.registers[src] & 0xffff)
		elif command == 'sw':
			src, imm, center = lst
			self._mem(self.registers[center] + imm, self.registers[src] & 0xffffffff)
		elif command == 'lw':
			dest, imm, center = lst
			self._reg(dest, self.ram[self.registers[center] + imm])

	def printoutput(self):
		for entity in self.output:
			print(entity)


class Assambler(object):
	def __init__(self, filename):
		self.instRom = []
		self.labelmap = {}
		self._read(filename)

	def _read(self, filename):
		with open(filename, "r") as f:
			for line in f:
				line = line.strip('\n')
				match = labelpattern.match(line)
				if match is not None:
					self.labelmap[match.group(1)] = len(self.instRom)
				else:
					self.instRom += [_type(line)]

	def exe(self, cycle):
		sim = Simulation()
		pc = 0
		for _ in range(cycle):
			print("%x" % (pc * 4))
			if pc == len(self.instRom):
				break;
			result = sim.exe(self.instRom[pc])
			if result is not None:
				pc = self.labelmap[result]
			else:
				pc += 1
		return sim


def main():
	parser = argparse.ArgumentParser()
	parser.add_argument("-f", dest = "f", default = "rom.s", type = str)
	parser.add_argument("-c", dest = "c", default = 30, type = int)
	args = parser.parse_args()

	ass = Assambler(args.f)
	ass.exe(args.c).printoutput()

if __name__ == '__main__':
	main()
