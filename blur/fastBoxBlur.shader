#iChannel0 "file://outline.shader"
#iChannel1 "file://test.png"
#iUniform float R = 10.0 in {10.0, 50.0}
#iUniform vec2 uOffset = vec2(0.0, 0.0) in {-100.0, 100.0}
#iUniform vec3 uShadowColor = vec3(0.0, 0.0, 0.0) in {0.0, 1.0}
#iUniform vec3 uBackground = vec3(0.0, 0.0, 0.0) in {0.0, 1.0}
#iUniform float uAlpha = 0.5 in {0.0, 1.0}

void main() {
    vec2 origin_uv = gl_FragCoord.xy / iResolution.xy;
    vec4 originColor = texture(iChannel0, origin_uv);
    if (originColor.a > 0.01) {
        gl_FragColor = originColor;
    } else {
        vec2 uv = origin_uv - uOffset/iResolution.xy;
        float sum_c = texture(iChannel1, uv).a;
   	    vec2 offset = vec2(1.0 / iResolution.x, 1.0 / iResolution.y);
        for(float i = 1.5; i <= R; i+=2.0){
            for (float j = 1.5; j <= R; j+=2.0) {
                sum_c += texture(iChannel1, uv + offset * vec2(i, -j)).a * 2.0;
                sum_c += texture(iChannel1, uv + offset * vec2(i, j)).a * 2.0;
                sum_c += texture(iChannel1, uv + offset * vec2(-i, -j)).a * 2.0;
                sum_c += texture(iChannel1, uv + offset * vec2(-i, j)).a * 2.0;
            }
        }
        sum_c =  sum_c / (2.0*R*R + 1.0) *uAlpha;
        vec3 backColor = uBackground * (1.0-sum_c) + sum_c*uShadowColor;
        gl_FragColor = vec4(backColor, 1.0);
    }
}