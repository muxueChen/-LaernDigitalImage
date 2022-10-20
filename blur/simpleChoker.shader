    attribute vec4 aPos;
    attribute vec2 aTexCoord;
    varying vec4 vPosition;
    varying vec2 vTexCoord;
    uniform vec2 uStep;
    varying vec4 vBlurCoord[11];
    void main() {
        gl_Position = vec4(aPos.xyz, 1.0);
        vBlurCoord[0].xy = aTexCoord;
        
    }