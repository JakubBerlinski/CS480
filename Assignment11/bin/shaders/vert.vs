attribute vec3 v_position;
attribute vec2 v_texCoord;
attribute vec3 v_color;
attribute vec3 v_normal;
varying vec2 tex_coords;
varying vec4 color;
uniform mat4 mvpMatrix;
uniform bool hasTexture;
uniform vec4 ambient, diffuse, specular;
uniform vec4 lightPosition;
uniform float shininess;

void main(void) {
    // get vertex position
    vec3 pos = (mvpMatrix * vec4(v_position,0.0)).xyz;

    // calculate lighting variables
    vec3 L = normalize(lightPosition.xyz - pos);
    vec3 E = normalize(-pos);
    vec3 H = normalize(L + E);
    vec3 N = normalize(mvpMatrix * vec4(v_normal, 0.0)).xyz;

    float kd = max(dot(L,N), 0.0);
    vec4 diffuseValue = kd * diffuse;

    float ks = pow(max(dot(N,H), 0.0), shininess);
    vec4 specularValue = ks * specular;

    // if no light specular color should be black
    if(dot(L,N) < 0.0) {
        specularValue = vec4(0.0,0.0,0.0,0.0);
    }

	tex_coords = v_texCoord;

	// calm down the lighting values
    vec4 ambientValue = ambient * 0.5;
    diffuseValue *= 0.5;
    specularValue *= 0.5;

	if(hasTexture) {
		color = ambientValue + diffuseValue + specularValue;
	}

	else {
    	color = ambientValue + diffuseValue + specularValue + vec4(v_color, 1.0);
	}

    // set vertex position
    gl_Position = mvpMatrix * vec4(v_position, 1.0);
}
