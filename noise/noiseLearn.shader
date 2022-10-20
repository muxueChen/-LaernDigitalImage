
// hash 库
float hash11(float p) {
    p = fract(p * .1031);
    p *= p + 33.33;
    p *= p + p;
    return fract(p);
}

float hash2to1(vec2 p) {
	vec3 p3  = fract(vec3(p.xyx) * .1031);
    p3 += dot(p3, p3.yzx + 33.33);
    return fract((p3.x + p3.y) * p3.z);
}

float sinNoise(float x) {
    return fract(sin(x)*100000.0);
}

void main() {
    vec2 uv = gl_FragCoord.xy/iResolution.xy;
    uv -=0.5;
    uv *=4.0;
    float color = smoothstep(0.01, 0.0, abs(uv.y));
    vec3 segment = vec3(0.0, 1.0, 1.0) * color;
    float lineCol = 0.0;
    if(uv.y > 0.01) {
        uv.y -= 1.0;
        float y = sinNoise(uv.x*1000.0 + iTime);
        lineCol = smoothstep(0.01, 0.0, abs(uv.y));
        lineCol += smoothstep(0.01, 0.0, abs(uv.x));
        lineCol += smoothstep(0.01, 0.0, abs(uv.y - y));
    } else if (uv.y < -0.01 ) {
        uv.y += 2.0;
        uv.y -= 1.0;
        float y = hash11(uv.x*1000.0 + iTime);
        lineCol = smoothstep(0.01, 0.0, abs(uv.y));
        lineCol += smoothstep(0.01, 0.0, abs(uv.x));
        lineCol += smoothstep(0.01, 0.0, abs(uv.y - y));
    }

    vec3 line = vec3(lineCol);
    gl_FragColor = vec4(segment + line, color+lineCol);
}