#iChannel0 "file://maskSDF.shader"
#iUniform float mSize_H = 11 in {0.0, 100}

float getAlpha(vec2 uv) {
    vec2 tempUV = clamp(uv, 0.0, 1.0);
    return texture(iChannel0, tempUV).a;
} 

void main() {
    vec2 uv = gl_FragCoord.xy/iResolution.xy;
    vec2 pixleSize = 1.0/iResolution.xy;
    float color = 0.0;
    float count = 0.0;
    for (float i = -mSize_H; i < mSize_H; i += 2.0) {
        for (float j = -mSize_H; j < mSize_H; j+=2.0) {
            color += getAlpha(uv + pixleSize*vec2(j, i));
            count += 1.0;
        }
        
    }
    color /= count;
    color = pow(color, 1.0);
    gl_FragColor = vec4(color);
}