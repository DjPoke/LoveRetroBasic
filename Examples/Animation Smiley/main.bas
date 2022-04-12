img=0

spriteon 0
hotspot 0,4
spritescale 0,3
spritepos 0,160,100

loop:

spriteimg 0,img

img=img+1
img=mod(img,4)

goto loop
