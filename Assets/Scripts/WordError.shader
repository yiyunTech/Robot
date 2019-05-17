Shader "Custom/WordError" {
	Properties  
    {  
        //_Color ("Color", Color) = (1,1,1,1)  
        _MainTex ("Albedo (RGB)", 2D) = "white" {} 

		_VideoTex("Video", 2D) = "black"{}
		//_VideoTex2("Video2", 2D) = "black"{}
		//_VideoTex1("Video1", 2D) = "black"{}
		
		
		
    }  
    SubShader  
    {  

		Pass {
			CGPROGRAM
			#pragma vertex vert_img
			#pragma fragment frag
			
			#include "UnityCG.cginc"
    
        

			// Use shader model 3.0 target, to get nicer looking lighting  
			//#pragma target 3.0  
    
			sampler2D _MainTex;  
			sampler2D _VideoTex;
			//sampler2D _VideoTex2;

			float _Threshold;
			float _Weight;
			float4 _Color;
		
        
    
			float4 frag(v2f_img i) : COLOR 
			{
				float2 uv = i.uv;
				float4 o;
				
				fixed4 c = tex2D (_MainTex, uv); 
				o.xyz = c.rgb;



				fixed4 s = tex2D (_VideoTex, uv); 

				float weight = (s.r +s.g + s.b)/3.0 - _Threshold;
				weight = weight * _Weight;
				if(weight>0)
				{
					float luminosity = 0.299 * c.r + 0.587 * c.g + 0.114 * c.b;
					c.rgb = _Color * luminosity;
		   			o.xyz = weight * s.rgb + (1.0 - weight) * c.rgb;


						
				}
				
				

				
				o.w = 1.0f;
				return o;
			}  
			ENDCG  

		}
    }  
    FallBack "Diffuse" 
}
