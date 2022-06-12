#iChannel0 "file://lyf.jpg"

void mainImage( out vec4 fragColor, in vec2 fragCoord ) {
	vec3 c = texture(iChannel0, fragCoord.xy / iResolution.xy).rgb;
    const int mSize = 31;// 模糊直径
    const int kSize = (mSize-1)/2;// 模糊半径
    vec3 final_colour = vec3(0.0);
    for (int i=-kSize; i <= kSize; ++i) {
        for (int j=-kSize; j <= kSize; ++j) {
            final_colour += texture(iChannel0, (fragCoord.xy+vec2(float(i),float(j))) / iResolution.xy).rgb;
        }
    }
    fragColor = vec4(final_colour/float(mSize*mSize), 1.0);
}