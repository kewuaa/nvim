project(
  'pyutils',
  'cpp',
  default_options: ['cpp_std=c++17']
)

nanobind_dep = dependency('nanobind', required: true)
python = import('python', required: true)
py = python.find_installation()
if host_machine.system() == 'windows'
  py.extension_module(
    'imtoggle',
    sources: [
      'rplugin/python3/utils/imtoggle_wrap.cpp',
      'rplugin/python3/utils/imtoggle/imtoggle.cpp'
    ],
    link_args: ['-limm32'],
    dependencies: [nanobind_dep],
    install: true,
    install_dir: 'utils',
  )
endif
