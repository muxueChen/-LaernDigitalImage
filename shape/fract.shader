void main() {
    vec2 uv = gl_FragCoord.xy/iResolution.xy;
    uv = uv - 0.5;
    uv = uv * 5.0;
    float len = dot(uv, uv);
    len = fract(len);
    gl_FragColor = vec4(len);
}