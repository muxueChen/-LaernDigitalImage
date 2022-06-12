#iChannel0 "file://KawaseBlur1.shader"

vec4 kawaseBlur(float d, vec2 uv, vec2 size) {
    vec4 resColor = vec4(0.0);
    vec2 lt = gl_FragCoord.xy + vec2(d - 0.5, d + 0.5);
    vec2 rt = gl_FragCoord.xy + vec2(d + 0.5, d + 0.5);
    vec2 lb = gl_FragCoord.xy + vec2(d - 0.5, d - 0.5);
    vec2 rb = gl_FragCoord.xy + vec2(d + 0.5, d - 0.5);
    resColor += texture2D(iChannel0, lt/size);
    resColor += texture2D(iChannel0, rt/size);
    resColor += texture2D(iChannel0, lb/size);
    resColor += texture2D(iChannel0, rb/size);
    return resColor * 0.25;
}

void main() {
    gl_FragColor = kawaseBlur(2.0, gl_FragCoord.xy, iResolution.xy);
}