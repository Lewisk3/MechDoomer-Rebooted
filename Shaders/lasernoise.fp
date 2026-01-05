
//
// Description : Shader to simulate laser noise caused by lightwave interference.
//     Authors : Pietro De Nicola, Lewisk3
//     License Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License
// 
// Sources for shader developement:
// 		- https://thebookofshaders.com/13/ (Research on noise and fbm functions)
//		- https://www.shadertoy.com/view/lsjGWD (Origin for hash function, noise, fbm)

uniform float timer;

float hash(vec2 p)
{
    p = vec2(
        dot(p, vec2(127.1, 311.7)),
        dot(p, vec2(269.5, 183.3))
    );
    return fract(sin(p.x + p.y) * 43758.5453);
}

float noise(vec2 p)
{
    vec2 i = floor(p);
    vec2 f = fract(p);
    vec2 u = f * f * (3.0 - 2.0 * f);

    float a = hash(i + vec2(0.0, 0.0));
    float b = hash(i + vec2(1.0, 0.0));
    float c = hash(i + vec2(0.0, 1.0));
    float d = hash(i + vec2(1.0, 1.0));

    return mix(mix(a, b, u.x), mix(c, d, u.x), u.y);
}

float fbm(vec2 p)
{
    float value = 0.0;
    float amplitude = 0.5;
    mat2 rot = mat2(0.87, -0.5, 0.5, 0.87);

    for (int i = 0; i < 4; ++i)
    {
        value += noise(p) * amplitude;
        p = rot * p * 2.0;
        amplitude *= 0.5;
    }
    return value;
}

vec4 Process(vec4 color)
{
    vec2 fragCoord = gl_TexCoord[0].xy;
    vec4 fragColor = getTexel(fragCoord);

    vec2 uv = fragCoord;
    uv.x *= 0.5;
    uv.y *= 0.1;
    uv.x += timer;
    uv.y += sin(timer * 0.7) * 0.5;

    float n      = fbm(uv);
    float bands  = smoothstep(0.6, 1.0, n);
    float grain  = noise(uv * 8.0 + timer * 5.0);
    float laserNoise = clamp(bands * 0.3 + grain * 0.7, 0.0, 1.0);
	
	// Simulate interference.
    float interference1 = fract(sin(dot(fragCoord * 45 + timer * 0.8, vec2(13, 80))) * 43800);
    float interference2 = fract(sin(dot(fragCoord * 60 + timer * 1.2, vec2(90, 50))) * 67000);
    float interference3 = fract(sin(dot(fragCoord * 81 - timer * 0.5, vec2(35, 90))) * 25000);
    
	float interferenceStr = 0.5;
    float interference = (interference1 + interference2 + interference3) / 3.0;
	float grainInterference = smoothstep(0.25, 0.75, interference);  
    grainInterference = ((grainInterference * 2.0) - 1.0) * interferenceStr;  
    vec3 interColor = fragColor.rgb * (1.0 + grainInterference);
    
	// Modulate alpha
    float alphaOrigin = fragColor.a;
    float alphaNoise = fbm(uv * 3.0 + vec2(timer * 2.0, -timer));

	// Combine color and alpha
	float finalAlpha = alphaOrigin * mix(0.15, 1.0, mix(alphaNoise, grainInterference, 0.6));
	vec3 finalColor = interColor + vec3(laserNoise) * 0.4;
    return vec4(finalColor, finalAlpha);
}