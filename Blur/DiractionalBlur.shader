#iChannel0 "file://lyf.jpg"
#iUniform float Angle = 0.0 in {0.0, 360.0}
#iUniform float Radius = 0.1 in {0.01, 0.5}
#iUniform int Iteration = 3 in {1, 10}

vec4 diractional(vec2 inputUV) {
    float arc = radians(Angle);
    vec2 blurVec = vec2(cos(arc), sin(arc))*Radius;
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
    gl_FragColor = diractional(uv);

}