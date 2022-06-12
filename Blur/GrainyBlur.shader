#iChannel0 "file://lyf.jpg"
#iUniform int Iteration = 5 in {1, 10}
#iUniform float BlurRadius = 0.01 in {0.0, 1.0}

float Rand(vec2 inputUV) {
		return sin(dot(inputUV, vec2(1233.224, 1743.335)));
}

vec4 grainyBlur(vec2 inputUV) {
	vec2 randomOffset = vec2(0.0, 0.0);
	vec4 finalColor = vec4(0.0, 0.0, 0.0, 0.0);
	float random = Rand(inputUV);

	for (int k = 0; k < Iteration; k ++) {
		random = fract(43758.5453 * random + 0.61432);;
		randomOffset.x = (random - 0.5) * 2.0;
		random = fract(43758.5453 * random + 0.61432);
		randomOffset.y = (random - 0.5) * 2.0;
		finalColor += texture2D(iChannel0, inputUV + randomOffset * BlurRadius);
	}
	return finalColor / float(Iteration);
}

void  main() {
    vec2 uv = gl_FragCoord.xy/iResolution.xy;
    gl_FragColor = grainyBlur(uv);
}