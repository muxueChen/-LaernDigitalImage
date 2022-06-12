
#iChannel0 "file://lyf.jpg"

// 对高斯函数进行采样
float normpdf(float x, float sigma) {
	return 0.39894*exp(-0.5*x*x/(sigma*sigma))/sigma;
}

void mainImage( out vec4 fragColor, in vec2 fragCoord ) {
	vec3 c = texture(iChannel0, fragCoord.xy / iResolution.xy).rgb;
	if (fragCoord.x < iMouse.x) {
		fragColor = vec4(c, 1.0);	
	} else {
		const int mSize = 11;// 模糊直径
		const int kSize = (mSize-1)/2;// 模糊半径
		float kernel[mSize];
		float sigma = 7.0;//sigma
		for (int j = 0; j <= kSize; ++j) {
			kernel[kSize+j] = kernel[kSize-j] = normpdf(float(j), sigma);
		}

		float Z = 0.0;//采样总量
		for (int j = 0; j < mSize; ++j) {
			Z += kernel[j];
		}
		vec3 final_colour = vec3(0.0);
		for (int i=-kSize; i <= kSize; ++i) {
			for (int j=-kSize; j <= kSize; ++j) {
				final_colour += kernel[kSize+j]*kernel[kSize+i]*texture(iChannel0, (fragCoord.xy+vec2(float(i),float(j))) / iResolution.xy).rgb;
			}
		}
		fragColor = vec4(final_colour/(Z*Z), 1.0);
	}
}