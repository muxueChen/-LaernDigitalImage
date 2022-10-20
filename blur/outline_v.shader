
#iChannel0 "file://outline_h.shader"
#iChannel1 "file://expandV.shader"
#iChannel2 "file://test.png"

#iUniform float lineW = 1.0 in {0.0, 1.0}
float normpdf(in float x, in float sigma) {
	return 0.39894*exp(-0.5*x*x/(sigma*sigma))/sigma;
}

float getAlpha(vec2 uv) {
	if (uv.x < 0.f || uv.y < 0.f || uv.x > 1.f || uv.y > 1.f) {
		return 0.0;
	}
	return texture(iChannel0, uv).a;
}


void main() {
	float sigma = 10.0;
	float Z = normpdf(0.0, sigma);
	float final_colour = Z*texture(iChannel0, gl_FragCoord.xy / iResolution.xy).a;

	for (int j = 1; j < 20; ++j) {
		float ratio = normpdf(float(j), sigma);
		Z += ratio*2.0;
		final_colour += ratio*texture(iChannel0, (gl_FragCoord.xy+vec2(0.0, float(j))) / iResolution.xy).a;
		final_colour += ratio*texture(iChannel0, (gl_FragCoord.xy+vec2(0.0, float(-j))) / iResolution.xy).a;
	}
    float start = 0.9 - lineW*0.4;
    final_colour = final_colour/Z;
    final_colour = smoothstep(start - 0.03, start, final_colour) - smoothstep(0.87, 0.9, final_colour);
    vec4 originColor = texture2D(iChannel2, gl_FragCoord.xy/iResolution.xy);
    
	gl_FragColor = vec4(final_colour) + originColor*(1.0-final_colour)*originColor.a; 
}