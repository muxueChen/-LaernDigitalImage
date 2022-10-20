vec2 hash22(vec2 p) {
    p = vec2(dot(p,vec2(127.1,311.7)),
            dot(p,vec2(269.5,183.3)));
    return -1.0 + 2.0 * fract(sin(p)*43758.5453123);
}

float perlinNoise(float p) {
    float pi = floor(p);
    float pf = p - pi;
    float w = pf * pf*(3.0-2.0*pf);//缓和曲线差值
    return mix(dot(hash22(vec2(pi, 0.0)), vec2(pf, 0.0)-vec2(0.0, 0.0)),
        dot(hash22(vec2(pi, 0.0)+vec2(1.0, 0.0)), vec2(pf, 0.0)-vec2(1.0, 0.0)), w);
}

void main() {
    vec2 uv = gl_FragCoord.xy/iResolution.xy;
    uv.y -= 0.5;
    float perlinNoiseValue = perlinNoise(uv.x*10.0);
    float color = step(perlinNoiseValue-0.03, uv.y) - step(perlinNoiseValue+0.03, uv.y);
    gl_FragColor = vec4(vec3(color), 1.0);
}