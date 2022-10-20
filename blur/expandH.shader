
#iChannel0 "file://test.png"
#iUniform int mSize_H = 11 in {3, 15}


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
	float sigma = float(mSize_H)/2.0;
	float Z = normpdf(0.0, sigma);
	float final_colour = Z*texture(iChannel0, gl_FragCoord.xy / iResolution.xy).a;

	for (int j = 1; j < mSize_H; ++j) {
		float ratio = normpdf(float(j), sigma);
		Z += ratio*2.0;
		final_colour += ratio*getAlpha((gl_FragCoord.xy+vec2(float(j)*4.0, 0.0)) / iResolution.xy);
		final_colour += ratio*getAlpha((gl_FragCoord.xy+vec2(float(-j)*4.0, 0.0)) / iResolution.xy);
	}
	gl_FragColor = vec4(final_colour/Z);
}