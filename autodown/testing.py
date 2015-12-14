# -*- coding: utf-8 -*-
# file: example1.py
import string

# 这个是 str 的字符串
s = '关关雎鸠'

# 这个是 unicode 的字符串
u = u'关关雎鸠'

print isinstance(s, str)      # True
print isinstance(u, unicode)  # True

print s.__class__   # <type 'str'>
print u.__class__   # <type 'unicode'>
# 从 str 转换成 unicode
print s.decode('utf-8')   # 关关雎鸠

# 从 unicode 转换成 str
print u.encode('utf-8')   # 关关雎鸠
print s
print u
s
