// 旋转变换
#iChannel0 "file://yy.jpg"
#iUniform float angle = 0.0 in {0.0, 360.0} 

const float PI = 3.1415926;
mat3 getRotateMatrix(float angle) {
    float arc = (angle/180.0)*PI;
    mat3 sMat = mat3(1, 0, 0, 
                     0, 1, 0, 
                     0.5, 0.5, 1);
    mat3 rMat = mat3(cos(arc), -sin(arc), 0, 
                     sin(arc), cos(arc), 0, 
                     0, 0, 1);

    mat3 eMat = mat3(1, 0, 0, 
                     0, 1, 0, 
                     -0.5, -0.5, 1);

    return sMat * rMat * eMat;
}

void main() {
    
    vec2 uv = gl_FragCoord.xy/iResolution.xy;
    mat3 mat = getRotateMatrix(angle);

    vec3 originUV = mat * vec3(uv, 1);
    uv = originUV.xy;
    if (uv.x < 0.0 || uv.y < 0.0 || uv.x > 1.0 || uv.y > 1.0) {
        gl_FragColor = vec4(0.0);
    } else {
        gl_FragColor = texture2D(iChannel0, originUV.xy);
    }
}