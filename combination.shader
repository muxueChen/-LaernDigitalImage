#iChannel0 "file://yy.jpg"
const float PI = 3.1415926;

// 平移矩阵
mat3 getDistanceMatrix(float dx, float dy) {
    return mat3(1,   0,   0, 
                0,   1,   0, 
                -dx, -dx, 1);
}

// 缩放矩阵
mat3 getScaleMatrix(float sx, float sy) {
    return mat3(1.0/sx, 0,          0, 
                0,      1.0/sy,     0, 
                0,      0,          1);
}

// 旋转
mat3 getRotateMatrix(float angle) {
    float arc = (angle/180.0)*PI;
    mat3 sMat = mat3(1, 0, 0, 
                     0, 1, 0, 
                     0.5, 0.5, 1);
    mat3 rMat = mat3(cos(arc), -sin(arc), 0, 
                     sin(arc), cos(arc),  0, 
                     0,         0,        1);

    mat3 eMat = mat3(1,     0,       0, 
                     0,     1,       0, 
                     -0.5, -0.5,     1);
    return sMat * rMat * eMat;
}

void main() {
    vec2 uv = gl_FragCoord.xy/iResolution.xy;
    mat3 dMat = mat3(0, 1, 0, 
                     1, 0, 0, 
                     0, 0, 1);
    vec3 originUV = dMat * vec3(uv, 1);
    uv = originUV.xy;
    if (uv.x < 0.0 || uv.y < 0.0 || uv.x > 1.0 || uv.y > 1.0) {
        gl_FragColor = vec4(0.0);
    } else {
        gl_FragColor = texture2D(iChannel0, originUV.xy);
    }
}