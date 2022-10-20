// 缩放
#iChannel0 "file://yy.jpg"
#iUniform vec2 scale = vec2(1.0, 1.0) in {-2.0,2.0} 
#iUniform int type = 1 in {1, 2}
// 基于坐标中心做缩放
void centerOfCoord() {
    vec2 uv = gl_FragCoord.xy/iResolution.xy;
    mat3 sMat = mat3(1.0/scale.x, 0, 0, 
                    0, 1.0/scale.y, 0, 
                    0, 0, 1);
    vec3 originUV = sMat * vec3(uv, 1);
    uv = originUV.xy;
    if (uv.x < 0.0 || uv.y < 0.0 || uv.x > 1.0 || uv.y > 1.0) {
        gl_FragColor = vec4(0.0);
    } else {
        gl_FragColor = texture2D(iChannel0, originUV.xy);
    }
}
// 基于图像中心做缩放,平移坐标中心到图像中心——>缩放->将坐标中心还原。
void centerOfImage() {
    vec2 uv = gl_FragCoord.xy/iResolution.xy;
    float dx = 0.5-(1.0/(scale.x *2.0));
    float dy = 0.5-(1.0/(scale.y *2.0));
    mat3 sMat = mat3(1.0/scale.x, 0, 0, 
                    0, 1.0/scale.y, 0, 
                    dx, dy, 1);
    vec3 originUV = sMat * vec3(uv, 1);
    uv = originUV.xy;
    if (uv.x < 0.0 || uv.y < 0.0 || uv.x > 1.0 || uv.y > 1.0) {
        gl_FragColor = vec4(0.0);
    } else {
        gl_FragColor = texture2D(iChannel0, originUV.xy);
    }
}


void main() {
    if (type == 1) {
        centerOfImage();
    } else {
        centerOfCoord();
    }
}