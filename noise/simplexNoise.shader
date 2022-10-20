vec2 hash22(vec2 p) {
    p = vec2(dot(p,vec2(127.1,311.7)),
            dot(p,vec2(269.5,183.3)));
    return -1.0 + 2.0 * fract(sin(p)*43758.5453123);
}

float simplex_noise(vec2 p) {
    const float K1 = 0.366025404; // (sqrt(3)-1)/2;
    const float K2 = 0.211324865; // (3-sqrt(3))/6;

    vec2 i = floor(p + (p.x + p.y) * K1);

    vec2 a = p - (i - (i.x + i.y) * K2);
    vec2 o = (a.x < a.y) ? vec2(0.0, 1.0) : vec2(1.0, 0.0);
    vec2 b = a - o + K2;
    vec2 c = a - 1.0 + 2.0 * K2;
    vec3 h = max(0.5 - vec3(dot(a, a), dot(b, b), dot(c, c)), 0.0);
    vec3 n = h * h * h * h * vec3(dot(a, hash22(i)), dot(b, hash22(i + o)), dot(c, hash22(i + 1.0)));
    return dot(vec3(70.0, 70.0, 70.0), n);
}

void main() {
    vec2 uv = gl_FragCoord.xy/iResolution.xy;
    float perlinNoiseValue = simplex_noise(uv*8.0);
    gl_FragColor = vec4(vec3(perlinNoiseValue), 1.0);
}