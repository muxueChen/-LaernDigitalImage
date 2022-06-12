#iChannel0 "file://lyf.jpg"
#iUniform int Iteration = 3 in {1, 10}
#iUniform vec2 Center = vec2(0.5, 0.5) in {0.0, 1.0}
#iUniform float Radius = 0.1 in {0.0, 1.0}

vec4 radialBlur(vec2 inputUV) {
    vec2 blurVec = (Center - inputUV)*Radius;
    vec4 acumulateColor = vec4(0.0);
    vec2 targetUV = inputUV;
    for (int j = 0; j < Iteration; j ++) {
        acumulateColor += texture2D(iChannel0, targetUV);
        targetUV += blurVec;
        targetUV = clamp(vec2(0.0), vec2(1.0), targetUV);
    }
    return acumulateColor/float(Iteration);
}

void main() {
    vec2 uv = gl_FragCoord.xy/iResolution.xy;
    gl_FragColor = radialBlur(uv);
}