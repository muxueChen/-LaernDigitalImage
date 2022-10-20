
#iChannel0 "file://gaussianBlur_H.shader"
#iUniform int mSize_V = 11 in {9, 100}

float normpdf(in float x, in float sigma) {
	return 0.39894*exp(-0.5*x*x/(sigma*sigma))/sigma;
}

void main() {
	float sigma = float(mSize_V)/2.0;
	float Z = normpdf(0.0, sigma);
	float final_colour = Z*texture(iChannel0, gl_FragCoord.xy / iResolution.xy).a;

	for (int j = 1; j < mSize_V; ++j) {
		float ratio = normpdf(float(j), sigma);
		Z += ratio*2.0;
		final_colour += ratio*texture(iChannel0, (gl_FragCoord.xy+vec2(0.0, float(j))) / iResolution.xy).a;
		final_colour += ratio*texture(iChannel0, (gl_FragCoord.xy+vec2(0.0, float(-j))) / iResolution.xy).a;
	}
	
	gl_FragColor = vec4(final_colour/Z);
}