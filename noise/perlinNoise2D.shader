// 伪随机向量
vec2 hash22(vec2 p) {
    p = vec2( dot(p,vec2(127.1,311.7)),
              dot(p,vec2(269.5,183.3)));
    return -1.0 + 2.0 * fract(sin(p)*43758.5453123);
}

float perlinNoise(vec2 p) {
    vec2 pi = floor(p);
    vec2 pf = p - pi;
    vec2 w = pf * pf * (3.0 - 2.0 * pf);// 缓和曲线
    return mix(mix(dot(hash22(pi + vec2(0.0, 0.0)), pf - vec2(0.0, 0.0)), 
                   dot(hash22(pi + vec2(1.0, 0.0)), pf - vec2(1.0, 0.0)), w.x), 
               mix(dot(hash22(pi + vec2(0.0, 1.0)), pf - vec2(0.0, 1.0)), 
                   dot(hash22(pi + vec2(1.0, 1.0)), pf - vec2(1.0, 1.0)), w.x),
               w.y);
}


void main() {
    vec2 uv = gl_FragCoord.xy/iResolution.xy;
    float perlinNoiseValue = perlinNoise(uv*10.0 + iTime) + 0.5;
    perlinNoiseValue = step(0.0, perlinNoiseValue);// 二值化
    gl_FragColor = vec4(vec3(perlinNoiseValue), 1.0);
}