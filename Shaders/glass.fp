const float alpha = 0.2;
vec4 Process(vec4 color)
{
	vec2 texCoord = gl_TexCoord[0].st;
	color.a *= alpha;
	
	return getTexel(texCoord) * color;
}