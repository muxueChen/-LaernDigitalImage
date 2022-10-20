#iChannel0 "file://mipmap0_H.glsl"
#iUniform int mSize_W = 11 in {3, 50}

float normpdf(in float x, in float sigma) {
	return 0.39894*exp(-0.5*x*x/(sigma*sigma))/sigma;
}

vec4 getAlpha(vec2 uv) {
	if (uv.x < 0.f || uv.y < 0.f || uv.x > 1.f || uv.y > 1.f) {
		return vec4(0.0);
	}
	return texture(iChannel0, uv);
}

void main() {
	float sigma = float(mSize_W)/2.0;
	float Z = normpdf(0.0, sigma);
	vec4 final_colour = Z*texture(iChannel0, gl_FragCoord.xy / iResolution.xy);

	for (int j = 1; j < mSize_W/2; ++j) {
		float ratio = normpdf(float(j), sigma);
		Z += ratio*2.0;
		final_colour += ratio*getAlpha((gl_FragCoord.xy+vec2(0.0, float(j)*2.0)) / iResolution.xy);
		final_colour += ratio*getAlpha((gl_FragCoord.xy+vec2(0.0, float(-j)*2.0)) / iResolution.xy);
	}
	gl_FragColor = vec4(final_colour/Z);
}