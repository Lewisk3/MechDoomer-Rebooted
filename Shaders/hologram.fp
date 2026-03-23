uniform float timer;  

vec4 Process(vec4 color)
{
    vec2 fragCoord = gl_TexCoord[0].xy;
    vec4 fragColor = getTexel(fragCoord);
    vec2 uv = fragCoord;    
	
	// Shift direction a little.
    float skewAmount = 0.015 * sin(timer * 1.5);
    uv.x += skewAmount * (uv.y - 0.5);
	uv.y += 0.5 * (skewAmount * (uv.x - 0.5));
    fragColor = getTexel(uv);
	
	// Strength of hologram effect
	float str = 0.85;
	float alphaBoost = 5.0;

    // Hologram Color
    vec3 holoColor = vec3(0.2, 0.9, 1.0);

	// Horizontal scanlines + scroll
	float lineFreq = 300.0;
	float scanMask = (0.5 * sin(fragCoord.y * lineFreq + timer * 10.0)) + 0.5;
	float verticalFade = fragCoord.y;
	
    float intensity = mix(1.0, scanMask * verticalFade, str);
	vec3 finalColor = fragColor.rgb * holoColor * intensity;
	float alpha = fragColor.a * alphaBoost;

    return vec4(finalColor, alpha);
}