# ------------------------------------------------------
#
# transtr.py
#
# Converts android string attributes (in xml)
# in the Localizable.strings
# into format supported by SchoolPower iOS
#
# Useage: python3 transtr.py
#
# Created by carbonyl on Sun Jul 22 15:13:23 CST 2018
# Last change: Sun Jul 22 15:13:23 CST 2018
#
# ------------------------------------------------------

import sys
import os

script_dir = os.path.dirname(__file__)
en_path = "en.lproj/Localizable.strings"
hans_path = "zh-Hans.lproj/Localizable.strings"
hant_path = "zh-Hant.lproj/Localizable.strings"
en_file_path = os.path.join(script_dir, en_path)
hans_file_path = os.path.join(script_dir, hans_path)
hant_file_path = os.path.join(script_dir, hant_path)

with open(en_file_path, 'U') as f:
    newText=f.read()
    while '<string name=' in newText:
        newText=newText.replace('<string name=', '')
    while '</string>' in newText:
        newText=newText.replace('</string>', '\";')
    while '>' in newText:
        newText=newText.replace('>', ' = \"')
with open(en_file_path, "w") as f:
    f.write(newText)

with open(hans_file_path, 'U') as f:
    newText=f.read()
    while '<string name=' in newText:
        newText=newText.replace('<string name=', '')
    while '</string>' in newText:
        newText=newText.replace('</string>', '\";')
    while '>' in newText:
        newText=newText.replace('>', ' = \"')
with open(hans_file_path, "w") as f:
    f.write(newText)

with open(hant_file_path, 'U') as f:
    newText=f.read()
    while '<string name=' in newText:
        newText=newText.replace('<string name=', '')
    while '</string>' in newText:
        newText=newText.replace('</string>', '\";')
    while '>' in newText:
        newText=newText.replace('>', ' = \"')
with open(hant_file_path, "w") as f:
    f.write(newText)
