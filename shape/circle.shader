// 写一个只画长方形四边的函数
void main() {
    vec2 uv = gl_FragCoord.xy/iResolution.xy;
    uv = uv - 0.5;
    float l = length(uv);
    float r = 0.43*abs(sin(iTime));
    float ptc = smoothstep(r-0.02, r, l) - smoothstep(r, r+0.02, l);
    vec3 color = vec3(ptc);
    gl_FragColor = vec4(color, 1.0);
}