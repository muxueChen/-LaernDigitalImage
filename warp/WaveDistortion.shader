#iChannel0 "file://yy.jpg"  
#iUniform int uType = 1 in {1, 2}
#iUniform float uAngle = 0.0 in {-360.0, 360.0}
#iUniform float uHeight = 0.0 in {0.0, 100.0}
#iUniform float uWidth = 0.0 in {0.0, 100.0}
#iUniform float uPhase = 0.0 in {-360.0, 360.0}
#iUniform float uSpeed = 0.0 in {0.0, 100.0}

vec2 SineWave(vec2 p) {
    float arc = radians(uAngle);
    vec2 targetUV = vec2(p.x, p.y)*iResolution.xy;
    mat3 sMat = mat3(cos(arc), -sin(arc), 0,
                        sin(arc), cos(arc), 0,
                        0, 0, 1);
    targetUV = (sMat * vec3(targetUV, 1.0)).xy;

    float waveH = 100.0;// 波形最大高度
    float waveW = 200.0;
    vec2 wave = vec2((uHeight/100.0)*waveH, (uWidth/100.0)*waveW);    
    float y = targetUV.y;
    float phase = radians(uPhase);

    if (uType == 1) {
        targetUV.x = targetUV.x + wave.x * sin(phase);
    } else {
        targetUV.x = targetUV.x + wave.x * sign(sin(phase));
    }
    mat3 eMat = mat3(cos(arc), sin(arc), 0,
                    -sin(arc), cos(arc), 0,
                    0, 0, 1);
    targetUV = (eMat * vec3(targetUV, 1.0)).xy;
    return targetUV/iResolution.xy;
}

void main() {
    vec2 out_uvs = gl_FragCoord.xy/iResolution.xy;
    vec2 uv = SineWave(out_uvs);
    gl_FragColor = texture2D(iChannel0, uv);    
}