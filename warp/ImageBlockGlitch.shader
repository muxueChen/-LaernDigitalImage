
#iChannel0 "file://yy.jpg"
#iUniform vec2 BlockSize = vec2(10.0, 10.0) in {1.0, 100.0}

float randomNoise(float x, float y) {
    return fract(sin(dot(vec2(x, y), vec2(12.9898, 78.233)*iTime*0.1)) * 43758.5453);
}


void main() {
    vec2 uv = gl_FragCoord.xy/iResolution.xy;
    vec2 targetUV = floor(uv*BlockSize);
    float displaceNoise = randomNoise(targetUV.x, targetUV.y);
    displaceNoise = pow(displaceNoise, 8.0) * pow(displaceNoise, 3.0);
    
    float ColorR = texture2D(iChannel0, uv).r;
    float ColorG = texture2D(iChannel0, uv + vec2(displaceNoise * 0.05, 0.0)).g;
    float ColorB = texture2D(iChannel0, uv - vec2(displaceNoise * 0.05, 0.0)).b;

    gl_FragColor = vec4(displaceNoise);
}