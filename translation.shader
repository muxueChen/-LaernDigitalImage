// 平移变换
#iChannel0 "file://yy.jpg"
#iUniform vec2 distance = vec2(0.0, 0.0) in {-0.5, 0.5} 

void main() {
    vec2 uv = gl_FragCoord.xy/iResolution.xy;
    mat3 dMat = mat3(1,         0, 0, 
                    0, 1, 0, 
                    -distance.x, -distance.y, 1);
    vec3 originUV = dMat * vec3(uv, 1);
    uv = originUV.xy;
    if (uv.x < 0.0 || uv.y < 0.0 || uv.x > 1.0 || uv.y > 1.0) {
        gl_FragColor = vec4(0.0);
    } else {
        gl_FragColor = texture2D(iChannel0, originUV.xy);
    }
}