#iUniform float a = 0.5 in {0.2, 0.8}
#iUniform float b = 0.3 in {0.2, 0.8}
#iUniform float w = 0.02 in {0.01, 0.3}
// 椭圆
void main() {
    
    vec2 originUV = gl_FragCoord.xy/iResolution.xy;
    vec2 uv = originUV - 0.5;
    uv *= 1.5;
    // 构造椭圆标准方程
    // 定义两个点 F1 和 F2，对于任意点M，满足 |F1M| + |F2M| = 2a;
    // 标准方程为 (x^2)/(a^2) + (y^2)/(b^2) = 1, 其中a>b>0, c^2 = a^2 - b^
    float x = uv.x * uv.x;
    float y = uv.y * uv.y;
    float A = a * a;
    float B = b * b;
    float result = x/A - y/B;
    float p = w;
    float color = step(1.0 - p, result) - step(1.0 + p, result);
    
    gl_FragColor = vec4(color);
}