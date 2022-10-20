
#iChannel0 "file://expandV.shader"

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
		final_colour += ratio*texture(iChannel0, (gl_FragCoord.xy+vec2(float(j), 0.0)) / iResolution.xy).a;
		final_colour += ratio*texture(iChannel0, (gl_FragCoord.xy+vec2(float(-j), 0.0)) / iResolution.xy).a;
	}
	gl_FragColor = vec4(final_colour/Z);
}