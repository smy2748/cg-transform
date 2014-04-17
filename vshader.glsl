#version 120

attribute vec4 vPosition;
uniform int proj_type;

void main()
{
     //gl_Position =  vPosition;

    float theta = radians(90),
          theta50 = radians(50);
    vec4 cur;
    mat4 scale = mat4(1,0,0,0,
                      0,4,0,0,
                      0,0,1,0,
                      0,0,0,1),
         rotz = mat4(cos(theta), sin(theta),0,0,
         		     -sin(theta),cos(theta),0,0,
         		     0,0,1,0,
         		     0,0,0,1),
         roty = mat4(cos(theta50),0,-sin(theta50),0,
         	         0,1,0,0,
         	         sin(theta50),0,cos(theta50),0,
         	         0,0,0,1),
         trans = mat4(1,0,0,0,
         	          0,1,0,0,
         	          0,0,1,0,
         	          1,0,-1,1)
         		     ;
    cur = scale * vPosition;
    cur = rotz * cur;
    cur = roty * cur;
    cur = trans * cur;

    vec3 eyepoint = vec3(0,3,3),
    	 lookat	  = vec3(1,0,0),
    	 up	      = vec3(0,1,0),
    	 n = normalize(eyepoint-lookat),
    	 u = normalize(cross(up,n)),
    	 v = normalize(cross(n,u));

    mat4 view = mat4(u.x,v.x,n.x,0,
    	             u.y,v.y,n.y,0,
    	             u.z,v.z,n.z,0,
    	             dot(-u, eyepoint),dot(-v,eyepoint),dot(-n,eyepoint),1);
    cur = view * cur;

    float left = -1.5, right = 1, top = 1.5, 
          bttm = -1.5, near = 1, far = 8.5;
    if(proj_type == 2){
	    mat4 ortho = mat4(2/(right-left),0,0,0,
	    	              0, 2/(top-bttm),0,0,
	    	              0,0, -2/(far-near),0,
	    	              -(right+left)/(right-left), -(top + bttm)/(top-bttm),
	    	              -(far+near)/(far-near),1);
	    cur = ortho * cur;
    }
    else if(proj_type == 1){
    	mat4 frust = mat4(2*near/(right-left),0,0,0,
    	                  0,2*near/(top-bttm),0,0,
    	                  (right + left)/(right-left), (top+bttm)/(top-bttm),
    	                  -(far+near)/(far-near), -1,
    	                  0,0,-2*far*near/(far-near),0);
    	cur = frust * cur;
    }
	gl_Position =  cur;    


}
