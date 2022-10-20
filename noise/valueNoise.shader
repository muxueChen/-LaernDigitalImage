// 伪随机向量
float hash21(vec2 p)  // replace this by something better
{
    p  = 50.0*fract( p*0.3183099 + vec2(0.71,0.113));
    return -1.0+2.0*fract( p.x*p.y*(p.x+p.y) );
}


float valueNoise(vec2 p) {
    vec2 pi = floor(p);
    vec2 pf = p - pi;
    vec2 w = pf * pf * (3.0 - 2.0 * pf);// 缓和曲线
    return mix(mix(hash21(pi + vec2(0.0, 0.0)), hash21(pi + vec2(1.0, 0.0)), w.x),
               mix(hash21(pi + vec2(0.0, 1.0)), hash21(pi + vec2(1.0, 1.0)), w.x),
               w.y);
}

void main() {
    vec2 uv = gl_FragCoord.xy/iResolution.xy;
    float Value = valueNoise(uv*20.0 - iTime);
    Value = step(0.0, Value);
    gl_FragColor = vec4(vec3(Value), 1.0);
}