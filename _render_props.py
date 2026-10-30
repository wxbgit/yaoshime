import os, re, sys

ROOT = r'C:\yaoshime'
params = {
    'BOOST_ROOT': r'C:\yaoshime\deps\boost-1.86.0',
    'PLATFORM_TOOLSET': 'v145',
    'VERSION_MAJOR': '0',
    'VERSION_MINOR': '17',
    'VERSION_PATCH': '4',
    'PRODUCT_VERSION': '0.17.4.1',
    'FILE_VERSION': '0.17.4.1',
}

src = os.path.join(ROOT, 'weasel.props.template')
dst = os.path.join(ROOT, 'weasel.props')

with open(src, 'r', encoding='utf-8-sig') as f:
    text = f.read()

for k, v in params.items():
    text = text.replace('$' + k, v)

with open(dst, 'w', encoding='utf-8') as f:
    f.write(text)

print('written', dst)
for k, v in params.items():
    print(' ', k, '=', v)
