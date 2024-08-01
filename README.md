# pants, but less fancy

[fancypants](https://github.com/Ancientkingg/fancyPants) is kinda really inefficent and unoptimized

less fancy pants is many many times faster and also easier to use

the only thing it doesnt have is automatically animating armor, but you can still animate by just changing the color

## usage:

just stack the armor texture downwards

the integer display color determines which texture to use, starting from 0

for example, to equip the second custom chestplate:

`/item replace entity @s armor.chest with minecraft:leather_chestplate[dyed_color=1]`

*colors beyond total number of armor textures will default to use the first texture, but with tint color applied*

when the glowing effect is applied, the first custom armor texture is what glowing outline will show

## performance:

texture reading is a fairly expensive operation in shaders

original fancypants does all the calculation in the fragment shader for some reason, which means everything is calculated for every single pixel of armor on the screen

it also uses a `for` loop that reads the texture `O(N)` times where `N` is the amount of custom armors

the compiler will usually optimize loops if they run a predictable number of times, but since this loop's run time is dependent on the result of the texture read, that will not be possible

in comparison, less fancy pants does not read the texture color at all for the calculations

the calculations are all done in the vertex shader, which runs once per geometry vertex instead of per pixel on screen

there are also no loops, the shader program runs in constant time with respect to the amount of custom armors
