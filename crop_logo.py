from PIL import Image
import numpy as np
import os

logo_path = os.path.join(os.path.dirname(__file__), 'docs', 'prestilon.logo.png')

img = Image.open(logo_path).convert('RGBA')
data = np.array(img)

r, g, b, a = data[:,:,0], data[:,:,1], data[:,:,2], data[:,:,3]

is_white = (r > 245) & (g > 245) & (b > 245)
is_transparent = a < 15
is_content = ~is_white & ~is_transparent

rows = np.any(is_content, axis=1)
cols = np.any(is_content, axis=0)

rmin, rmax = np.where(rows)[0][[0, -1]]
cmin, cmax = np.where(cols)[0][[0, -1]]

pad = 20
rmin = max(0, rmin - pad)
rmax = min(img.height, rmax + pad)
cmin = max(0, cmin - pad)
cmax = min(img.width, cmax + pad)

cropped = img.crop((cmin, rmin, cmax, rmax))
cropped.save(logo_path, 'PNG')
print(f"Logo apgriezts un saglabats! Jaunais izmers: {cropped.size}")
input("Nospied Enter lai aizveru...")
