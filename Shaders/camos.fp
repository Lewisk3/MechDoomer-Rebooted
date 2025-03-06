// Well, this apparently isn't possible to do in GZDoom at the moment....
// A feature exists in VKDoom which allows for the fields in this shader to be 
// modified via ZScript. Might end up switching to that later on, but as for now
// we'll stick to GZDoom.

vec4 mixthisshit(vec4 baseColor, vec4 tint)
{
	vec4 baseNormal = baseColor / 255.;
	vec4 tintNormal = tint / 255.;
	
	float colBright = (tint.r + tint.g + tint.b) / 255.;
	if(colBright < 0.01) return baseColor; 
	
	return vec4(
		baseNormal.r + ((tintNormal.r - baseNormal.r) * tintNormal.a),
		baseNormal.g + ((tintNormal.g - baseNormal.g) * tintNormal.a),
		baseNormal.b + ((tintNormal.b - baseNormal.b) * tintNormal.a),
		baseNormal.a
	) * 255.0;
}


vec4 Process(vec4 color)
{
	vec3 camoColorOne = vec3(0x09, 0x4D, 0x1C) * 0.5;
	float camoAlphaOne = 0.1;

	vec2 texCoord = gl_TexCoord[0].xy;
	vec4 camoGreyscale = texture(camotex, texCoord);
	
	vec4 camoColored = camoGreyscale * vec4(camoColorOne, camoAlphaOne * 255);
	vec4 finalColor = mixthisshit(color, camoColored);
	
    return getTexel(texCoord) * finalColor;
}