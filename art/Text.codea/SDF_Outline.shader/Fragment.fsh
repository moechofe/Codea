precision highp float;

uniform lowp sampler2D texture;

uniform vec4 fill;
uniform vec4 outline;

uniform lowp float fillWidth;
uniform lowp float fillEdge;

uniform lowp float outlineWidth;
uniform lowp float outlineEdge;

varying lowp vec4 vColor;
varying highp vec2 vTexCoord;

void main()
{
    float distance=1.0-texture2D(texture,vTexCoord).r;
    float fillAlpha=1.0-smoothstep(fillWidth,fillEdge,distance);
    float outlineAlpha=1.0-smoothstep(outlineWidth,outlineEdge,distance);
    float alpha=fillAlpha+(1.0-fillAlpha)*outlineAlpha;
    vec3 color=mix(outline.rgb, fill.rgb, fillAlpha/alpha);
    gl_FragColor=vec4(color*alpha, alpha);
}
