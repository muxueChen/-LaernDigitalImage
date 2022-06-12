// 写一个只画长方形四边的函数
void main() {
    vec2 uv = gl_FragCoord.xy/iResolution.xy;
    uv = uv - 0.5;
    uv = abs(uv);
    vec3 color = vec3(0.0);

    float ptc = step(0.4, uv.x) - step(0.45, uv.x) + step(0.4, uv.y) - step(0.45, uv.y);
    uv = step(vec2(0.05), 0.5-uv);

    color = vec3(ptc)*uv.x*uv.y;
    gl_FragColor = vec4(color, 1.0);
}