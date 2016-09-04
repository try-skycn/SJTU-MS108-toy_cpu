import sys
settings = sys.modules[__name__]
settings.DIR = '../'

def modulelist():
	with open("config.txt", "r") as f:
		for line in f:
			content = line.strip('\n')
			if content != '':
				yield content

def getdata(modulename):
	with open(settings.DIR + modulename + ".v", "r") as f:
		for line in f:
			content = line.strip('\t\n')
			if content.find(');') == 0:
				break
			elif content.find('input') == 0 or content.find('output') == 0:
				lst = [x for x in content.split('\t') if x != '']
				iotype = lst[0]
				vartype = ''.join(['wire'] + lst[2:-1])
				name = lst[-1].strip(',')
				yield iotype, vartype, name

def main():
	modinfo = {}
	for mod in modulelist():
		modinfo[mod] = [port for port in getdata(mod)]

	maxlen = 0
	for mod in modulelist():
		for iotype, vartype, name in modinfo[mod]:
			if iotype == 'output':
				if len(vartype) > maxlen:
					maxlen = len(vartype)

	maxtab = maxlen // 4 + 1
	for mod in modulelist():
		print('\t// ' + mod)
		for iotype, vartype, name in modinfo[mod]:
			if iotype == 'output':
				print('\t' + vartype + '\t' * (maxtab - len(vartype) // 4) + mod + '__' + name)
		print()

	for mod in modulelist():
		print('\t' + mod + ' inst_' + mod + '(')
		prtlist = []
		for iotype, vartype, name in modinfo[mod]:
			if name == 'clk' or name == 'rst':
				prtlist.append((name, name))
			elif iotype == 'output':
				prtlist.append((name, mod + '__' + name))
			else:
				prtlist.append((name, ''))
		prtlist = ['\t\t.' + n + '(' + p + ')' for n, p in prtlist]
		print(',\n'.join(prtlist))
		print('\t);')
		print()

if __name__ == '__main__':
	main()
