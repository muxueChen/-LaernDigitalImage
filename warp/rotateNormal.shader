// 旋转变换
#iChannel0 "file://yy.jpg"
#iUniform float angle = 0.0 in {0.0, 360.0} 

const float PI = 3.1415926;
mat3 getRotateMatrix(float angle) {
    float arc = radians(angle);
    float y = cos(arc);
    float x = sin(arc);
    mat3 mat = mat3(y, -x, 0.0, 
                    x, y, 0.0, 
                   0.5*(1.0-y-x), 0.5*(1.0+x-y), 1.0);

    return mat;
}

void main() {
    
    vec2 uv = gl_FragCoord.xy/iResolution.xy;
    mat3 mat = getRotateMatrix(angle);

    vec3 originUV = mat * vec3(uv, 1);
    originUV = clamp(originUV, 0.0, 1.0);
   gl_FragColor = texture2D(iChannel0, originUV.xy);
}