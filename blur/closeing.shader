#iChannel0 "file://expand.shader"
#iChannel1 "file://test.png"

float horizontal(vec2 coord) {
    vec2 tempUV = coord;
    for (float i = -10.0; i<10.0; i++) {
        for (float j = -10.0; j<10.0; j++) {
            tempUV = coord + vec2(i, j);
            if(tempUV.x>0.0&&tempUV.x<iResolution.x&&tempUV.y>0.0&&tempUV.y<iResolution.y) {
                vec4 tempColor = texture2D(iChannel0, tempUV/iResolution.xy);
                if (tempColor.a<0.1) {
                    return 0.0;
                }
            }
        } 
    }
    return 1.0;
}

void main() {
    vec2 uv = gl_FragCoord.xy/iResolution.xy;
    vec4 originColor = texture2D(iChannel1, uv);
    // originColor *= originColor.a;
    float color = horizontal(gl_FragCoord.xy);
    gl_FragColor = vec4(color);
    // gl_FragColor = vec4(originColor.a);
}