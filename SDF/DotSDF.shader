
#iUniform vec2 uPoint = vec2(0.0, 0.0) in {0.0, 1.0}
#iUniform float uR = 0.02 in {0.01, 0.1}
#iUniform vec3 uColor = vec3(1.0, 1.0, 1.0) in {0.0, 1.0}

float roundSDF(vec2 center, vec2 P) {
    return distance(center, P);
}

float getCol(vec2 uv) {
    float normalW = min(iResolution.x, iResolution.y);
    float d = roundSDF(uPoint*iResolution.xy/normalW,  uv*iResolution.xy/normalW);
    float sm = 3.0/normalW;
    float c = 1.0 - smoothstep(uR, uR+sm, d);
    return c;
}

void main() {
    vec2 uv = gl_FragCoord.xy/iResolution.xy;
    float c = getCol(uv);
    gl_FragColor = vec4(c*uColor, c);
}