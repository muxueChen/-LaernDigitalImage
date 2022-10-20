
#iUniform float angle = 0.0 in {-360.0, 360.0}

float circle(in vec2 _st, in float _radius){
    vec2 dist = _st-vec2(0.5);//-0.5~0.5
	return 1.-smoothstep(_radius-(_radius*0.01),
                         _radius+(_radius*0.01),
                         dot(dist,dist)*4.0);
}

mat4 getRotateMatrixX() {
    float arc = radians(angle);
    float cosX = cos(arc);
    float sinX = sin(arc);
    mat4 mat = mat4(1.0, 0.0,   0.0,   0.0,
                    0.0, cosX, -sinX,  0.0,
                    0.0, sinX, cosX,  0.0,
                    0.0, 0.0,   0.0,   1.0);
    return mat;
}

mat4 getRotateMatrixY() {
    float arc = radians(angle);
    float cosX = cos(arc);
    float sinX = sin(arc);
    mat4 mat = mat4(cosX,  0.0,   -sinX, 0.0,
                    0.0,   1.0,   0.0,   0.0,
                    sinX,  0.0,   cosX,  0.0,
                    0.0,   0.0,   0.0,   1.0);
    return mat;
}

mat4 getRotateMatrixZ() {
    float arc = radians(angle);
    float cosX = cos(arc);
    float sinX = sin(arc);
    mat4 mat = mat4(cosX, -sinX,   0.0,   0.0,
                    sinX, cosX,    0.0,   0.0,
                    0.0,  0.0,     1.0,   0.0,
                    0.0,  0.0,     0.0,  1.0);
    return mat;
}


void main(){
    vec2 uv = gl_FragCoord.xy/iResolution.xy;
    float arc = radians(angle);
    uv.y = uv.y * cos(arc);
	vec3 color = vec3(circle(uv,0.1));

	gl_FragColor = vec4( color, 1.0 );
}