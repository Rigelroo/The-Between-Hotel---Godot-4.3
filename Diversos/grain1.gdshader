shader_type canvas_item;

uniform vec2 screen_size;
uniform bool enabled = false;

const float grain_amount = 0.05; //grain amount
const bool colored = false; //colored noise?
const float color_amount = 0.6;
const float grain_size = 1.6; //grain particle size (1.5 - 2.5)
const float lum_amount = 1.0;

//a random texture generator, but you can also use a pre-computed perturbation texture
vec4 rnm(vec2 tc)
{
  float noise =  sin(dot(tc + vec2(TIME,TIME),vec2(12.9898,78.233))) * 43758.5453;
	float noiseR =  fract(noise)*2.0-1.0;
    float noiseG =  fract(noise*1.2154)*2.0-1.0;
    float noiseB =  fract(noise*1.3453)*2.0-1.0;
    float noiseA =  fract(noise*1.3647)*2.0-1.0;
    return vec4(noiseR,noiseG,noiseB,noiseA);
}

float fade(float t) {
    return t*t*t*(t*(t*6.0-15.0)+10.0);
}

float pnoise3D(vec3 p)
{
    vec3 pi = 0.00390625*floor(p);
    pi = vec3(pi.x+0.001953125, pi.y+0.001953125, pi.z+0.001953125);
    vec3 pf = fract(p);     // Fractional part for interpolation

    // Noise contributions from (x=0, y=0), z=0 and z=1
    float perm00 = rnm(pi.xy).a ;
    vec3 grad000 = rnm(vec2(perm00, pi.z)).rgb * 4.0;
    grad000 = vec3(grad000.x - 1.0, grad000.y - 1.0, grad000.z - 1.0);
    float n000 = dot(grad000, pf);
    vec3 grad001 = rnm(vec2(perm00, pi.z + 0.00390625)).rgb * 4.0;
    grad001 = vec3(grad001.x - 1.0, grad001.y - 1.0, grad001.z - 1.0);
    float n001 = dot(grad001, pf - vec3(0.0, 0.0, 1.0));

    // Noise contributions from (x=0, y=1), z=0 and z=1
    float perm01 = rnm(pi.xy + vec2(0.0, 0.00390625)).a ;
    vec3 grad010 = rnm(vec2(perm01, pi.z)).rgb * 4.0;
    grad010 = vec3(grad010.x - 1.0, grad010.y - 1.0, grad010.z - 1.0);
    float n010 = dot(grad010, pf - vec3(0.0, 1.0, 0.0));
    vec3 grad011 = rnm(vec2(perm01, pi.z + 0.00390625)).rgb * 4.0;
    grad011 = vec3(grad011.x - 1.0, grad011.y - 1.0, grad011.z - 1.0);
    float n011 = dot(grad011, pf - vec3(0.0, 1.0, 1.0));

    // Noise contributions from (x=1, y=0), z=0 and z=1
    float perm10 = rnm(pi.xy + vec2(0.00390625, 0.0)).a ;
    vec3  grad100 = rnm(vec2(perm10, pi.z)).rgb * 4.0;
    grad100 = vec3(grad100.x - 1.0, grad100.y - 1.0, grad100.z - 1.0);
    float n100 = dot(grad100, pf - vec3(1.0, 0.0, 0.0));
    vec3  grad101 = rnm(vec2(perm10, pi.z + 0.00390625)).rgb * 4.0;
    grad101 = vec3(grad101.x - 1.0, grad101.y - 1.0, grad101.z - 1.0);
    float n101 = dot(grad101, pf - vec3(1.0, 0.0, 1.0));

    // Noise contributions from (x=1, y=1), z=0 and z=1
    float perm11 = rnm(pi.xy + vec2(0.00390625, 0.00390625)).a ;
    vec3  grad110 = rnm(vec2(perm11, pi.z)).rgb * 4.0;
    grad110 = vec3(grad110.x - 1.0, grad110.y - 1.0, grad110.z - 1.0);
    float n110 = dot(grad110, pf - vec3(1.0, 1.0, 0.0));
    vec3  grad111 = rnm(vec2(perm11, pi.z + 0.00390625)).rgb * 4.0;
    grad111 = vec3(grad111.x - 1.0, grad111.y - 1.0, grad111.z - 1.0);
    float n111 = dot(grad111, pf - vec3(1.0, 1.0, 1.0));

    // Blend contributions along x
    vec4 n_x = mix(vec4(n000, n001, n010, n011), vec4(n100, n101, n110, n111), fade(pf.x));

    // Blend contributions along y
    vec2 n_xy = mix(n_x.xy, n_x.zw, fade(pf.y));

    // Blend contributions along z
    float n_xyz = mix(n_xy.x, n_xy.y, fade(pf.z));

    // We're done, return the final noise value.
    return n_xyz;
}

//2d coordinate orientation thing
vec2 coordRot(vec2 tc, float angle)
{
    float aspect = screen_size.x/screen_size.y;
    float rotX = ((tc.x*2.0-1.0)*aspect*cos(angle)) - ((tc.y*2.0-1.0)*sin(angle));
    float rotY = ((tc.y*2.0-1.0)*cos(angle)) + ((tc.x*2.0-1.0)*aspect*sin(angle));
    rotX = ((rotX/aspect)*0.5+0.5);
    rotY = rotY*0.5+0.5;
    return vec2(rotX,rotY);
}

if const(enabled)
{
    vec3 rotOffset = vec3(1.425,3.892,5.835); //rotation offset values
    vec2 rotCoordsR = coordRot(UV, TIME + rotOffset.x);
    vec3 noise = vec3(pnoise3D(vec3(rotCoordsR*vec2(screen_size.x/grain_size,screen_size.y/grain_size),0.0)));

    if (colored)
    {
	    vec2 rotCoordsG = coordRot(UV, TIME + rotOffset.y);
	    vec2 rotCoordsB = coordRot(UV, TIME + rotOffset.z);
	    noise.g = mix(noise.r,pnoise3D(vec3(rotCoordsG*vec2(screen_size.x/grain_size,screen_size.y/grain_size),1.0)),color_amount);
	    noise.b = mix(noise.r,pnoise3D(vec3(rotCoordsB*vec2(screen_size.x/grain_size,screen_size.y/grain_size),2.0)),color_amount);
    }

    vec3 col = tex(TEXTURE, UV).rgb;
    vec3 lumcoeff = vec3(0.299,0.587,0.114);
    float luminance = mix(0.0,dot(col, lumcoeff),lum_amount);
    float lum = smoothstep(0.2,0.0,luminance);
    lum += luminance;

    noise = mix(noise,vec3(0.0),pow(lum,4.0));
    col = col+noise*grain_amount;

    COLOR = vec4(col,1.0) * SRC_COLOR;
} else {
    COLOR = tex(TEXTURE, UV) * SRC_COLOR;
}