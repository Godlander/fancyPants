#version 150

#moj_import <minecraft:light.glsl>
#moj_import <minecraft:fog.glsl>

in vec3 Position;
in vec4 Color;
in vec2 UV0;
in ivec2 UV1;
in ivec2 UV2;
in vec3 Normal;

uniform sampler2D Sampler0;
uniform sampler2D Sampler2;

uniform mat4 ModelViewMat;
uniform mat4 ProjMat;
uniform mat4 TextureMat;
uniform int FogShape;

uniform vec3 Light0_Direction;
uniform vec3 Light1_Direction;

out float vertexDistance;
out vec4 vertexColor;
out vec4 tintColor;
out vec4 lightColor;
out vec4 overlayColor;
out vec2 uv;

int toint(vec3 c) {
    ivec3 v = ivec3(c*255);
    return (v.r<<16)+(v.g<<8)+v.b;
}

void main() {
    gl_Position = ProjMat * ModelViewMat * vec4(Position, 1.0);

    vertexDistance = fog_distance(Position, FogShape);
    tintColor = Color;
    vertexColor = minecraft_mix_light(Light0_Direction, Light1_Direction, Normal, vec4(1));
    lightColor = texelFetch(Sampler2, UV2 / 16, 0);
    uv = UV0;

    //number of armors from texture size
    vec2 size = textureSize(Sampler0, 0);
    int n = int(2*size.y/size.x);
    //if theres more than 1 custom armor
    if (n > 1 && size.x < 256) {
        //divide uv by number of armors, it is now on the first armor
        uv.y /= n;
        //if color index is within number of armors
        int i = toint(Color.rgb);
        if (i < n) {
            //move uv down to index
            uv.y += i*size.x/size.y/2.;
            //remove tint color
            tintColor = vec4(1);
        }
    }
}
