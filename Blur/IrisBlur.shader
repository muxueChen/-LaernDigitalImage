#iChannel0 "file://lyf.jpg"
#iUniform float a = 0.5 in {0.2, 0.8}
#iUniform float b = 0.3 in {0.2, 0.8}
#iUniform float damping = 2.0 in {0.0, 10.0}

float getMask(vec2 inputUv) {
    vec2 uv = inputUv - 0.5;
    uv *= 1.5;

    float x = uv.x * uv.x;
    float y = uv.y * uv.y;
    
    float A = a * a;
    float B = b * b;
    float result = x/A + y/B;
    float mask = clamp(0.0, 1.0, result);
    mask = pow(mask, damping);
    return mask;
}

void main() {
    vec2 originUV = gl_FragCoord.xy/iResolution.xy;
    vec4 originColor = texture2D(iChannel0, originUV);
    float mask = getMask(originUV);
    const int mSize = 31;// 模糊直径
    const int kSize = (mSize-1)/2;// 模糊半径
    vec3 final_colour = vec3(0.0);
    for (int i=-kSize; i <= kSize; ++i) {
        for (int j=-kSize; j <= kSize; ++j) {
            final_colour += texture(iChannel0, (gl_FragCoord.xy+vec2(float(i),float(j))) / iResolution.xy).rgb;
        }
    }
    vec4 blurColor = vec4(final_colour/float(mSize*mSize), 1.0);
    gl_FragColor = mix(originColor, blurColor, mask);
    // gl_FragColor = vec4(mask);
}