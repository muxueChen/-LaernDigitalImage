// 方向模糊
#iChannel0 "file://霓虹中国.jpg"
#iUniform int iteration = 4 in {2, 10}
#iUniform float radius = 0.01 in {0.0, 10.0}
#iUniform float angle = 0.0 in {0.0, 360.0}

vec4 getTexture(vec2 uv) {
    if (uv.x < 0.0 || uv.y < 0.0 || uv.x > iResolution.x || uv.y > iResolution.y) {
        return vec4(0.0);
    }
    return texture2D(iChannel0, uv/iResolution.xy);
}

vec4 DirectionalBlur(vec2 uv, vec2 size) {
    vec4 color = vec4(0.0);
    
    float arc = radians(angle);
    float sinVal = (sin(arc) * radius);
    float cosVal = (cos(arc) * radius);
    vec2 direction = vec2(sinVal, cosVal);
    vec2 tempUv = uv;
    for (int j = 0; j < iteration; j ++) {
        tempUv = uv - direction*float(j);
        color += getTexture(tempUv);
    }
    vec4 finalColor = color / (float(iteration) * 2.0);
    return finalColor;
}

void main() {
    vec4 resultColor = DirectionalBlur(gl_FragCoord.xy, iResolution.xy);
    gl_FragColor = resultColor;
}