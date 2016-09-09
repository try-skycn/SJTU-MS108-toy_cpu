import sys
from ModuleConfig import TopConfig

settings = sys.modules[__name__]
settings.DIR = '../'

_, config_file, main_dir = sys.argv

TopConfig(config_file=config_file, file_dir=main_dir + '/')