#iChannel0 "file://lyf.jpg"

#iUniform float offsetY = 0.0 in {-1.0, 1.0}
#iUniform float radius = 0.1 in {0.01, 1.0}
#iUniform float spread = 0.1 in {0.0, 10.0}
float TiltShiftMask(vec2 uv) {
    float centerY = uv.y * 2.0 - 1.0;
    if (radius<0.01) {
        return 1.0;
    }
    float mask = smoothstep(offsetY, offsetY-radius, centerY) + smoothstep(offsetY, offsetY+radius, centerY);
    return pow(mask, spread);
}

void main() {
    vec2 uv = gl_FragCoord.xy/iResolution.xy;
    float mask = TiltShiftMask(uv);
    vec4 originColor = texture2D(iChannel0, uv);
    
    const int mSize = 11;// 模糊直径
    const int kSize = (mSize-1)/2;// 模糊半径
    vec3 final_colour = vec3(0.0);
    for (int i=-kSize; i <= kSize; ++i) {
        for (int j=-kSize; j <= kSize; ++j) {
            final_colour += texture(iChannel0, (gl_FragCoord.xy+vec2(float(i),float(j))) / iResolution.xy).rgb;
        }
    }
    vec4 blurColor = vec4(final_colour/float(mSize*mSize), 1.0);
    gl_FragColor = mix(originColor, blurColor, mask);
}