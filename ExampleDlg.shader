// 平移变换
#iChannel0 "file://yy.jpg"
#iUniform vec2 distance = vec2(0.0, 0.0) in {-0.5, 0.5} 

// 错位变换矩阵
mat3 getExampleDlg(float kx, float ky) {
    return mat3(1, kx, 0,
                ky, 1, 0,
                0,  0, 1);
}
// 缩放矩阵
mat3 getScaleMatrix(float sx, float sy) {
    float dx = 0.5-(1.0/(sx *2.0));
    float dy = 0.5-(1.0/(sy *2.0));
    mat3 sMat = mat3(1.0/sx, 0,          0, 
                0,      1.0/sy,     0, 
                0,      0,          1);
    return sMat;
}

void main() {
    vec2 uv = gl_FragCoord.xy/iResolution.xy;
    float sCoefficientX = 1.0/(1.0 + distance.x);
    float sCoefficientY = 1.0/(1.0 + distance.y);
    mat3 dMat = getExampleDlg(distance.x, distance.y);
    mat3 sMat = getScaleMatrix(sCoefficientX, sCoefficientY);
    vec3 originUV = dMat * sMat * vec3(uv, 1);
    uv = originUV.xy;
    if (uv.x < 0.0 || uv.y < 0.0 || uv.x > 1.0 || uv.y > 1.0) {
        gl_FragColor = vec4(0.0);
    } else {
        gl_FragColor = texture2D(iChannel0, originUV.xy);
    }
}