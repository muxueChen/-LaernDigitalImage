
#iChannel0 "file://gaussianBlur_V.shader"
#iChannel1 "file://test.png"

#iUniform vec2 mOffset = vec2(5.0, 5.0) in {-50.0, 50.0}
#iUniform vec3 mColor = vec3(0.0, 0.0, 0.0) in {0.0, 1.0}

void main() {
	vec2 uv = gl_FragCoord.xy / iResolution.xy;
	vec2 offsetUV = uv + mOffset/iResolution.xy;
	vec4 originColor = texture(iChannel1, uv);
	vec4 shadowColor = texture(iChannel0, offsetUV);

	vec3 final_colour = originColor.rgb*originColor.a + (1.0 - originColor.a)*(shadowColor.rgb*mColor + vec3(1.0 - shadowColor.a));
	gl_FragColor = vec4(final_colour, 1.0);
}