// https://www.shadertoy.com/view/XlSSRW

// Pass RGB color to HSV then posterize the Saturation and Value components before repass modified HSV to RGB colors.
// Posterize directly RGB(right image) values gives a bad result with color banding particulary with low colors values

// iChannel0: Source, filter=nearest, wrap=clamp
// BBox: iChannel0

uniform int nColors = 4; // Colors (Number of colors to use), min=2, max=256
uniform bool hsv = true; // Work in HSV (Work in HSV space rather than RGB)

vec3 lerp(vec3 colorone, vec3 colortwo, float value)
{
	return (colorone + value*(colortwo-colorone));
} 

vec3 RGBToHSV( vec3 RGB ){
    
    vec4 k = vec4(0.0, -1.0/3.0, 2.0/3.0, -1.0);
    vec4 p = RGB.g < RGB.b ? vec4(RGB.b, RGB.g, k.w, k.z) : vec4(RGB.gb, k.xy);
    vec4 q = RGB.r < p.x   ? vec4(p.x, p.y, p.w, RGB.r) : vec4(RGB.r, p.yzx);
    float d = q.x - min(q.w, q.y);
    float e = 1.0e-10;
    return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
}

vec3 HSVToRGB( vec3 HSV ){
    
    vec4 k = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 p = abs(fract(HSV.xxx + k.xyz) * 6.0 - k.www);
    return HSV.z * lerp(k.xxx, clamp(p - k.xxx, 0.0, 1.0), HSV.y);
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{ 
    float vx_offset = 0.5;
	vec2 uv = fragCoord.xy / iResolution.xy;
   	vec3 tc = texture2D(iChannel0, uv).rgb;
    
    float cutColor = 1./float(nColors);
    
    if(hsv)
    {
         
   	 	tc = RGBToHSV(tc);

    	vec2 target_c = cutColor*floor(tc.gb/cutColor+0.5);
    
    	tc = HSVToRGB(vec3(tc.r,target_c));
    }
    else
    {


        tc  = cutColor*floor(tc/cutColor+0.5);
    }
    
    fragColor = vec4(tc, 1.0);
   
}
