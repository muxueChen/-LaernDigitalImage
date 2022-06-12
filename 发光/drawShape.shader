#define PI 3.14159265359
#define TWO_PI 6.28318530718

#define colorRange 24.0

float getSquare(vec2 p, vec2 rp){
    p *= vec2(iResolution.x, iResolution.y);// 得到一个相对位置
    p /= max(iResolution.x, iResolution.y);// 除以宽和高中长度最大的边，得到一个归一化的值
        
    p += rp;
    vec2 bl = step(abs(p * 2.0 - 1.0),vec2(0.2));
    float rt = bl.x * bl.y;
    
	return rt;
}

float getCircle(vec2 p, vec2 rp){
	p *= vec2(iResolution.x, iResolution.y);
    p /= max(iResolution.x, iResolution.y);
    
    return step(distance(p, rp), 0.1);
}

float getTriangle(vec2 p, vec2 rp){
    p *= vec2(iResolution.x, iResolution.y);
    p /= max(iResolution.x, iResolution.y);
    
    p -= rp;

    vec3 color = vec3(0.0);
    float d = 0.0;

    // Remap the space to -1. to 1.
    p = p *2.-1.;

    // Number of sides of your shape
    int N = 3;

    // Angle and radius from the current pixel
    float a = atan(p.x,p.y)+PI;
    float r = TWO_PI/float(N);

    d = cos(floor(.5+a/r)*r-a)*length(p);

    return 1.0-step(.12,d);
}

vec3 getTexture(vec2 uv){
    vec4 textureSample = texture(iChannel0, uv);
	return sqrt(textureSample.rgb * textureSample.a);
}

void main() {
    vec2 uv = gl_FragCoord.xy / iResolution.xy;
    
    vec3 triangle = getTriangle(uv, vec2(0.0, -0.23)) * vec3(2.0, 30.0, 2.0) * 2.0;
    
    vec3 color = triangle;
    gl_FragColor = vec4(pow(color, vec3(1.0 / 2.2)) / colorRange,1.0);
}