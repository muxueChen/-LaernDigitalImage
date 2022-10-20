#iUniform vec2 UVScale = vec2(5.0, 5.0) in {1.0, 100.0}
#iUniform vec2 UVScale1 = vec2(5.0, 5.0) in {1.0, 100.0}
#iUniform vec2 UVScale2 = vec2(5.0, 5.0) in {1.0, 100.0}
#iUniform vec2 UVScale3 = vec2(5.0, 5.0) in {1.0, 100.0}
#iUniform float XScale = 1.0 in {0.5, 100.0}

vec2 random2(vec2 p) {
    return fract(sin(vec2(dot(p,vec2(127.1,311.7)),dot(p,vec2(269.5,183.3))))*43758.5453);
}

float getWorleyNoise(vec2 p, float freq) {
    //栅格化获取id，及offset
    p.y -= iTime;
    vec2 id = floor(p);
    vec2 offset = fract(p);
    float min_dist = 10.0;
    //循环相邻9个控制点，获取当前像素距最近控制点的距离
    for ( int m = -1; m <= 1; m++ ) {
        for ( int n = -1; n <= 1; n++ ) {
            vec2 searchPoint = id + vec2( m, n );
            //对栅格点进行随机偏移
            searchPoint += random2(searchPoint);
            float dist = distance(p, searchPoint);
            min_dist = min(min_dist, dist);
        }
    }
    return min_dist;
}

vec3 fire_color(float x) {
	return
        // red
        vec3(1., 0., 0.) * x
        // yellow
        + vec3(1., 1., 0.) * clamp(x - .5, 0., 1.)
        // white
        + vec3(1., 1., 1.) * clamp(x - .7, 0., 1.);
}

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
    float freq = 1.0;
    //对屏幕进行缩放及拉伸处理.0
    float value = getWorleyNoise(uv *UVScale* freq, freq)*0.625;
    value += getWorleyNoise(uv * UVScale*freq * 2.0, freq * 2.0) * 0.25;
    value += getWorleyNoise(uv * UVScale*freq * 4.0, freq * 4.0) * 0.125;
	value += getWorleyNoise(uv * UVScale*freq * 8.0, freq * 8.0) * 0.0625;
	value += getWorleyNoise(uv * UVScale*freq * 16.0, freq * 16.0) * 0.03125;
    float p = pow((1.0-uv.y), 3.0);
    float x = perlinNoise(uv.x * XScale);
    float fire_intensity = p + x * 0.1;
    vec3 fire = fire_color(2. * value)*fire_intensity;
    gl_FragColor = vec4(vec3(fire), 1.0);
}