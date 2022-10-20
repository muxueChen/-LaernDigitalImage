#iUniform float x = 0.0 in {0.0, 100.0}

float random (vec2 st) {
    // value 集中在 0.5 附近
    float value = fract(sin(dot(st.xy, vec2(12.9898,78.233))) *43758.5453123);
    return pow(value, x);
}

void main() {
    vec2 uv = gl_FragCoord.xy/iResolution.xy;
    float r = random(uv);
    gl_FragColor = vec4(r);
}