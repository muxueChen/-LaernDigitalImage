// 径向模糊
#iChannel0 "file://霓虹中国.jpg"
#iUniform float radius = 0.01 in {0.0, 2.0}
#iUniform int iteration = 5 in {2, 10}
// 径向模糊的原理比较直接，首先选取一个径向轴心（Radial Center），
// 然后将每一个采样点的uv基于此径向轴心进行偏移（offset），并进行一定次数的迭代采样，
// 最终将采样得到的RGB值累加，并除以迭代次数。


vec4 getTexture(vec2 uv) {
    if (uv.x < 0.0 || uv.y < 0.0 || uv.x > iResolution.x || uv.y > iResolution.y) {
        return vec4(0.0);
    }
    return texture2D(iChannel0, uv/iResolution.xy);
}

vec4 radialBlur(vec2 uv, vec2 size) {
    vec2 center = size*0.5;
    vec2 blurVector = (center - uv) * radius;
    vec2 tempUv = uv;
    vec4 acumulateColor = vec4(0.0);
    for (int j = 0; j < iteration; j ++) {
        acumulateColor += getTexture(tempUv);
        tempUv += blurVector;
    }

    return acumulateColor / float(iteration);
}

void main() {
    vec4 resultColor = radialBlur(gl_FragCoord.xy, iResolution.xy);
    gl_FragColor = resultColor;
}