// 镜像变换
#iChannel0 "file://yy.jpg"
#iUniform int type = 1 in {1, 4}// 1:水平镜像；2：垂直镜像；3：水平垂直镜像;4:原图
void main() {
    vec2 uv = gl_FragCoord.xy/iResolution.xy;
    mat3 dMat;
    if (type == 1) {
       dMat = mat3(-1, 0, 0, 
                    0, 1, 0, 
                    1, 0, 1);
    } else if (type == 2) {
        dMat = mat3(1, 0, 0, 
            0, -1, 0, 
            0, 1, 1);
    } else if (type == 3) {
        dMat = mat3(-1, 0, 0, 
                    0, -1, 0, 
                    1, 1, 1);
    } else {
        dMat = mat3(1, 0, 0, 
                    0, 1, 0, 
                    0, 0, 1); 
    }
     
    vec3 originUV = dMat * vec3(uv, 1);
    uv = originUV.xy;
    if (uv.x < 0.0 || uv.y < 0.0 || uv.x > 1.0 || uv.y > 1.0) {
        gl_FragColor = vec4(0.0);
    } else {
        gl_FragColor = texture2D(iChannel0, originUV.xy);
    }
}