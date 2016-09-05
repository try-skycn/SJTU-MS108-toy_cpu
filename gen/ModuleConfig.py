import re
import sys

pattern = re.compile(
	r'[\t ]*(input|output)[\t ]*(wire|reg)[\t ]*((?:\[[`\w\-\+\*\/ :]+\])?)[\t ]*([\w]+),?[\t ]*(?://[\t ]*(.*))?'
)
module_match = re.compile(
	r'[\t ]*compile[\t ]+module[\t ]+(\w+)'
)


def _parse_assign(note):
	head, *expr = re.split('[\t ]+', note)
	return head, expr


def _parse_line(line):
	lst = pattern.match(line)

	if lst is None:
		return None
	else:
		return lst.groups()


def real_len(s):
	result = 0
	for ch in s:
		if ch == '\t':
			result += 4 - result % 4
		else:
			result += 1
	return result


def print_lists(data, tab_widths, starts, ends):
	for entry in data:
		print(
			''.join(
				[
					start + entity + end + '\t' * (tab_width - real_len(entity + end) // 4)
					for tab_width, entity, start, end in zip(tab_widths, entry, starts, ends)
				]
			)
		)


def general_widths(data, ends):
	result = [0] * len(data[0])
	for entry in data:
		result = [max(val, (real_len(entity + end) + 3) // 4) for val, entity, end in zip(result, entry, ends)]
	result[-1] = 0
	return result


class ModuleConfig(object):
	def __init__(self, module_name, file_dir='./'):
		self.module_name = module_name
		self.dir = file_dir
		self.io_config = []
		self.wire_list = []
		self.wire_map = {}
		self.assign_list = []

		self._parse_file()
		self._compile()

	def _parse_file(self):
		with open(self.dir + self.module_name + '.v', 'r') as f:
			for line in f:
				line_info = _parse_line(line)
				if line_info is not None:
					self.io_config.append(line_info)

	def _compile(self):
		for io_type, data_type, data_bus, name, note in self.io_config:
			if io_type == 'input':
				head, expr = '', []
				if note is not None:
					head, expr = _parse_assign(note)
				self.assign_list.append((io_type, name, expr))
			elif io_type == 'output':
				head, top_level_name = '=', self.module_name + '__' + name
				if note is not None:
					head, expr = _parse_assign(note)
					top_level_name, = expr
				self.assign_list.append((io_type, name, top_level_name))
				if head == '=':
					self.wire_list.append((data_bus, top_level_name, name))
		for data_bus, top_level_name, name in self.wire_list:
			self.wire_map[name] = top_level_name

	def get(self, output_wire):
		try:
			return self.wire_map[output_wire]
		except KeyError:
			print(
				'module %s have no output wire named %s (or it has just been assigned to some top level output).' %
				(self.module_name, output_wire),
				file=sys.stderr
			)
			exit(0)

	def print(self, module_map, indent='\t'):
		lines = []
		for io_type, name, expr in self.assign_list:
			line = indent + '\t.' + name + '('
			if io_type == 'input':
				assign_list = []
				for item in expr:
					if item.find('::') != -1:
						module_name, data_name = item.split('::')
						assign_list.append(module_map[module_name].get(data_name))
					else:
						assign_list.append(item)
				line += ' '.join(assign_list)
			elif io_type == 'output':
				line += expr
			line += ')'
			lines.append(line)
		print(indent + self.module_name + ' inst__' + self.module_name + '(')
		print(',\n'.join(lines))
		print(indent + ');')


class TopConfig(object):
	def __init__(self, config_file, file_dir='./'):
		self.module_list = None
		self.module_map = {}
		self.config_file = config_file
		self.file_dir = file_dir

		self._compile()

	def _compile(self):
		FLAG = False
		with open(self.config_file, 'r') as f:
			for line in f:
				line = line.strip('\n')
				if FLAG:
					if line == '*/':
						FLAG = False
						self.print_modules()
						self.module_list = None
					else:
						match_result = module_match.match(line)
						if match_result is not None:
							module_name = match_result.group(1)
							self.module_list.append(module_name)
							self.module_map[module_name] = ModuleConfig(module_name, file_dir=self.file_dir)
				else:
					if line == '/*':
						FLAG = True
						self.module_list = []
					else:
						print(line)

	def print_modules(self, indent='\t'):
		wire_starts = [indent + 'wire', '', '// ']
		wire_ends = ['\t', ';\t', '']

		wire_list = []
		for module_config in self.module_map.values():
			wire_list += module_config.wire_list
		tab_widths = general_widths(wire_list, wire_ends)
		for module_name in self.module_list:
			module_config = self.module_map[module_name]
			print('\t// ' + module_name)
			print_lists(
				data=module_config.wire_list,
				tab_widths=tab_widths,
				starts=wire_starts,
				ends=wire_ends
			)
			print()

		for module_name in self.module_list:
			module_config = self.module_map[module_name]
			module_config.print(self.module_map, indent=indent)
			print()
